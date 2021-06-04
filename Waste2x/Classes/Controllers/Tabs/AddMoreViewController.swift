//
//  MoreViewController.swift
//  ContainerView
//
//  Created by HaiD3R AwaN on 13/04/2021.
//

import UIKit

class AddMoreViewController: BaseViewController {

    @IBOutlet weak var hiddenView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hiddenView.isHidden = true
        // Do any additional setup after loading the view.
    }
    func expandCollapse() {
        self.hiddenView.isHidden = !self.hiddenView.isHidden

    }

    @IBAction func collaps(_ sender: Any) {
//        expandCollapse()
        let vc = TrackerViewController(nibName: "TrackerViewController", bundle: nil)
        self.navigationController?.pushTo(controller: vc)
    }
}
