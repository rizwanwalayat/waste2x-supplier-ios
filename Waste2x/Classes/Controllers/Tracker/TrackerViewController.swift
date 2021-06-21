//
//  TrackerViewController.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 04/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
import GoogleMaps
import GeoFire

class TrackerViewController: BaseViewController {
//MARK: - Variables
    var locationManager = CLLocationManager()
    var currentLocation = ""
    var endingLocation = "31.4504,73.1350"
    var currentLat = Double()
    var currentLon = Double()
    var destinationLat = 31.4504
    var destinationLng = 73.1350
    var timer = Timer()
    let geofireRef = Database.database().reference().child("dispatch_id")
    @IBOutlet weak var kmLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTheLocationManager()
//        let geofireRef = Database.database().reference().child("dispatch_id")
//
        
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
    
    func fetchDate(Starting : String,Ending : String,s_lat : Double,s_lon:Double,d_lat:Double,d_lon:Double)
    {   mapView.clear()
        print(Starting,Ending)
        APIRoutes.polyLineUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=\(Starting)&destination=\(Ending)&mode=driving&key=\(googleAPIKey)"
        print(APIRoutes.polyLineUrl)
        PolyLineAPIModel.PolyLineAPICall { jsonData, error, status, message in
            if jsonData?.routes != nil{
                
                
            for item in jsonData!.routes {
                self.addressLabel.text = item.legs[0].end_address
                self.timeLabel.text = item.legs[0].duration?.text
                self.kmLabel.text = item.legs[0].distance?.text
                let points = item.overviewPolyline?.points
                let path = GMSPath.init(fromEncodedPath: points ?? "")
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeColor = .systemBlue
                polyline.strokeWidth = 5
                polyline.map = self.mapView
                
            }
                
            }
            
        }
        // MARK: Marker for source location
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: s_lat, longitude: s_lon)
        marker.title = "Starting"
        marker.icon = UIImage (named: "startmark")
        marker.map = self.mapView
                
                
        // MARK: Marker for destination location
        let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2D(latitude: d_lat, longitude: d_lon)
        marker1.title = "Ending"
        marker1.icon = UIImage (named: "endmark")
        marker1.map = self.mapView
        
        
        let camera = GMSCameraPosition(target: marker.position, zoom: 15)
        
        
        DispatchQueue.main.async {
                self.mapView.animate(to: camera)
            }
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
        self.currentLocation = "\(String(location.latitude)),\(String(location.longitude))"
        self.fetchDate(Starting: self.currentLocation, Ending: self.endingLocation, s_lat: self.destinationLat, s_lon: self.destinationLng, d_lat: self.currentLat, d_lon: self.currentLon)
        self.locationManager.stopUpdatingLocation()
        
    }
    
}


