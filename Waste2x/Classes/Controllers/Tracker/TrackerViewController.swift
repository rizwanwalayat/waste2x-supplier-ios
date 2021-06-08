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
    @IBAction func backAction(_ sender: Any) {
        globalObjectContainer?.tabbarHiddenView.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
}

//extension TrackerViewController:CLLocationManagerDelegate{
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//    print("lcoation delegate call")
//    cameraMoveToLocation(toLocation: locations)
//    self.locationManager.stopUpdatingLocation()
//
//    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
//            if toLocation != nil {
//                mapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 13)
//            }
//        
//        }
//    }
//    
//}
