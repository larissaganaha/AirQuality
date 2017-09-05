//
//  LocationViewController.swift
//  AirQuality
//
//  Created by SERGIO J RAFAEL ORDINE on 22/08/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    
    
    @IBOutlet weak var locationTable: UITableView!
    
    var locations:[Location]? = [Location]()
    
    var code = String()
    var cityName = String()

    
    //MARK: - Services
    var countryServices: LocationServices = OpenAQLocationServices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Inversion of Control
        countryServices.measureServices = OpenAQMeasureServices()
        
        // Do any additional setup after loading the view.
        
        countryServices.retrieveLocations(completion: { [unowned self] (locations) in

            self.locations = locations
           
            DispatchQueue.main.async { [unowned self] in
                self.locationTable.reloadData()
                print(self.locations ?? "")
            }
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


//TODO: Implement this!!
extension LocationViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationCell
        
        //cell.locationName.text = locations?[indexPath.row].name
        //self.locations?.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending }
        return cell
    }

    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations?.count ?? 0
    }
    

    
}
