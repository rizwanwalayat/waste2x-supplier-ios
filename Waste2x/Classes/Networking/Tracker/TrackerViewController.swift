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
    var endingLocation = ""
    var currentLat = Double()
    var currentLon = Double()
    var destinationLat = Double()
    var destinationLng = Double()
    var timer = Timer()
    var trackID = 1
    var ref: DatabaseReference!
    let geofireRef = Database.database().reference().child("dispatch_id")
    @IBOutlet weak var kmLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        initializeTheLocationManager()

        
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
    
    func fetchDate(Starting : String,Ending : String)
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
                
            }
                
            }
            
        }

    }
    @objc func document(notification: Notification) {
        
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
        
        geofireRef.child("\(trackID)").getData { error, data in
            if error == nil{
            //MARK: - For fireBase Location
                let lastChildData = data.children.allObjects.last as? DataSnapshot
                let value = lastChildData?.value! as! [String:Any]
                let lat = value["lat"]!
                let lng = value["lon"]!
                self.destinationLat = lat as! Double
                self.destinationLng = lng as! Double
                self.endingLocation = "\(self.destinationLat),\(self.destinationLng)"
                
            //MARK: - for Current Location
                let location = self.locationManager.location!.coordinate
                self.currentLat = location.latitude
                self.currentLon = location.longitude
                self.currentLocation = "\(String(location.latitude)),\(String(location.longitude))"
                
                
                //MARK: - PolyLine Draw
                if Global.shared.latlngCheck{
                    
                    self.fetchDate(Starting: self.currentLocation, Ending: self.endingLocation)
                    Global.shared.latlngCheck = false
                    let cam = GMSCameraPosition(latitude: self.destinationLat, longitude: self.destinationLng, zoom: 15)
                    DispatchQueue.main.async {
                            self.mapView.animate(to: cam)
                        }
                    
                }
            }
            else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        

        //MARK: -  Marker Draw
        self.markerUpdate(s_lat: self.currentLat, s_lon: self.currentLon, d_lat: self.destinationLat, d_lon: self.destinationLng)
        

    }
    
    
}


