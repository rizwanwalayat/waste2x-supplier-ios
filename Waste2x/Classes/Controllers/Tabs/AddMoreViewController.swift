//
//  MoreViewController.swift
//  ContainerView
//
//  Created by HaiD3R AwaN on 13/04/2021.
//

import UIKit

class AddMoreViewController: BaseViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func collaps(_ sender: Any) {
//        expandCollapse()
        let vc = TrackerViewController(nibName: "TrackerViewController", bundle: nil)
        self.navigationController?.pushTo(controller: vc)
    }
}
