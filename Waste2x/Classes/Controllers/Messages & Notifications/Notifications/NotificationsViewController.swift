//
//  NotificationsViewController.swift
//  Waste2x
//
//  Created by MAC on 27/05/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainHolderView: UIView!
    @IBOutlet weak var notificationsTableview : UITableView!
    @IBOutlet weak var bottomConst : NSLayoutConstraint!
    @IBOutlet weak var noNotificationLabel : UILabel!
    
    // MARK: - Declarations
    
    var selectedIndex : IndexPath?
    var NotificationModell : NotificationModel?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiCall()
        notificationsTableview.register(UINib(nibName: "NotificationsTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationsTableViewCell")
        notificationsTableview.rowHeight = UITableView.automaticDimension
        notificationsTableview.estimatedRowHeight = UITableView.automaticDimension
        bottomConst.constant = tabbarViewHeight
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        notificationsTableview.addSubview(refreshControl)
        self.view.layoutIfNeeded()
    }
    @objc func refresh(_ sender: AnyObject) {
        self.apiCall()
        refreshControl.endRefreshing()
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        globalObjectContainer?.tabbarHiddenView.isHidden = false
        mainHolderView.layer.cornerRadius = 36
        mainHolderView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        mainHolderView.layer.masksToBounds = true
        
        
    }
    
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func yesButtonPress(sender:UIButton){
        if NotificationModell?.result != nil{
        if sender.title(for: .normal) == "Check" {

            let vc = DetailedPendingCollectionViewController(nibName: "DetailedPendingCollectionViewController", bundle: nil)
            vc.id = NotificationModell?.result?.notifications[sender.tag].pendingCollectionId ?? 0
            self.navigationController?.pushTo(controller: vc)
            }
        
        else if sender.title(for: .normal) == "Track" {
            
            let vc = TrackerViewController(nibName: "TrackerViewController", bundle: nil)
                vc.trackID  = NotificationModell?.result?.notifications[sender.tag].dispatchId ?? 0
                vc.endingLat =  NotificationModell?.result?.notifications[sender.tag].latitude ?? 0.0
                vc.endingLng =  NotificationModell?.result?.notifications[sender.tag].longitude ?? 0.0
                globalObjectContainer?.tabbarHiddenView.isHidden = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        else if sender.title(for: .normal) == "Yes" {
            let notifcationDaTag = NotificationModell?.result?.notifications[sender.tag]
            let notificationID = notifcationDaTag?.idd
            let notificationResponce = "Yes"
            NotificationResponceModel.NotificationResponceModelApiFunction(notificationID: notificationID!, notificationResponce: notificationResponce) { result, error, status, message in
                self.apiCall()
                
            }
        }
        else if sender.title(for: .normal) == "View Stripe Account" {
            if let url = URL(string: "https://dashboard.stripe.com/login") {
                UIApplication.shared.open(url)
            }
        }
            
        }
    }
    @objc func noButtonPress(sender:UIButton){
        if NotificationModell?.result != nil{
        let notifcationDaTag = NotificationModell?.result?.notifications[sender.tag]
        let notificationID = notifcationDaTag?.idd
        let notificationResponceNo = "No"
        NotificationResponceModel.NotificationResponceModelApiFunction(notificationID: notificationID!, notificationResponce: notificationResponceNo) { result, error, status, message in
            self.apiCall()
            
        }
            
        }
        
    }
    
}

extension NotificationsViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotificationModell?.result?.notifications.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell", for: indexPath) as! NotificationsTableViewCell
        cell.notificationYesButton.tag = indexPath.row
        cell.notificationNoButton.tag = indexPath.row
        cell.notificationYesButton.addTarget(self, action: #selector(yesButtonPress(sender:)), for: .touchUpInside)
        cell.notificationNoButton.addTarget(self, action: #selector(noButtonPress(sender:)), for: .touchUpInside)
        cell.config(data: NotificationModell!, index: indexPath.row)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // handlings for collapse and expand one at a time. 
        if selectedIndex == indexPath {
            
            if let cell = tableView.cellForRow(at: indexPath) as? NotificationsTableViewCell
            {
                cell.collapse()
                self.selectedIndex = nil
            }
        }
        else if selectedIndex != nil
        {
            if let cell = tableView.cellForRow(at: selectedIndex!) as? NotificationsTableViewCell
            {
                cell.collapse()
            }
            
            if let cell = tableView.cellForRow(at: indexPath) as? NotificationsTableViewCell
            {
                cell.expand()
            }
            selectedIndex = indexPath
        }
        else if selectedIndex == nil {
            if let cell = tableView.cellForRow(at: indexPath) as? NotificationsTableViewCell
            {
                cell.expand()
                self.selectedIndex = indexPath
            }
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}

//MARK: - API Extention

extension NotificationsViewController{
    func apiCall(){
        NotificationCenter.default.post(name: Notification.Name("notpoint"), object: nil)
        NotificationModel.notificationApiFunction { result, error, status, message in
            self.NotificationModell = result
            self.notificationsTableview.reloadData()
            if (result?.result?.notifications.count ?? 0) > 0
            {
                NotificationCenter.default.post(name: Notification.Name("notpoint"), object: nil)
                self.noNotificationLabel.isHidden = true
                
                if let cell = self.notificationsTableview.cellForRow(at: IndexPath(row: 0, section: 0)) as? NotificationsTableViewCell{
                    cell.expand()
                    self.selectedIndex = IndexPath(row: 0, section: 0)
                    self.notificationsTableview.beginUpdates()
                    self.notificationsTableview.endUpdates()
                }
            }
            else
            {
                self.noNotificationLabel.isHidden = false
            }
        }
    }
}
