//
//  PendingCollectionViewController.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 02/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit

class PendingCollectionViewController: BaseViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    
    
    //MARK: - Variables
    
    var count = 2
//    var confirm = true
    var pendingCollectionModel : [PendingCollectionResultResponce]?
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.apiCall()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    @objc func refresh(_ sender: AnyObject) {
        self.apiCall()
        refreshControl.endRefreshing()
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        mainView.layer.cornerRadius = 36
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        mainView.layer.masksToBounds = true
        globalObjectContainer?.tabbarHiddenView.isHidden = false
        bottomConst.constant = self.tabbarViewHeight
        
    }
    

    //MARK: - IBActions
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

//MARK: - Extentions

extension PendingCollectionViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pendingCollectionModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.pendingCollectionModel![indexPath.row].status == "Pending"
        {
            let cell = tableView.register(UnconfirmPendingCollectionTableViewCell.self, indexPath: indexPath)
            cell.selectionStyle = .none
            cell.unConfirmedConfig(data: pendingCollectionModel![indexPath.row])
            return cell
            
        }
        else {
            
            let cell = tableView.register(ConfirmPendingTableViewCell.self, indexPath: indexPath)
            cell.confirmConfig(data: pendingCollectionModel!, index: indexPath.row)
            return cell
            
        }
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let confirmCell = tableView.cellForRow(at: indexPath) as? ConfirmPendingTableViewCell
        {
            confirmCell.expandCollapseView(index: indexPath.row)
        }
        if let UnConfirmcell = tableView.cellForRow(at: indexPath) as? UnconfirmPendingCollectionTableViewCell
        {
            UnConfirmcell.expandCollapseView(index: indexPath.row)
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}


//MARK: - API CALL
extension PendingCollectionViewController{
    
    func apiCall(){
        
        PendingCollectionModel.pendingCollectionApiCall { result, error, status, message in
            
            if error == nil{
                
                self.pendingCollectionModel = result?.result
                self.tableView.reloadData()
            }
            
        }
    }
}


