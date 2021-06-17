//
//  NotificationsViewController.swift
//  Waste2x
//
//  Created by MAC on 27/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainHolderView: UIView!
    @IBOutlet weak var notificationsTableview : UITableView!
    @IBOutlet weak var bottomConst : NSLayoutConstraint!
    
    
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
        self.view.layoutIfNeeded()
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
        let notifcationDaTag = NotificationModell?.result?.notifications[sender.tag]
        let notificationID = notifcationDaTag?.idd
        let notificationResponce = notifcationDaTag?.response
        
        
    }
    @objc func noButtonPress(sender:UIButton){
        let notifcationDaTag = NotificationModell?.result?.notifications[sender.tag]
        let notificationID = notifcationDaTag?.idd
        let notificationResponce = notifcationDaTag?.response
        
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
        NotificationModel.notificationApiFunction { result, eroor, status, message in
            self.NotificationModell = result
            self.notificationsTableview.reloadData()
        }
    }
}
