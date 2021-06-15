//
//  CurrentWasteViewController.swift
//  Waste2x
//
//  Created by MAC on 26/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class CurrentWasteViewController: BaseViewController {

    
    // MARK: - Outlet
    
    @IBOutlet weak var currentWasteTableview : UITableView!
    @IBOutlet weak var backgroundHolderview: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    // MARK: - Variables
    
    var sitesData = [FetchSitesCustomModel]()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentWasteTableview.register(UINib(nibName: "CurrentWasteTableViewCell", bundle: nil), forCellReuseIdentifier: "CurrentWasteTableViewCell")
        currentWasteTableview.rowHeight = UITableView.automaticDimension
        currentWasteTableview.estimatedRowHeight = UITableView.automaticDimension
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)

        backgroundHolderview.layer.cornerRadius = 36
        backgroundHolderview.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        backgroundHolderview.layer.masksToBounds = true
    }
    
    
    // MARK: - Actions

    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - Tableview Delegate & Datasource

extension CurrentWasteViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sitesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentWasteTableViewCell", for: indexPath) as! CurrentWasteTableViewCell
        
        let cellData = sitesData[indexPath.row]
        cell.setCellData(cellData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let codeVerificationVC = WasteDetailViewController(nibName: "WasteDetailViewController", bundle: nil)
        self.navigationController?.pushViewController(codeVerificationVC, animated: true)
    }
}
