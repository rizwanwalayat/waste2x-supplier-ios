//
//  PendingCollectionViewController.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 02/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit

class HomeNewViewController: BaseViewController {
    
    // MARK: - Local Enum for statues
    
    enum PendingCollectionStatues : String {
        case poReqests = "Po Requests"
        case pending = "Pending"
        case upcoming = "Upcoming"
        case rejected = "rejected"
        case completed = "Completed"
        
        var backendValue : String {
            switch self {
            case .pending:
                return "Draft"
            case .upcoming:
                return "In Transit"
            case .completed:
                return "Completed"
            case .poReqests:
                return "poRequest"
            case .rejected:
                return "rejected"
            }
        }
    }
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    @IBOutlet weak var tabsHolderView: UIView!
    @IBOutlet weak var poRequestTab: UIView!
    @IBOutlet weak var upcomingTab: UIView!
    @IBOutlet weak var pendingTab: UIView!
    @IBOutlet weak var declinedTab: UIView!
    @IBOutlet weak var completedTab: UIView!
    
    
    //MARK: - Variables
    
    var tabs = [UIView]()
    var resultData : PendingCollectionResultResponce?
    var pendingCollectionModel = [PendingCollectionDataModel]()
    var visiableCollectionsArray = [PendingCollectionDataModel]()
    var allStatus : [PendingCollectionStatues] = [.poReqests, .upcoming, .pending, .rejected, .completed]
    var selectedTab = PendingCollectionStatues.poReqests
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.apiCall()
        fetchFarmsFromServer()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tabsHolderView.cornerRadius = 8
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
        self.navigationController?.navigationBar.isHidden = true
        
    }
    override func viewDidAppear(_ animated: Bool) {
        tabs = [poRequestTab, upcomingTab, pendingTab, declinedTab ,completedTab]
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.pushToPaymentScreen(notification:)),
            name: Notification.Name("NavigateToPayment"),
            object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - IBActions
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tabPressed(_ sender: UIButton) {
        for i in 0..<tabs.count {
            selectionHandlingsOfViews(tabs[i], isSelection: i == sender.tag)
        }
        
            
        if resultData != nil {
            
            selectedTab = allStatus[sender.tag]
            visiableCollectionsArray.removeAll()
            
            if tabs[sender.tag] == poRequestTab {
                
                visiableCollectionsArray = resultData?.poRequests ?? [PendingCollectionDataModel]()
            }
            else if tabs[sender.tag] == declinedTab {
                
                visiableCollectionsArray = resultData?.deniedPoRequests ?? [PendingCollectionDataModel]()
            }
            else {
                
                visiableCollectionsArray = pendingCollectionModel.filter { $0.status == selectedTab.backendValue}
            }
            
            tableView.reloadData()
        }
    }
    
    @IBAction func sideMenuAction(_ sender: Any) {
        
        if let slideMenuController = self.slideMenuController() {
            slideMenuController.openLeft()
        }
    }
    
    @IBAction func notificationAction(_ sender: Any) {
        let notification = NotificationsViewController(nibName: "NotificationsViewController", bundle: nil)
        self.navigationController?.pushViewController(notification, animated: true)
    }
    
    // MARK: - Tabs Handling
    fileprivate func selectionHandlingsOfViews(_ holderView : UIView, isSelection : Bool)
    {
        let selectedImageColor = "007F97"
        let unSelectedImageColor = "B9B7C1"
        
        let selectedTitleLabelTextColor = "444444"
        let unSelectedTitleLabelTextColor = unSelectedImageColor
        
        let selectedBackground = "FFFFFF"
        let unSelectedBackground = "EBEBEB"
        
        let selectedBorderColor = "E0E0E0"
        let unSelectedBorderColor = unSelectedBackground
        
        
        for view in holderView.subviews
        {
            if let textLabel = view as? UILabel
            {
                textLabel.textColor = isSelection ? UIColor(hexString: selectedTitleLabelTextColor) : UIColor(hexString: unSelectedTitleLabelTextColor)
            }
            else if let imageView = view as? UIImageView
            {
                imageView.tintColor = isSelection ? UIColor(hexString: selectedImageColor) : UIColor(hexString: unSelectedImageColor)
            }
               
        }
        
        if isSelection{
            holderView.borderWidth = 1
            holderView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
            holderView.layer.shadowOpacity = 0.3
            holderView.layer.shadowOffset = CGSize(width: 4, height: 4)
            holderView.layer.shadowRadius = 5
            holderView.layer.shadowPath = UIBezierPath(rect: holderView.bounds).cgPath

            holderView.backgroundColor = UIColor(hexString: selectedBackground)
        }
        else {
            holderView.animateBorderColor(toColor: UIColor(hexString: unSelectedBorderColor), duration: 0.1)
            holderView.borderWidth = 0
            holderView.backgroundColor = UIColor.clear
        }
        
    }
    
    @objc private func pushToPaymentScreen(notification: NSNotification){
        
        if let slideMenuController = self.slideMenuController() {
            slideMenuController.closeLeft()
        }
        
        if let object = notification.userInfo {
            if let result = object["result"] as? PaymentModel
            {
                if result.result != nil{
                    
                    if result.result?.details_submitted == true {
                        let vc = CreatePaymentViewController(nibName: "CreatePaymentViewController", bundle: nil)
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                    else{
                        let vc = PaymentViewController(nibName: "PaymentViewController", bundle: nil)
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                }
                else{
                    let vc = PaymentViewController(nibName: "PaymentViewController", bundle: nil)
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
        }
    }

}

//MARK: - Extentions

extension HomeNewViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visiableCollectionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.register(ConfirmPendingTableViewCell.self, indexPath: indexPath)
        let data = visiableCollectionsArray[indexPath.row]
        cell.confirmConfig(data: data)
        return cell
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = DetailedPendingCollectionViewController(nibName: "DetailedPendingCollectionViewController", bundle: nil)
        vc.id = visiableCollectionsArray[indexPath.row].id
        vc.isPoRequest = (selectedTab == .poReqests || selectedTab == .rejected) ? true : false
        self.navigationController?.pushTo(controller: vc)
    }
    
}


//MARK: - API CALL
extension HomeNewViewController{
    
    func apiCall(){
        
        PendingCollectionModel.pendingCollectionApiCall { result, error, status, message in
            
            if error != nil {
                
                Utility.showAlertController(self, error?.localizedDescription ?? message)
                return
            }
            
            if let result = result{
                
                self.visiableCollectionsArray.removeAll()
                self.resultData = result.result
                
                self.pendingCollectionModel = result.result?.pendingCollections ?? [PendingCollectionDataModel]()
        
                self.dataHandlingsAndPopulte()
            }
        }
    }
    
    fileprivate func dataHandlingsAndPopulte()
    {
        switch selectedTab {
        case .poReqests:
            self.visiableCollectionsArray = self.resultData?.poRequests ?? [PendingCollectionDataModel]()
        case .pending:
            self.visiableCollectionsArray = self.pendingCollectionModel.filter { $0.status == self.selectedTab.backendValue}
        case .upcoming:
            self.visiableCollectionsArray = self.pendingCollectionModel.filter { $0.status == self.selectedTab.backendValue}
        case .rejected:
            self.visiableCollectionsArray = self.resultData?.deniedPoRequests ?? [PendingCollectionDataModel]()
        case .completed:
            self.visiableCollectionsArray = self.pendingCollectionModel.filter { $0.status == self.selectedTab.backendValue}
        }
        
        self.tableView.reloadData()
    }
}

extension HomeNewViewController: FetchSitesDataModelDelegate
{
    func sitesEmpty() {
        
        self.showPopupToCreateSite()
    }
    
    func fetchFarmsFromServer()
    {
        FetchSitesDataModel.shared.reloadData()
        FetchSitesDataModel.shared.delegate = self
        
    }
    
    
    fileprivate func showPopupToCreateSite()
    {
        let custompopup = CreateSitePopupViewController(nibName: "CreateSitePopupViewController", bundle: nil)
        custompopup.modalPresentationStyle   = .overFullScreen
        custompopup.createSitePressed = {
            
            Global.shared.apiCurve = true
            let vc = SupplyingTypeViewController(nibName: "SupplyingTypeViewController", bundle: nil)
            self.navigationController?.setViewControllers([vc], animated: true)

        }
        self.present(custompopup, animated: false, completion: nil)
    }
    
}

