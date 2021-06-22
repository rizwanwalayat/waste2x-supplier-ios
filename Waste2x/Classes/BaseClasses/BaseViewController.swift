//
//  BaseViewController.swift
//  haid3r
//
//  Created by HaiD3R AwaN on 20/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
import SDWebImage

class BaseViewController: UIViewController {

    var tabbarViewHeight : CGFloat = 0.0
    var userData : RegistrationResult?
    override func viewDidLoad() {
        super.viewDidLoad()
        userData = DataManager.shared.getUser()?.result
        tabbarViewHeight = (UIScreen.main.bounds.height * 0.0926339)+10
        print("Bottom Const : \(tabbarViewHeight)\nscreen height : \(UIScreen.main.bounds.height)")
    }

    /**************************************************/
    
    @objc func imageSelectedFromGalleryOrCamera(selectedImage:UIImage){
        
    }
    
    func setImage(imageView:UIImageView,url:URL,placeHolder : String = "dummy")  {
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_imageIndicator?.startAnimatingIndicator()
        imageView.sd_setImage(with: url) { (img, err, cahce, URI) in
            imageView.sd_imageIndicator?.stopAnimatingIndicator()
            if err == nil{
                imageView.image = img
            }else{
                imageView.image = UIImage(named: placeHolder)
            }
        }
    }
}
