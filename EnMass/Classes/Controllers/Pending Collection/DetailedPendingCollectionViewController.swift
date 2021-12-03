//
//  DetailedPendingCollectionViewController.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 23/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit


class DetailedPendingCollectionViewController: BaseViewController {
    
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var data : PendingCollectionDataModel?
    var id = Int()
    var isPoRequest = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        
        if data == nil
        {
            self.apiCall()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        mainView.layer.cornerRadius = 36
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        mainView.layer.masksToBounds = true
        globalObjectContainer?.tabbarHiddenView.isHidden = true
        bottomConst.constant = 0
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
//MARK: - TableView

extension DetailedPendingCollectionViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data == nil {
            return 0
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0
        {
            let cell = tableView.register(DetailPendingCollectionTableViewCell.self, indexPath: indexPath)
            if data != nil{
                cell.confirmConfig(data: data!)
            }
            
            cell.selectionStyle = .none
            return cell
        }
        else
        {
            let cell = tableView.register(MessagePendingCollectionTableViewCell.self, indexPath: indexPath)
            cell.messageCustomerBtn.addTarget(self, action: #selector(messageCustomerBtnPressed), for: .touchUpInside)
            cell.acceptBtn.addTarget(self, action: #selector(acceptBtnPressed), for: .touchUpInside)
            cell.declineBtn.addTarget(self, action: #selector(cancelBtnPressed), for: .touchUpInside)
            if data != nil{
                cell.statusViewHandlings(data!.poRequestStatusType)
            }
            cell.selectionStyle = .none

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - Cell Actions

extension DetailedPendingCollectionViewController {
    @objc func messageCustomerBtnPressed(){
        let vc = ChatMessagesViewController(nibName: "ChatMessagesViewController", bundle: nil)
        
        vc.identity = "\(DataManager.shared.getUser()?.result?.phone ?? "")_\(self.data?.customer_phone ?? "")"
        globalObjectContainer?.tabbarHiddenView.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func acceptBtnPressed() {
        
        let notificationResponce = "Yes"
        PendingCollectionDetailModel.acceptRejectShipment(notificationID: id, notificationResponce: notificationResponce) { result, error, status, message in
            if error != nil {
                Utility.showAlertController(self, error?.localizedDescription ?? message)
                return
            }
            
            if self.data != nil {
                
                self.data!.poRequestStatusType = .approved
                self.tableView.reloadData()
            }
            
            
        }
    }
    
    @objc func cancelBtnPressed() {
        
        let notificationResponceNo = "No"
        PendingCollectionDetailModel.acceptRejectShipment(notificationID: id, notificationResponce: notificationResponceNo) { result, error, status, message in
            if error != nil {
                Utility.showAlertController(self, error?.localizedDescription ?? message)
                return
            }
            
            if self.data != nil {
                
                self.data!.poRequestStatusType = .denied
                self.tableView.reloadData()
            }
            
        }
    }
}


//MARK: - API Call

extension DetailedPendingCollectionViewController{
    func apiCall(){
        if self.id != 0{
            PendingCollectionDetailModel.pendingCollectionApiCall(id: self.id, poRequest: isPoRequest) { result, error, status, message in
                if error == nil{
                    
                    if let resultData = result{
                        self.data = resultData.result
                        
                        // in case of when user comes from home screen than we assigned notification_id here 
                        if resultData.result?.notificationId != -1 {
                            
                            self.id =  resultData.result?.notificationId ?? 0
                        }
                        
                        self.tableView.reloadData()
                    }
                    //                for item in result!.result{
                    //                    print(item.id)
                    //                    if self.id == item.id{
                    //                        self.data = item
                    //                        self.tableView.reloadData()
                    //                        break
                    //                    }
                    //                }
                }
                
            }
            
        }
        
    }
    
}
