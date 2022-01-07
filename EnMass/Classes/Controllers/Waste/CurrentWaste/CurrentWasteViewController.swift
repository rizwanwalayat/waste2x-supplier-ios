//
//  CurrentWasteViewController.swift
//  Waste2x
//
//  Created by MAC on 26/05/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit

class CurrentWasteViewController: BaseViewController {

    
    // MARK: - Outlet
    
    @IBOutlet weak var currentWasteTableview : UITableView!
    @IBOutlet weak var backgroundHolderview: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomConstOfView: NSLayoutConstraint!
    
    // MARK: - Variables
    
    var sitesData = [FetchSitesCustomModel]()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sitesData = FetchSitesDataModel.shared.sites()
//        bottomConstOfView.constant = tabbarViewHeight
        currentWasteTableview.register(UINib(nibName: "CurrentWasteTableViewCell", bundle: nil), forCellReuseIdentifier: "CurrentWasteTableViewCell")
        currentWasteTableview.rowHeight = UITableView.automaticDimension
        currentWasteTableview.estimatedRowHeight = UITableView.automaticDimension
//        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
//        currentWasteTableview.addSubview(refreshControl)
    }
//    @objc func refresh(_ sender: AnyObject) {
//        self.getResponce()
//    }
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
    
    @IBAction func newSiteBtnPressed(_ sender: Any) {
        Global.shared.apiCurve = true
        let vc = SupplyingTypeViewController(nibName: "SupplyingTypeViewController", bundle: nil)
        self.navigationController?.pushTo(controller: vc)
    }
}


// MARK: - Tableview Delegate & Datasource

extension CurrentWasteViewController : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sitesData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentWasteTableViewCell", for: indexPath) as! CurrentWasteTableViewCell
        
        let cellData = sitesData[indexPath.section]
        cell.setCellData(cellData)
        
        return cell
    }
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
//            sitesData.remove(at: indexPath.section)
//            tableView.deleteSections([indexPath.section], with: .fade)
            
            let alertVc = UIAlertController(title: "Delete", message: "Are you sure want to delete?", preferredStyle: .alert)
            
            let image = UIImage(named: "appIcon")
            let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
            imageView.image = image
            imageView.cornerRadius = 4
            imageView.clipsToBounds = true
            alertVc.view.addSubview(imageView)
            
//            alertVc.setValue(image, forKey: "image")
            alertVc.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                Utility.showLoading()
                APIClient.shared.deleteSiteApiFunctionCall(id: self.sitesData[indexPath.section].farmId, resone: "I don't Want This Site Any More") { result, error, status, message in
                    Utility.hideLoading()
                    if error == nil{
                        
                    self.showToast(message: "Request has Been Submited")
                        
                    }
                    
                }
            }))
            alertVc.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alertVc, animated: true, completion: nil)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = WasteDetailViewController(nibName: "WasteDetailViewController", bundle: nil)
        vc.farmID = sitesData[indexPath.section].farmId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
