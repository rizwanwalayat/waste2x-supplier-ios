//
//  SiteCreatedViewController.swift
//  Waste2x
//
//  Created by MAC on 08/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class SiteCreatedViewController: BaseViewController {

    
    // MARK: - Outlets
    
    @IBOutlet weak var siteCreatedLabel: UILabel!
    @IBOutlet weak var siteImageView: UIImageView!
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var siteNameLabel: UILabel!
    @IBOutlet weak var okayButton: UIButton!
    
    
    // MARK: - Declarations
    
    var successData = ""
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        successData.count > 0 ? (siteCreatedLabel.text = successData) : ( siteCreatedLabel.text = "Your site has been created!")
        
    }


    // MARK: - Actions

    @IBAction func okayButtonPressed(_ sender: Any) {
        
        Utility.homeViewController()
    }
}


