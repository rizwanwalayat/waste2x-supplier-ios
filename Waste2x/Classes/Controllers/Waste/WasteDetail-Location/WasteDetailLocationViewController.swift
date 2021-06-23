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
    func selectedLatitudeLongitude(latitude: CLLocationDegrees, longitude : CLLocationDegrees)
    
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
    var selectionData               = [String : Any]()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configLocation()
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        if !isForSiteCreation {
            constBottom.constant = tabbarViewHeight+15
            
        }
        
        mapView.layer.cornerRadius = 36
        mapView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        mapView.layer.masksToBounds = true
        mapView.clear()
        
    }
    
    //MARK: - Functions
    
    func configLocation(){
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
    
    
//MARK: - IBOutlets
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        if currentLocation != nil {
            convertLocationToAddress(location: currentLocation!) { (success, address) in
                if success
                {
                    self.delegate?.selectedLocationDetail(address: address ?? "")
                }
            }
            
            delegate?.selectedLatitudeLongitude(latitude: currentLocation!.coordinate.latitude, longitude: currentLocation!.coordinate.longitude)
            selectionData["latitude"] = currentLocation!.coordinate.latitude
            selectionData["longitude"] = currentLocation!.coordinate.longitude
            // screen is reusing for site Creation add condition for that puropose to set flow of applcation
            if isForSiteCreation {
                
                self.postDataToServer()
            }
            else {
                
                self.navigationController?.popViewController(animated: true)
            }
        }
        else
        {
            Utility.showAlertController(self, "Please select location, first")
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}


//MARK: - Extentions

extension WasteDetailLocationViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
}


// MARK: - API Calls Handlings
extension WasteDetailLocationViewController {
    
    
    func postDataToServer()
    {
        if Global.shared.apiCurve {
            
            selectionData["phone"] = userData?.phone ?? ""
            selectionData["email"] = userData?.email ?? ""
        }
        
        let postDict = selectionData as [String : AnyObject]
        
        CreateSiteDataModel.postSiteCreateData(params: postDict, { data, error, code,message in
            
            if error != nil
            {
                self.alertHandlings(error!.localizedDescription)
            }
            
            if code == true {
                
                if data != nil {
                    
                    let vc = SiteCreatedViewController(nibName: "SiteCreatedViewController", bundle: nil)
                    vc.modalPresentationStyle = .overFullScreen
                    vc.successData = message
                    self.present(vc, animated: true, completion: nil)
                }
                else
                {
                    self.alertHandlings(message)
                }
            }
            else
            {
                self.alertHandlings(message)
            }
        })
    }
    
    func alertHandlings(_ message : String)
    {
        let alertController = UIAlertController(title: "Failed", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Go Home", style: .default, handler: { action in
            Utility.homeViewController()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}


