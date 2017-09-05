//
//  CityViewController.swift
//  AirQuality
//
//  Created by Larissa Ganaha on 04/09/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {

    var cities:[City]? = [City]()
    
    var code = String()
    var cityName: String = ""

    
    //MARK: - Services
    var cityServices: CityServices = OpenAQCitiesServices()
    
    @IBOutlet weak var cityTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = code
        
        // Do any additional setup after loading the view.
        
        cityServices.retrieveCities(code: code, completion: { [unowned self] (cities) in
            self.cities = cities
            //TODO: Assynchronously update Country table view
            DispatchQueue.main.async { [unowned self] in
                self.cityTable.reloadData()
            }
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let LocationInfo = segue.destination as! LocationViewController
        LocationInfo.code = code
        LocationInfo.cityName = cityName
        print(code)
        print(cityName)
    }
    
}


extension CityViewController:UITableViewDataSource, UITableViewDelegate {
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityCell
        
        let city = cities?[indexPath.row]
        
        cell.cityName.text = city?.name
        cell.locationCount.text = String(describing: cities![indexPath.row].locations!)
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities?.count ?? 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        code = (cities?[indexPath.row].code)!
        cityName = (cities?[indexPath.row].name)!
        
        performSegue(withIdentifier: "showMeasures", sender: self)
    }

    
}

