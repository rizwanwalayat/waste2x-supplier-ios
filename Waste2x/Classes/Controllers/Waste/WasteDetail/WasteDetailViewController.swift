//
//  WasteDetailViewController.swift
//  Waste2x
//
//  Created by MAC on 25/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
import GoogleMaps

class WasteDetailViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var detailHolderview     : UIView!
    @IBOutlet weak var wasteTitleImageview  : UIImageView!
    @IBOutlet weak var wasteTitleLable      : UILabel!
    @IBOutlet weak var siteTitleLabel       : UILabel!
    @IBOutlet weak var siteDetailLabel      : UILabel!
    @IBOutlet weak var sizeTitleLabel       : UILabel!
    @IBOutlet weak var sizeDetailLabel      : UILabel!
    @IBOutlet weak var editButton           : UIButton!
    @IBOutlet weak var addressLabel         : UILabel!
    @IBOutlet weak var photosLabel          : UILabel!
    @IBOutlet weak var collectionviewImages : UICollectionView!
    @IBOutlet weak var takePictureButton    : UIButton!
    
    @IBOutlet weak var bottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var collectionViewConst: NSLayoutConstraint!
    @IBOutlet weak var blinderView: UIView!
    
    // MARK: - Declarations
    var imagesDataArray = [ImagesCollectionViewData]() //[UIImage]()
    var farmID = -1
    var wasteDeatil : WasteDetialResult?
    var postDictToSaveImage = [String : Any]()
    var postDictToUpdateSize = [String : Any]()
    var postDictToUpdateLocation = [String : Any]()
    var latitude = 0.0
    var longitude = 0.0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postDictToSaveImage["latitude"] = Global.shared.current_lat
        postDictToSaveImage["longitude"] = Global.shared.current_lng
        postDictToSaveImage["farm_id"] = farmID
        postDictToUpdateSize["farm_id"] = farmID
        postDictToUpdateLocation["farm_id"] = farmID
        
        setupviews()
        self.fetchDataFromServer()
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
         bottomConstraints.constant = tabbarViewHeight+10
    }
    
    
    fileprivate func setupviews()
    {
        detailHolderview.dropShadow(color: UIColor(hexString: "969696", alpha: 1), opacity: 0.15, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        collectionviewImages.register(UINib(nibName: "WasteImageDetailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WasteImageDetailCollectionViewCell")
    }
    // MARK: - Action
    @IBAction func editButtonPressed(_ sender: Any) {
        
        let custompopup                      = NewWasteSizeViewController(nibName: "NewWasteSizeViewController", bundle: nil)
        custompopup.modalPresentationStyle   = .overFullScreen
        custompopup.delegate                 = self
        custompopup.lastSelectedSize         = sizeDetailLabel.text ?? ""
        self.present(custompopup, animated: false, completion: nil)
    }
    
    @IBAction func editAddressButton(_ sender : UIButton)
    {
        //let wasteDetailLocation            = WasteDetailLocationViewController(nibName: "WasteDetailLocationViewController", bundle: nil)
        let wasteDetailLocation            = LocationPickerViewController(nibName: "LocationPickerViewController", bundle: nil)
        wasteDetailLocation.delegate = self
        wasteDetailLocation.pLatitude = latitude
        wasteDetailLocation.pLongitude = longitude
        self.navigationController?.pushViewController(wasteDetailLocation, animated: true)
    }
    
    @IBAction func takePictureButtonTapped(_ sender: Any) {
        
        ImagePickerVC.shared.showImagePickerFromVC(fromVC: self)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    

    @objc override func imageSelectedFromGalleryOrCamera(selectedImage:UIImage){
        
        // api call
        postDictToSaveImage["farm_image"] = selectedImage
        imageToUpload()
    }
    
    func updateImageLibrary(_ image : UIImage, time : String)
    {
        let imageData = ImagesCollectionViewData(image, time)
        imagesDataArray.append(imageData)
        collectionviewImages.reloadData()
        if imagesDataArray.count > 0 && !(collectionViewConst.constant > 0)
        {
            self.collectionViewConst.constant = 145
            UIView.animate(withDuration: 0.3,
                       delay: 0.1,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: { () -> Void in
                        
                        self.view.layoutIfNeeded()
                        
            }, completion: { (finished) -> Void in
            // ....
            })
        }
        
        let indexPath = IndexPath(item: imagesDataArray.count - 1, section: 0)
        collectionviewImages.scrollToItem(at: indexPath, at: .right, animated: true)
    }
    
    
    func convertLocationToAddress(location: CLLocationCoordinate2D, _ completionHandler: ((Bool, String?) -> Void)?)
    {
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
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


