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
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    // MARK: - Actions

    @IBAction func okayButtonPressed(_ sender: Any) {
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: HomeViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
            else {
                let vc = SlideMenuController(mainViewController: ContainerViewController(), leftMenuViewController: SideMenuViewController())
                self.navigationController?.setViewControllers([vc], animated: true)
                break
            }
            
        }
    }
}
