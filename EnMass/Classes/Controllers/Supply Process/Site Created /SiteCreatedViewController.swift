//
//  SiteCreatedViewController.swift
//  Waste2x
//
//  Created by MAC on 08/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
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
    var selectionData = [String : Any]()
    var createSiteDataModel : CreateSiteDataModel?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        siteNameLabel.text = ""
        successData.count > 0 ? (siteCreatedLabel.text = successData) : ( siteCreatedLabel.text = "Your site has been created!")
        siteLabel.text = createSiteDataModel?.result?.farmName ?? ""
        if let jsonString = selectionData["waste_selection_json"] as? String {
            
            if let dict = convertToDictionary(text: jsonString) {
                
                let wasteName = dict["waste_type"] as? String
                siteNameLabel.text = wasteName ?? ""
            }
        }
        
        if SupplyingTypeViewController.selectedImageIcon.count > 0
        {
            guard let imageUrl = URL(string: SupplyingTypeViewController.selectedImageIcon) else { print("URL not created for imagesURL String"); return }
            setImage(imageView: siteImageView, url: imageUrl)
        }
        
        // save user data 
        DataManager.shared.setIfUserLoggedInSuccessFully()
    }


    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    // MARK: - Actions

    @IBAction func okayButtonPressed(_ sender: Any) {
        
//        let vc = WasteDetailViewController(nibName: "WasteDetailViewController", bundle: nil)
//        vc.farmID = createSiteDataModel?.result?.waste_id ?? 0
//        self.navigationController?.pushViewController(vc, animated: true)
        
        if !Global.shared.apiCurve {
            Utility.homeViewController()
        }
        else {
            
            FetchSitesDataModel.shared.reloadData()
            if createSiteDataModel?.result?.waste_id != -1 {
                
                Utility.SitesDetailViewController(createSiteDataModel?.result?.waste_id ?? 0)
            }
            else {
                Utility.CurrentSitesViewController()
                //Utility.showAlertController(self, "Sites Id not fetched!")
            }
        }
        
    }
}


