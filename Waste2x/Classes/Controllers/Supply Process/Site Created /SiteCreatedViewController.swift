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
    
    var postDictData = [String : Any]()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    // MARK: - Actions

    @IBAction func okayButtonPressed(_ sender: Any) {
        
        fetchDataFromServer()
    }
}

// MARK: - API Calls Handlings
extension SiteCreatedViewController {
    
    
    func fetchDataFromServer()
    {
        postDictData["phone"] = "+923337646947"
        postDictData["email"] = "naeem@gmail.com"
        let postDict = postDictData as [String : AnyObject]
        
        SupplyProcessDataModel.postSiteCreateData(params: postDict, { data, error, code in
            
            if error != nil
            {
                Utility.showAlertController(self, error!.localizedDescription)
            }
            
            if data != nil {
                
                Utility.homeViewController()
            }
        })
    }
}
