//
//  OpenAQCitiesServices.swift
//  AirQuality
//
//  Created by Larissa Ganaha on 04/09/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class OpenAQCitiesServices: CityServices {

    let citiesURL = "https://api.openaq.org/v1/cities?country="
    
    func retrieveCities(code: String, completion:@escaping ([City]?) -> Void) {
        
        let fullURL = "\(citiesURL)\(code)"
        print(fullURL)
        
        guard let url = URL(string: fullURL) else {
            completion(nil)
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if (error == nil && data != nil) {
                do {
                    let countryJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    let cities = self.parseCities(countryJSON)
                    completion(cities)
                } catch {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    //MARK: Countries JSON parsinh methods
    
    
    /// Parse the country list
    ///
    /// - Parameter json: JSON fragment containgin the countries list
    /// - Returns: List of countries parsed from JSON
    func parseCities(_ json:Any) -> [City]? {
        
        var cities = [City]()
        
        if let rootElement = json as? NSDictionary {
            if let results = rootElement["results"] as? NSArray {
                for cityData in results {
                    if let city = parseCity(cityData) {
                        cities.append(city)
                    }
                }
            }
        }
        
        return cities
        
    }
    
    
    /// Parse a country data from JSON
    ///
    /// - Parameter json: JSOn fragment containing the country definition
    /// - Returns: A country parsed from given JSON, if valid, nil otherwise
    func parseCity(_ json: Any) -> City? {
        
        if let cityData = json as? NSDictionary {
            
            if let name = cityData["city"] as? String,
                let country = cityData["country"] as? String,
                let locations = cityData["locations"] as? Int{
                return City(name: name, code: country, locations: locations)
            }
            
        }
        
        return nil
        
    }
    

    
}
