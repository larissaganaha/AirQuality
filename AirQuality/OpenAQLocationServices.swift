//
//  OpenAQLocationServices.swift
//  AirQuality
//
//  Created by SERGIO J RAFAEL ORDINE on 22/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class OpenAQLocationServices: LocationServices {
    // let locationsURL = "https://api.openaq.org/v1/locations?country=BR&city=Campinas"
    let locationsURL = "https://api.openaq.org/v1/locations?country=()&order_by[]=sort[]=asc"
    
    var measureServices:MeasurementServices? 
git co
    func retrieveLocations(completion:@escaping ([Location]?) -> Void) {
        
        //Retrieve locations from city
        guard let url = URL(string: locationsURL) else {
            completion(nil)
            return
        }
        
        let urlRequest = URLRequest(url: url)
        

        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: urlRequest) { [unowned self] (data, response, error) in
            
            if (error == nil && data != nil) {
                do {
                    let locationJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    if let locations = self.parseLocations(locationJSON) {
                        
                        //Create updated list
                        var locationList = [Location]()
                        
                        //Create group
                        let measuresGroup = DispatchGroup()
                        
                        //Iterate through all locations, getting its air quality measurement events
                        for location in locations {
                            
                             self.processLocation(location: location, group: measuresGroup, completion: { (reprocessedLocation) in
                                
                                    if let updatedLocation = reprocessedLocation {
                                        locationList.append(updatedLocation)
                                    } else {
                                        locationList.append(location)
                                    }
                                
                             })
                            
                        }
                        
                        //Completion of all measurement processing
                        measuresGroup.notify(queue: DispatchQueue.global(), execute: {
                            completion(locationList)
                        })
                        
                        return
                    }
                } catch {
                    completion(nil)
                }
            }
            
            completion(nil)
            
        }
        
        task.resume()
    }
    
    // MARK: - Auxiliary Methods
    
    func processLocation(location: Location, group : DispatchGroup, completion: @escaping (Location?) ->Void) {
        
        //Entre processing group
        group.enter()
        if let measurement = measureServices {
            measurement.retrieveMeasures(location: location.name, completion: { (measures) in
                //Create dictionary
                var measureMap = [MeasureType:Measure]()
                //Create update location structure
                for measure in measures! {
                    measureMap[measure.type] = measure
                }
                let updatedLocation = Location(name: location.name, measures: measureMap)
                //Add to location list
                completion(updatedLocation)
                //Leave group
                group.leave()
            })
        } else {
            completion(nil)
        }
    }


    
    //MARK: - Location parsing methods
    
    func parseLocations(_ json:Any) -> [Location]? {
        
        var locations = [Location]()
        
        if let rootElement = json as? NSDictionary {
            if let results = rootElement["results"] as? NSArray {
                for locationData in results {
                    if let location = parseLocation(locationData) {
                        locations.append(location)
                    }
                }
            }
        }
        
        return locations

    }
    
    
    func parseLocation(_ json: Any) -> Location? {
        
        if let locationData = json as? NSDictionary {
            
            if let name = locationData["location"] as? String {
                
                let location = Location(name: name, measures: nil)

                return location
                
            }
            
        }
        
        return nil
        
    }
    

    
    
    

}
