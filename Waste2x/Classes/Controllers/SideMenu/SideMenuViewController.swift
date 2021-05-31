//
//  SideMenuViewController.swift
//  Waste2x
//
//  Created by HaiD3R AwaN on 25/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class SideMenuViewController: BaseViewController {
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    
    //MARK: - Variables
    var img = [#imageLiteral(resourceName: "Payment Icons"),#imageLiteral(resourceName: "Calendar")]
    var text = ["Payments","Schedule Pickup"]
    var selectionIndex = -1
    
    @IBOutlet weak var headerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        headerView.layer.cornerRadius = 30
        headerView.layer.maskedCorners = [.layerMaxXMaxYCorner]
        headerView.layer.masksToBounds = true
        
    }
    //MARK: - Action Buttons
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        print("LogOut")
    }
    
}

//MARK: - Extentions
extension SideMenuViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.register(SideMenuItemsTableViewCell.self, indexPath: indexPath)
        if selectionIndex == indexPath.row {
            cell.selectionView.isHidden = false
        }
        else {
            cell.selectionView.isHidden = true
        }
        cell.config(index: indexPath.row)
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.selectionIndex = indexPath.row
        switch indexPath.row {
        case 0:
            print("Payment")
        case 1:
            print("sceduled")
        default:
            print("none")
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}
