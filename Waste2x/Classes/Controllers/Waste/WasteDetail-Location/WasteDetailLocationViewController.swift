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
    @IBOutlet weak var titleLabel           : UILabel!
    @IBOutlet weak var constBottom          : NSLayoutConstraint!
    
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
    var isForSiteCreation           = false
    
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
        
        mapView.roundCorners(uiViewCorners: .top, radius: 32)
        
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
        
        // screen is reusing for site Creation add condition for that puropose to set flow of applcation
        if isForSiteCreation {
            
            let vc = SiteCreatedViewController(nibName: "SiteCreatedViewController", bundle: nil)
            self.navigationController?.pushTo(controller: vc)
        }
        else {
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension WasteDetailLocationViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
//        let autocompleteController = GMSAutocompleteViewController()
//            autocompleteController.delegate = self
//
//            // Specify the place data types to return.
//            let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue))
//            autocompleteController.placeFields = fields
//
//            // Specify a filter.
//            let filter = GMSAutocompleteFilter()
//            filter.type = .address
//            autocompleteController.autocompleteFilter = filter
//
//            // Display the autocomplete view controller.
//            present(autocompleteController, animated: true, completion: nil)
//        let dropDownVC = CustomDropDownViewController(nibName: "CustomDropDownViewController", bundle: nil)
//        dropDownVC.modalPresentationStyle   = .overFullScreen
//        dropDownVC.frameAdjustment = searchbarHolderView.bounds
//        dropDownVC.searchText = textField.text ?? ""
//        self.present(dropDownVC, animated: false, completion: nil)
        
        return true
    }
}

