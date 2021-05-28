//
//  WasteDetailLocationViewController.swift
//  Waste2x
//
//  Created by MAC on 26/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol WasteDetailLocationViewControllerDelegate {
    
    func selectedLocationDetail(address : String)
}
class WasteDetailLocationViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var mapView              : GMSMapView!
    @IBOutlet weak var searchbarHolderView  : UIView!
    @IBOutlet weak var searchTextField      : UITextField!
    @IBOutlet weak var searchIcon           : UIImageView!
    @IBOutlet weak var nextButton           : UIButton!
    @IBOutlet weak var placeTableview       : UITableView!
    @IBOutlet weak var consttableviewHeight : NSLayoutConstraint!
    
    // MARK: - Declarations
    
    var locationManager             : CLLocationManager!
    var currentLocation             : CLLocation?
    private var placesClient        : GMSPlacesClient!
    var preciseLocationZoomLevel    : Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    var likelyPlaces                : [GMSPlace] = []
    var selectedPlace               : GMSPlace?
    var marker                      : GMSMarker?
    var delegate                    : WasteDetailLocationViewControllerDelegate?
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        placesClient = GMSPlacesClient.shared()
        
        
        
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
    }

    @IBAction func nextButtonTapped(_ sender: Any) {
        
        if currentLocation != nil {
            convertLocationToAddress(location: currentLocation!) { (success, address) in
                if success
                {
                    self.delegate?.selectedLocationDetail(address: address ?? "")
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension WasteDetailLocationViewController: UITextFieldDelegate
{
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        
//        let placeFields: GMSPlaceField = [.name, .formattedAddress]
//        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: placeFields) { [weak self] (placeLikelihoods, error) in
//            guard let strongSelf = self else {
//                return
//            }
//            
//            guard error == nil else {
//                print("Current place error: \(error?.localizedDescription ?? "")")
//                return
//            }
//            
//            guard let place = placeLikelihoods?.first?.place else {
////                strongSelf.nameLabel.text = "No current place"
////                strongSelf.addressLabel.text = ""
//                return
//            }
//        }
//
//        return true
//    }
}
