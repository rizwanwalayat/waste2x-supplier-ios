//
//  ProfileViewController.swift
//  CarrierApp
//
//  Created by MAC on 18/10/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var userImage:UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPhone: UITextField!
    @IBOutlet weak var mainView: UIView!
    
    var viewModel: ProfileEditVM?
    // MARK: - Controller's lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainView.layer.cornerRadius = 36
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        mainView.layer.masksToBounds = true
        
        viewModel = ProfileEditVM()
        populateUserData()
    }
    
    // MARK: - Actions
    @IBAction func editBtnPressed(_ sender: Any) {
        let popupVC = PopupProfileEdit(nibName: "PopupProfileEdit", bundle: nil)

        popupVC.changedUserName = {
            self.populateUserData()
        }
        popupVC.viewModel = self.viewModel
        popupVC.modalPresentationStyle = .overFullScreen
        self.present(popupVC, animated: false, completion: nil)
    }
    
    @IBAction func editPhotoPressed(_ sender: UIButton){
        ImagePickerVC.shared.showImagePickerFromVC(fromVC: self)
        
    }
    
    @IBAction func menuButtonPressed(_ sender: UIButton){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func imageSelectedFromGalleryOrCamera(selectedImage: UIImage) {
        uploadImageToserver(selectedImage)
    }
    
    fileprivate func populateUserData(){
        
        viewModel?.getUserData()
        userName.text = viewModel?.userName
        userEmail.text = viewModel?.userEmail
        userPhone.text = viewModel?.userPhone
        
        
        self.downloadImageFromServer(viewModel?.userImage ?? "") { image, error, success in

            self.userImage.stopAnimating()
            if success ?? false && image != nil {
                self.userImage.image = image
            }
        }
    }
    
    fileprivate func uploadImageToserver(_ imageToUplaod: UIImage )
    {
        viewModel?.uploadImage(imageToUplaod, { response, error, success, message in

            if (success ?? false), error == nil {

                // to save record on userDefults
                if let resultString = response?.result?.toJSONString() {
                    
                    DataManager.shared.saveUsersDetail(resultString)
                }

                self.populateUserData()

            } else {

                self.showToast(message: error?.localizedDescription ?? message)
            }
        })
    }
}
