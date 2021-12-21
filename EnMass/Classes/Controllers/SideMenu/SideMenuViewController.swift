//
//  SideMenuViewController.swift
//  Waste2x
//
//  Created by HaiD3R AwaN on 25/05/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import SDWebImage

class SideMenuViewController: BaseViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var phoneNoHolderView: UIView!
    @IBOutlet weak var headerView: UIView!
    
    //MARK: - Variables
    
    var menuArray = [SideMenuItems.payment, SideMenuItems.sites, SideMenuItems.inviteSupplier, SideMenuItems.privacyPolicy]
    var selectionIndex = -1
    var paymentModel : PaymentModel?
    var reload = -1
    var timerTest : Timer?
    var counter = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        headerView.layer.cornerRadius = 30
        headerView.layer.maskedCorners = [.layerMaxXMaxYCorner]
        headerView.layer.masksToBounds = true
        phoneNoHolderView.layer.cornerRadius = 20
        phoneNoHolderView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner]
        
        populateUsersData()
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
    
    @IBAction func profileButtonPressed(_ sender: UIButton){
        
        
        let vc = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
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
        TwillioChatDataModel.shared.shutdown()
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
    
    fileprivate func populateUsersData(){
        
        guard let user = DataManager.shared.getUserDetail() else {return}
        self.phoneNumberLabel.text = user.phone.toPhoneNumber()
        
        self.downloadImageFromServer(user.image) { image, error, success in
            
            if success ?? false && image != nil {
                self.userImage.image = image
            }
        }
    }
    
}


//MARK: - Extentions

extension SideMenuViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.register(SideMenuItemsTableViewCell.self, indexPath: indexPath)
        cell.selectionView.isHidden = true
        cell.config(item: menuArray[indexPath.row])
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.selectionIndex = indexPath.row
        switch indexPath.row {
        case 0:
            
            paymentApi()
            
        case 1:
            let vc = CurrentWasteViewController(nibName: "CurrentWasteViewController", bundle: nil)
            self.navigationController?.pushTo(controller: vc)
            
        case 2:
            let vc = InviteSupplierViewController(nibName: "InviteSupplierViewController", bundle: nil)
            self.navigationController?.pushTo(controller: vc)
            
        default:
            guard let url = URL(string: "https://enmassenergy.com/waste2x-privacy/") else { return }
            UIApplication.shared.open(url)
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

enum SideMenuItems : String {
    
    case payment = "Payments"
    case sites =  "Sites"
    case inviteSupplier =  "Invite Suppliers"
    case privacyPolicy =  "Privacy Policy"
    
    var selectedImage: UIImage {
        
        switch self {
        case .payment:
            return #imageLiteral(resourceName: "Payment Icons")
        case .sites:
            return #imageLiteral(resourceName: "site-icon")
        case .inviteSupplier:
            return #imageLiteral(resourceName: "inviteSupplier-icon")
        case .privacyPolicy:
            return #imageLiteral(resourceName: "Privacy Policy Icon")
        }
    }
}
