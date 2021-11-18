//
//  LocationPickerViewController.swift
//  CleaningPal
//
//  Created by Bilal Saeed on 7/15/20.
//  Copyright © 2020 Mian Faizan Nasir. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


protocol LocationPickerViewControllerDelegate: AnyObject {
    func didSelectLocation(locationAddress: String, coordinates: CLLocationCoordinate2D, city: String, state: String)
}


class LocationPickerViewController: BaseViewController {
    
    //MARK: - Variables
    private let locationManager = CLLocationManager()
    var myPositionMarker = GMSMarker()
    var placesClient = GMSPlacesClient()
    var searchTerm = ""
    var selectedPlace: GMSPlace!
    var searchResults = [GMSAutocompletePrediction]()
    var sessionToken = GMSAutocompleteSessionToken()
    var isLoadingData = false
    var city = ""
    var state = ""
    weak var delegate: LocationPickerViewControllerDelegate?
    var isForSiteCreation = false
    var selectionData = [String : Any]()
    var pLatitude : Double?
    var pLongitude : Double?
    
    //MARK: - Outlets
    @IBOutlet weak var mapsView: GMSMapView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var constBottomSpaceOfMapView: NSLayoutConstraint!
    @IBOutlet weak var constBottomOfButtonView: NSLayoutConstraint!
    
    
    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isForSiteCreation {
            constBottomSpaceOfMapView.constant = tabbarViewHeight+15
            constBottomOfButtonView.constant = tabbarViewHeight+15
            
        }
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if pLatitude != nil && pLongitude != nil {
            
            let coordinates = CLLocationCoordinate2DMake(pLatitude!, pLongitude!)
            locationManager.stopUpdatingLocation()
            mapsView.camera = GMSCameraPosition(target: coordinates, zoom: 15, bearing: 0, viewingAngle: 0)
            myPositionMarker.position = coordinates
            getAddressFromLatLon()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationSetup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    //MARK: - View Setup
    func setupView() {
        Utility.setPlaceHolderTextColor(searchTextField, "Search", #colorLiteral(red: 0.6392156863, green: 0.6352941176, blue: 0.6745098039, alpha: 1))
        tableView.dataSource = self
        tableView.delegate = self
        mapsView.delegate = self
        //myPositionMarker.icon = #imageLiteral(resourceName: "ic_pin")
        myPositionMarker.map = mapsView
    }
    
    func locationSetup() {
        locationManager.delegate = self
        
        switch(CLLocationManager.authorizationStatus()) {
            
        case .restricted, .denied:
            Utility.showAlertController(self, "Application uses location data for navigations and maps. Kindly enable location services in order to use the application.")
//            self.showOkAlertWithOKCompletionHandler("Application uses location data for navigations and maps. Kindly enable location services in order to use the application.") { ( _) in
//                UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL)
//            }
            
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        default:
            break
        }
    }
    
    
    //MARK: - Actions
    @IBAction func searhTextChanged(_ sender: Any) {
        
        tableView.isHidden = searchTextField.text == "" ? true : false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            if self?.searchTerm == self?.searchTextField.text && !(self?.isLoadingData ?? false) {
                self?.searchResults.removeAll()
                self?.tableView.reloadData()
                self?.isLoadingData = true
                self?.fetchLocations(query: self?.searchTerm ?? "")
            }
        }
        
        searchTerm = searchTextField.text ?? ""
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
            
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func useThisLocationTapped(_ sender: Any) {
        delegate?.didSelectLocation(locationAddress: locationLabel.text ?? "", coordinates: myPositionMarker.position, city: city, state: state)
        
        if isForSiteCreation {
            
            selectionData["latitude"] = myPositionMarker.position.latitude
            selectionData["longitude"] = myPositionMarker.position.longitude
            
            self.postDataToServer()
        }
        else {
            
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
                
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
            
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    //MARK: - Private Methods
    func getAddressFromLatLon() {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let geoCoder = GMSGeocoder()
        center.latitude = myPositionMarker.position.latitude
        center.longitude = myPositionMarker.position.longitude
        
        geoCoder.reverseGeocodeCoordinate(center) { (response, error) in
            
            if error == nil {
                
                if let response = response {
                    
                    if let pm = response.firstResult() {
                        
                        var addressString : String = ""
                        
                        if let name = pm.thoroughfare {
                            addressString = addressString + name + ", "
                        }
                        
                        if let subLocality = pm.subLocality {
                            addressString = addressString + subLocality + ", "
                        }
                        
                        if let locality = pm.locality {
                            self.city = locality
                            addressString = addressString + locality + ", "
                        }
                        
                        if let admin = pm.administrativeArea {
                            self.state = admin
                            addressString = addressString + admin + ", "
                        }
                        
                        if let country = pm.country {
                            addressString = addressString + country
                        }
                        
                        self.locationLabel.text = addressString
                    }
                }
            }
        }
    }
    
    private func fetchLocations(query: String) {
        
        placesClient.findAutocompletePredictions(fromQuery: query, filter: nil, sessionToken: sessionToken) { (data, error) in
            
            if error == nil {
                
                if let results = data {
                    self.searchResults = results
                    self.tableView.reloadData()
                    self.isLoadingData = false
                }
                
            } else {
               // self.showOkAlert(error?.localizedDescription ?? "")
            }
        }
    }
    
    private func fetchLocationDetails(placeID: String) {
        
        placesClient.fetchPlace(fromPlaceID: placeID, placeFields: .coordinate, sessionToken: sessionToken) { (data, error) in
            
            if error == nil {
                self.selectedPlace = data
                
                if let dta = data {
                    let cameraPosition = GMSCameraPosition.camera(withLatitude: dta.coordinate.latitude, longitude: dta.coordinate.longitude, zoom: 15.0)
                    self.mapsView.animate(to: cameraPosition)
                    self.myPositionMarker.position = dta.coordinate
                    self.getAddressFromLatLon()
                }
                
            } else {
                //self.showOkAlert(error?.localizedDescription ?? "")
                Utility.showAlertController(self, error?.localizedDescription ?? "")
            }
        }
    }
}


//MARK: - CLLocationManagerDelegate
extension LocationPickerViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        mapsView.isMyLocationEnabled = true
        mapsView.settings.myLocationButton = true
    }
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        if pLatitude == nil
        {
            locationManager.stopUpdatingLocation()
            mapsView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            myPositionMarker.position = location.coordinate
            getAddressFromLatLon()
        }
    }
}


//MARK: - TableView DataSource & Delegate
extension LocationPickerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.register(GoogleLocationAutoCompleteTableViewCell.self, indexPath: indexPath)
        cell.configure(data: searchResults[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        fetchLocationDetails(placeID: searchResults[indexPath.row].placeID)
        searchTextField.attributedText = searchResults[indexPath.row].attributedPrimaryText
        sessionToken = GMSAutocompleteSessionToken()
        self.tableView.isHidden = true
    }
}


//MARK: - GMSMapViewDelegate
extension LocationPickerViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        myPositionMarker.position = coordinate
        getAddressFromLatLon()
    }
}

//MARK: - Api Callings
extension LocationPickerViewController
{
    func postDataToServer()
    {
//        if Global.shared.apiCurve {
//
//        }
        
        selectionData["email"] = DataManager.shared.getUserEmail()
        
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
                    vc.selectionData = self.selectionData
                    vc.successData = message
                    vc.createSiteDataModel = data
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
            Utility.CurrentSitesViewController()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
