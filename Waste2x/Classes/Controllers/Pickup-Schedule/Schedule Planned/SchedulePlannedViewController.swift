//
//  SchedulePlannedViewController.swift
//  Waste2x
//
//  Created by MAC on 04/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class SchedulePlannedViewController: BaseViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detialLabel: UILabel!
    @IBOutlet weak var okayButton: UIButton!
    
    
    // MARK: - Varibale
    
    var result : ResultPickupSchedule?
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = result?.message ?? "Your pickup schedule has been planned!"
        mainBackgroundView.addGradient(colors: [UIColor(hexString: "FDFEFD").cgColor, UIColor(hexString: "F1F5F2").cgColor])
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
