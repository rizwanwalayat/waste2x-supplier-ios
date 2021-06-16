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
        
        postDataFromServer()
    }
}

// MARK: - API Calls Handlings
extension SiteCreatedViewController {
    
    
    func postDataFromServer()
    {
        if Data?.isNewUser ?? true {
            
            postDictData["phone"] = Data?.phone ?? ""
            postDictData["email"] = Data?.email ?? ""
        }
        
        let postDict = postDictData as [String : AnyObject]
        
        CreateSiteDataModel.postSiteCreateData(params: postDict, { data, error, code,message in
            
            if error != nil
            {
                self.alertManager("Failed", message: error!.localizedDescription )
            }
            
            if code == 200 {
                
                if data != nil {
                    
                    self.alertManager("Success", message: "Site created successfully" )
                }
                
            }
            else
            {
                self.alertManager("Failed", message: "Site not created ..!" )
            }
        })
    }
    
    
    func alertManager(_ title : String, message : String)
    {
        let alert =  UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
            
            Utility.homeViewController()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
