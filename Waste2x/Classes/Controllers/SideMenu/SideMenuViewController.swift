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
    var paymentModel : PaymentModel?
    
    @IBOutlet weak var headerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        headerView.layer.cornerRadius = 30
        headerView.layer.maskedCorners = [.layerMaxXMaxYCorner]
        headerView.layer.masksToBounds = true
        self.phoneNumberLabel.text = self.Data?.phone
        
    }
    //MARK: - Action Buttons
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        print("LogOut")
        DataManager.shared.deleteUser()
        let vc = LoginViewController(nibName: "LoginViewController", bundle: nil)
        self.navigationController?.setViewControllers([vc], animated: true)
    }
    @IBAction func logOutAction(_ sender: Any) {
        
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
            paymentApi()
            if self.paymentModel?.result?.details_submitted == false || self.paymentModel?.result == nil {
                let vc = PaymentViewController(nibName: "PaymentViewController", bundle: nil)
                    navigationController?.pushViewController(vc, animated: true)
                
            }
            else{
                let vc = CreatePaymentViewController(nibName: "CreatePaymentViewController", bundle: nil)
                    navigationController?.pushViewController(vc, animated: true)
            }
        case 1:
            let vc = ScheduleViewController(nibName: "ScheduleViewController", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        default:
            print("none")
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}


//MARK: - API call
extension SideMenuViewController{
    func paymentApi(){
        PaymentModel.paymentApiFunction{ result, error, status,message in
            self.paymentModel = result
            Global.shared.paymentModel = result
        }
    }
}
