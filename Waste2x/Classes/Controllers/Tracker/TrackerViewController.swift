//
//  TrackerViewController.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 04/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
import GoogleMaps

class TrackerViewController: BaseViewController {
//MARK: - Variables
    var locationManager = CLLocationManager()
    var currentLocation = ""
    var currentLat = Double()
    var currentLon = Double()
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        mainView.layer.cornerRadius = 36
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        mainView.layer.masksToBounds = true
        globalObjectContainer?.tabbarHiddenView.isHidden = true
        
    }
    
    //MARK: - Functions
    
    func initializeTheLocationManager() {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        
        }
    
    //MARK: - IBOutlets
    
    @IBAction func backAction(_ sender: Any) {
        globalObjectContainer?.tabbarHiddenView.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - MapView

extension TrackerViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
print("lcoation delegate call")
        let location = locationManager.location!.coordinate
        self.currentLat = location.latitude
        self.currentLon = location.longitude
        GMSCameraPosition.camera(withTarget: location, zoom: 13)
        let gmsMarker = GMSMarker()
        self.currentLocation = "\(String(location.latitude)),\(String(location.longitude))"
        self.locationManager.stopUpdatingLocation()
        
    }
    
}


