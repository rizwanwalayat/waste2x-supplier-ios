//
//  TrackerViewController.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 04/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit
import GoogleMaps
import FirebaseDatabase

class TrackerViewController: BaseViewController {
    //MARK: - Variables
    var locationManager = CLLocationManager()
    var startingLocation = ""
    var endingLocation = ""
    var startingLat = Double()
    var startingLon = Double()
    var endingLat = Double()
    var endingLng = Double()
    var zoom: Float?
    var timer = Timer()
    var trackID = 1
    let dataBase = Database.database().reference().child("dispatch_id")
    @IBOutlet weak var kmLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        mainView.layer.cornerRadius = 36
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        mainView.layer.masksToBounds = true
        globalObjectContainer?.tabbarHiddenView.isHidden = true
        initializeTheLocationManager()
        
        dataBase.child("\(trackID)").observe(.childAdded) { DataSnapshot in
            if let location = DataSnapshot.value as? [String: Any] {
                self.startingLat = location["lat"] as? Double ?? 0.00
                self.startingLon = location["lon"] as? Double ?? 0.00
                self.startingLocation = "\(self.startingLat), \(self.startingLon)"
                self.loadMap()
            }
        }
    }
    
    
    //MARK: - Functions
    
    func loadMap() {
        self.mapView.clear()
        self.fetchGoogleMapData(Starting: self.startingLocation, Ending: self.endingLocation)
        self.markerUpdate(s_lat: self.startingLat, s_lon: self.startingLon, d_lat: self.endingLat, d_lon: self.endingLng)
    }
    
    func initializeTheLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func markerUpdate(s_lat : Double,s_lon:Double,d_lat:Double,d_lon:Double){
        
        // MARK: Marker for source location
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: s_lat, longitude: s_lon)
        marker.title = "Starting"
        marker.icon = UIImage (named: "startmark")
        
        
        
        // MARK: Marker for destination location
        let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2D(latitude: d_lat, longitude: d_lon)
        marker1.title = "Ending"
        marker1.icon = UIImage (named: "endmark")
        
        
        DispatchQueue.main.async {
            marker.map = self.mapView
            marker1.map = self.mapView
            
        }
    }
    
    func fetchGoogleMapData(Starting : String,Ending : String)
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
                    polyline.strokeColor = UIColor(named: "lineColor")!
                    polyline.strokeWidth = 5
                    polyline.geodesic = true
                    polyline.map = self.mapView
                    
                    if (self.zoom != nil) {
                        let bounds = GMSCoordinateBounds(path: path!)
                        DispatchQueue.main.async {
                            self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
                        }
                    }
                }
            }
        }
    }
    
    @objc func timerAction() {
        dataBase.child("\(trackID)").getData { error, data in
            if error == nil{
                //MARK: - For fireBase Location Again
                
                let lastChildData = data.children.allObjects.first as? DataSnapshot
                let value = lastChildData?.value! as! [String:Any]
                let lat = value["lat"]!
                let lng = value["lon"]!
                self.endingLat = lat as! Double
                self.endingLng = lng as! Double
                self.endingLocation = "\(self.endingLat),\(self.endingLng)"
                //MARK: -  Marker Draw again
                // MARK: Marker for destination location
                let marker1 = GMSMarker()
                marker1.position = CLLocationCoordinate2D(latitude: self.endingLat, longitude: self.endingLng)
                marker1.title = "Ending"
                marker1.icon = UIImage (named: "endmark")
                
                self.markerUpdate(s_lat: self.endingLat, s_lon: self.endingLng, d_lat: self.startingLat, d_lon: self.startingLon)
            }
        }
        
    }
    //
    //MARK: - IBOutlets
    
    @IBAction func backAction(_ sender: Any) {
        globalObjectContainer?.tabbarHiddenView.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    func delegateForttracking(){
        dataBase.child("\(trackID)").getData { error, data in
            if error == nil{
                
                
                //MARK: - for Current Location
                
                let location = self.locationManager.location!.coordinate
                self.startingLat = location.latitude
                self.startingLon = location.longitude
                self.startingLocation = "\(String(location.latitude)),\(String(location.longitude))"
                
                //MARK: - For fireBase Location
                
                let lastChildData = data.children.allObjects.last as? DataSnapshot
                let value = lastChildData?.value! as! [String:Any]
                let lat = value["lat"]!
                let lng = value["lon"]!
                self.endingLat = lat as! Double
                self.endingLng = lng as! Double
                self.endingLocation = "\(self.endingLat),\(self.endingLng)"
                
                
                //MARK: - PolyLine Draw
                
                if Global.shared.latlngCheck{
                    self.mapView.clear()
                    self.fetchGoogleMapData(Starting: self.startingLocation, Ending: self.endingLocation)
                    //                        Global.shared.latlngCheck = false
                    let cam = GMSCameraPosition(latitude: self.endingLat, longitude: self.endingLng, zoom: 15)
                    
                    
                    //MARK: -  Marker Draw
                    
                    self.markerUpdate(s_lat: self.endingLat, s_lon: self.endingLng, d_lat: self.startingLat, d_lon: self.startingLon)
                    DispatchQueue.main.async {
                        self.mapView.animate(to: cam)
                    }
                    
                }
            }
            else {
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
}

//MARK: - MapView

extension TrackerViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location delegate call")
        
        if let location = locations.last {
            self.endingLat = location.coordinate.latitude
            self.endingLng = location.coordinate.longitude
            self.endingLocation = "\(location.coordinate)"
        }
        
        //        delegateForttracking()
        //        self.locationManager.stopUpdatingLocation()
        
    }
}

extension TrackerViewController:GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.zoom = mapView.camera.zoom
    }
}


