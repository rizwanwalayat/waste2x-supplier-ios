//
//  InviteSupplierViewController.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 09/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class InviteSupplierViewController: BaseViewController {
    
    @IBOutlet weak var bottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        mainView.layer.cornerRadius = 36
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        mainView.layer.masksToBounds = true
        mainView.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        globalObjectContainer?.tabbarHiddenView.isHidden = false
        bottomConstraints.constant = tabbarViewHeight
        
    }
    @IBAction func inviteAction(_ sender: Any) {
        let vc = ContactsFetchViewController(nibName: "ContactsFetchViewController", bundle: nil)
        self.navigationController?.pushTo(controller: vc)
        
    }
    

    
}
