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
        view.backgroundColor = .gray
        // Do any additional setup after loading the view.
    }
    

    @IBAction func actionBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
