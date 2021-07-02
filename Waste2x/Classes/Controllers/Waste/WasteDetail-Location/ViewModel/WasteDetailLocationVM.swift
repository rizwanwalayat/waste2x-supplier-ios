//
//  WasteDetailLocationVM.swift
//  Waste2x
//
//  Created by MAC on 26/05/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import Foundation
import GooglePlaces
import GoogleMaps
import UIKit

// MARK: - GMSMapView Delegate Methods
extension WasteDetailLocationViewController : CLLocationManagerDelegate, GMSMapViewDelegate
{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        currentLocation = location
        print("Location: \(currentLocation)")
        
        let position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: preciseLocationZoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
        marker = GMSMarker(position: position)
        marker?.map = mapView
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        mapView.clear()
        let position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        marker = GMSMarker(position: position)
        marker?.map = mapView
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        currentLocation = location
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Check accuracy authorization
        if #available(iOS 14.0, *) {
            let accuracy = manager.accuracyAuthorization
            switch accuracy {
            case .fullAccuracy:
                print("Location accuracy is precise.")
            case .reducedAccuracy:
                print("Location accuracy is not precise.")
            @unknown default:
                fatalError()
            }
        } else {
            // Fallback on earlier versions
        }
        
        // Handle authorization status
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        @unknown default:
            fatalError()
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    
    
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
                address = "\(address), \(city)"
            }
            // State
            if let state = placeMark.administrativeArea {
                print(state)
                address = "\(address), \(state)"
            }
            // Zip code
            if let zipCode = placeMark.postalCode {
                print(zipCode)
                address = "\(address), \(zipCode)"
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


// MARK: - GMSAutocompleteViewControllerDelegate methods
extension WasteDetailLocationViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place name: \(place.name)")
    print("Place ID: \(place.placeID)")
    print("Place attributions: \(place.attributions)")
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

}
