//
//  Global.swift
//  StacyView
//
//  Created by Haider Awan on 11/01/2021.
//

import Foundation
import UIKit
import CoreLocation

class Global {
    class var shared : Global {
        struct Static {
            static let instance : Global = Global()
        }
        return Static.instance
    }
    
    var currentNavigationController = BaseNavigationViewController()
    var currentStoryBoard = ""
    var currentController = ""
    var didRecievedNotiFication = Bool()
    var is_new_user = true
    var current_lat = Double()
    var current_lng = Double()
    var location = CLLocation()
    
    
    
    func convertLocationToAddress(location: CLLocation, _ completionHandler: ((Bool, String?) -> Void)?)
    {
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var address = ""
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Location name
//            if let locationName = placeMark.location {
//                print(locationName)
//                address = "\(locationName)"
//            }
            // Street address
            if let street = placeMark.thoroughfare {
                print(street)
                address = "\(street)"
            }
            // City
            if let city = placeMark.locality {
                print(city)
                address = "\(address) \(city)"
            }
            // State
            if let state = placeMark.administrativeArea {
                print(state)
                address = "\(address) \(state)"
            }
            // Zip code
            if let zipCode = placeMark.postalCode {
                print(zipCode)
                address = "\(address) \(zipCode)"
            }
            // Country
            if let country = placeMark.country {
                print(country)
                address = "\(address), \(country)."
            }
            
            if !Utility.isBlankString(text: address) {
                completionHandler!(true, address)
            }
            else
            {
                completionHandler!(false, nil)
            }
        })
        
    }
    
}
