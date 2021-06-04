//
//  PendingCollectionViewController.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 02/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class PendingCollectionViewController: BaseViewController {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var count = 2
    var confirm = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        mainView.layer.cornerRadius = 36
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        mainView.layer.masksToBounds = true
        
    }
    

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

//MARK: - Extentions

extension PendingCollectionViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if confirm
        {
        let cell = tableView.register(ConfirmPendingTableViewCell.self, indexPath: indexPath)
        self.confirm = false
        return cell
            
        }
        else
        {
            let cell = tableView.register(UnconfirmPendingCollectionTableViewCell.self, indexPath: indexPath)
            cell.selectionStyle = .none
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


