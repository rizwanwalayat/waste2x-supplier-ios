//
//  BaseNavigationViewController.swift
//  BROWZO
//
//  Created by Armughan on 18/05/2020.
//  Copyright © 2020 Abye. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {
//    weak var containerController : UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    

}
