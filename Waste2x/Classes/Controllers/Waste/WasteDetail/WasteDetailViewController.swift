//
//  WasteDetailViewController.swift
//  Waste2x
//
//  Created by MAC on 25/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

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
    var imagesArray = [UIImage]()
    var farmID = -1
    var wasteDeatil : WasteDetialResult?
    var postDictToSaveImage = [String : Any]()
    var postDictToUpdateSize = [String : Any]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postDictToSaveImage["latitude"] = Global.shared.current_lat
        postDictToSaveImage["longitude"] = Global.shared.current_lng
        postDictToSaveImage["farm_id"] = farmID
        postDictToUpdateSize["farm_id"] = farmID
        
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
        self.present(custompopup, animated: false, completion: nil)
    }
    
    @IBAction func editAddressButton(_ sender : UIButton)
    {
        let wasteDetailLocation            = WasteDetailLocationViewController(nibName: "WasteDetailLocationViewController", bundle: nil)
        wasteDetailLocation.delegate       = self
        self.navigationController?.pushViewController(wasteDetailLocation, animated: true)
    }
    
    @IBAction func takePictureButtonTapped(_ sender: Any) {
        
        ImagePickerVC.shared.showImagePickerFromVC(fromVC: self)
    }

    @objc override func imageSelectedFromGalleryOrCamera(selectedImage:UIImage){
        
        // api call
        postDictToSaveImage["farm_image"] = selectedImage
        imageToUpload()
    }
    
    func updateImageLibrary(_ image : UIImage)
    {
        imagesArray.append(image)
        collectionviewImages.reloadData()
        if imagesArray.count > 0 && !(collectionViewConst.constant > 0)
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
        
        let indexPath = IndexPath(item: imagesArray.count - 1, section: 0)
        collectionviewImages.scrollToItem(at: indexPath, at: .right, animated: true)
    }
    
}


