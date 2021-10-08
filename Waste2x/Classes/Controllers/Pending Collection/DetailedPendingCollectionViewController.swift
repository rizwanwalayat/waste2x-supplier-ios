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
    var data : PendingCollectionResultResponce?
    var id = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        self.apiCall()
        
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
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.register(DetailPendingCollectionTableViewCell.self, indexPath: indexPath)
        if data != nil{
            cell.confirmConfig(data: data!)
        }

        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if data != nil {
            if self.data!.history.count == 0{
                return self.tableView.frame.height/2
            }
            else{
                return self.tableView.frame.height
            }
        }
        else{
            return self.tableView.frame.height/2
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}




//MARK: - API Call

extension DetailedPendingCollectionViewController{
    func apiCall(){
        if self.id != 0{
            PendingCollectionDetailModel.pendingCollectionApiCall(id: self.id) { result, error, status, message in
                if error == nil{
                    
                    if let resultData = result{
                        self.data = resultData.result
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
