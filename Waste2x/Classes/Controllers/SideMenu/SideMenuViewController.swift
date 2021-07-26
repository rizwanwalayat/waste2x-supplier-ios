//
//  SideMenuViewController.swift
//  Waste2x
//
//  Created by HaiD3R AwaN on 25/05/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
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
    var reload = -1
    var timerTest : Timer?
    var counter = 0
    @IBOutlet weak var headerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        headerView.layer.cornerRadius = 30
        headerView.layer.maskedCorners = [.layerMaxXMaxYCorner]
        headerView.layer.masksToBounds = true
        self.phoneNumberLabel.text = self.userData?.phone
        
    }
    //MARK: - Action Buttons
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        print("LogOut")
        
        let alertVc = UIAlertController(title: "Logout", message: "Are you sure want to logout?", preferredStyle: .alert)
        
        let image = UIImage(named: "appIcon")
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        imageView.image = image
        imageView.cornerRadius = 4
        imageView.clipsToBounds = true
        alertVc.view.addSubview(imageView)
        
        alertVc.setValue(image, forKey: "image")
        alertVc.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
            self.startTimer()
        }))
        alertVc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertVc, animated: true, completion: nil)
        
    }
    @IBAction func logOutAction(_ sender: Any) {
        
    }
    
    func startTimer ()
    {
        Utility.showLoading()
        counter = 0
        timerTest =  Timer.scheduledTimer(
            timeInterval: TimeInterval(1.0),
            target      : self,
            selector    : #selector(self.updateTime(_:)),
            userInfo    : nil,
            repeats     : true)
    }
    
    func stopTimer() {
        timerTest?.invalidate()
        timerTest = nil
        DataManager.shared.deleteUser()
        DataManager.shared.setIfUserLoggedOutSuccessFully()
        Global.shared.apiCurve = false
        let vc = LoginViewController(nibName: "LoginViewController", bundle: nil)
        self.navigationController?.setViewControllers([vc], animated: true)
        Utility.hideLoading()

    }
    @objc func updateTime(_ timer: Timer) {
        counter = counter+1
        if counter == 1 || counter > 1 {
            
            stopTimer()
            
        }
    }
    
}

//MARK: - Extentions
extension SideMenuViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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

        case 1:
            let vc = ScheduleViewController(nibName: "ScheduleViewController", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
            
        case 2:
            guard let url = URL(string: "https://enmassenergy.com/waste2x-privacy/") else { return }
            UIApplication.shared.open(url)
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
            Global.shared.paymentModel = result
            let objectDict = ["result" : result]
            NotificationCenter.default.post(name: Notification.Name("NavigateToPayment"), object: nil, userInfo: objectDict as [AnyHashable : Any])
        }
    }
}
