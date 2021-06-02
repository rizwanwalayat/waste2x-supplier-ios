//
//  BaseViewController.swift
//  Doro
//
//  Created by HaiD3R AwaN on 20/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var headerViewHeight : CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerViewHeight = UIScreen.main.bounds.height * 0.0926339
        print("Bottom Const : \(headerViewHeight)\nscreen height : \(UIScreen.main.bounds.height)")
    }

    /**************************************************/
    
    @objc func imageSelectedFromGalleryOrCamera(selectedImage:UIImage){
        
    }
}
