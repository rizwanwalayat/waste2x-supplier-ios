//
//  BaseViewController.swift
//  Doro
//
//  Created by HaiD3R AwaN on 20/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var tabbarViewHeight : CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabbarViewHeight = (UIScreen.main.bounds.height * 0.0926339)+10
        print("Bottom Const : \(tabbarViewHeight)\nscreen height : \(UIScreen.main.bounds.height)")
    }

    /**************************************************/
    
    @objc func imageSelectedFromGalleryOrCamera(selectedImage:UIImage){
        
    }
}
