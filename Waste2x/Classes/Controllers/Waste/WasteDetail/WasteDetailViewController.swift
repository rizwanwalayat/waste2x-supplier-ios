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
    
    // MARK: - Declarations
    var imagesArray               = [UIImage]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupviews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        Global.shared.convertLocationToAddress(location: Global.shared.location) { (success, address) in
                if success
                {
                    self.addressLabel.text = address ?? ""
                }
            }
        globalObjectContainer?.tabbarHiddenView.isHidden = false
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
        imagesArray.append(selectedImage)
        collectionviewImages.reloadData()
    }
}


