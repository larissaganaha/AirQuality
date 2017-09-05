//
//  CityServices.swift
//  AirQuality
//
//  Created by Larissa Ganaha on 04/09/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import Foundation

protocol CityServices {
    
    /// Retrieve locations (just from Campinas)
    ///
    /// - Parameter completion: completion handler, that receives a list of locations in Campinas-SP
    func retrieveCities(code: String, completion:@escaping ([City]?) -> Void)
    
    
}

