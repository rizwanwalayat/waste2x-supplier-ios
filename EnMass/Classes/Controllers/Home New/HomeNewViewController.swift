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
        case rejected = "rejected"
        case completed = "Completed"
        
        var backendValue : String {
            switch self {
            case .pending:
                return "Draft"
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
    @IBOutlet weak var notificationAlert: UIView!
    
    
    //MARK: - Variables
    
    var tabs = [UIView]()
    var resultData : PendingCollectionResultResponce?
    var pendingCollectionModel = [PendingCollectionDataModel]()
    var visiableCollectionsArray = [PendingCollectionDataModel]()
    var allStatus : [PendingCollectionStatues] = [.poReqests, .pending, .rejected, .completed]
    var selectedTab = PendingCollectionStatues.poReqests
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiCall(true)
        fetchFarmsFromServer()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tabsHolderView.cornerRadius = 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        notificationSetup()
        mainView.layer.cornerRadius = 36
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        mainView.layer.masksToBounds = true
        globalObjectContainer?.tabbarHiddenView.isHidden = false
        bottomConst.constant = self.tabbarViewHeight
        self.navigationController?.navigationBar.isHidden = true
        self.apiCall(false)
        
        notificationApiCall()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabs = [poRequestTab, pendingTab, declinedTab ,completedTab]
        
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
    
    
    //MARK: - Functions
    
    func notificationSetup() {
        
        //MARK: - Observers
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.notification(notification:)), name: Notification.Name("notification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationIconGreen(notifications:)), name: Notification.Name("point"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationIconWhite(notifications:)), name: Notification.Name("notpoint"), object: nil)
        
        
        Global.shared.nootification = DataManager.shared.getBoolData(key: "globalNotification")
        
        if Global.shared.nootification {
            notificationAlert.backgroundColor = UIColor.init(hexString: "FBCE09")
        }
        
        else {
            notificationAlert.backgroundColor = .clear
        }
        
    }
    
    
    //MARK: - OBJ C
    
    @objc func notification(notification : Notification) {
        let notification = NotificationsViewController(nibName: "NotificationsViewController", bundle: nil)
        self.navigationController?.pushViewController(notification, animated: true)
    }
    
    @objc func notificationIconGreen(notifications : Notification) {
        Global.shared.nootification = true
        DataManager.shared.setBoolData(value: Global.shared.nootification, key: "globalNotification")
        
        if Global.shared.nootification {
            notificationAlert.backgroundColor =  UIColor.init(hexString: "FBCE09")
        }
        
        else {
            notificationAlert.backgroundColor = .clear
        }
    }
    
    @objc func notificationIconWhite(notifications : Notification) {
        Global.shared.nootification = false
        DataManager.shared.setBoolData(value: Global.shared.nootification, key: "globalNotification")
        if Global.shared.nootification {
            notificationAlert.backgroundColor =  UIColor.init(hexString: "FBCE09")
        }
        else
        {
            notificationAlert.backgroundColor = .clear
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.apiCall(false)
        refreshControl.endRefreshing()
    }

    @objc private func pushToPaymentScreen(notification: NSNotification) {
        
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
            dataHandlingsAndPopulte()
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
        let selectedImageColor = UIColor.icons
        let unSelectedImageColor = UIColor.inactive
        
        let selectedTitleLabelTextColor = UIColor.tabText
        let unSelectedTitleLabelTextColor = unSelectedImageColor
        
        let selectedBackground = UIColor.white
        let unSelectedBackground = UIColor.tabUnselected
        
        let unSelectedBorderColor = unSelectedBackground
        
        
        for view in holderView.subviews
        {
            if let textLabel = view as? UILabel
            {
                textLabel.textColor = isSelection ? selectedTitleLabelTextColor : unSelectedTitleLabelTextColor
            }
            else if let imageView = view as? UIImageView
            {
                imageView.tintColor = isSelection ?  selectedImageColor : unSelectedImageColor
            }
               
        }
        
        if isSelection{
            //holderView.borderWidth = 1
            holderView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
            holderView.layer.shadowOpacity = 0.3
            holderView.layer.shadowOffset = CGSize(width: 4, height: 4)
            holderView.layer.shadowRadius = 5
            holderView.layer.shadowPath = UIBezierPath(rect: holderView.bounds).cgPath

            holderView.backgroundColor = selectedBackground
        }
        else {
            holderView.animateBorderColor(toColor: unSelectedBorderColor, duration: 0.1)
            holderView.borderWidth = 0
            holderView.backgroundColor = UIColor.clear
        }
        
    }
    
    func notificationApiCall() {
        NotificationModel.notificationApiFunction { result, error, status, message in
            if (result?.result?.notifications.count ?? 0) != DataManager.shared.getnotificationCount() {
                NotificationCenter.default.post(name: Notification.Name("point"), object: nil)
            }
            DataManager.shared.setnotificationCount(value: result?.result?.notifications.count ?? 0)
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
    
    func apiCall(_ loadingEnabled: Bool){
        
        PendingCollectionModel.pendingCollectionApiCall(loadingEnabled: loadingEnabled) { result, error, status, message in
            
            if error != nil {
                
                Utility.showAlertController(self, error?.localizedDescription ?? message)
                return
            }
            
            if let result = result{
                
                self.resultData = result.result
                
                self.pendingCollectionModel = result.result?.pendingCollections ?? [PendingCollectionDataModel]()
        
                self.dataHandlingsAndPopulte()
            }
        }
    }
    
    fileprivate func dataHandlingsAndPopulte()
    {
        
        self.visiableCollectionsArray.removeAll()
        switch selectedTab {
        case .poReqests:
            self.visiableCollectionsArray = self.resultData?.poRequests ?? [PendingCollectionDataModel]()
        case .pending:
            self.visiableCollectionsArray = self.resultData?.pendingCollections ?? [PendingCollectionDataModel]()
        case .rejected:
            self.visiableCollectionsArray = self.resultData?.deniedPoRequests ?? [PendingCollectionDataModel]()
        case .completed:
            self.visiableCollectionsArray = self.resultData?.completed ?? [PendingCollectionDataModel]()
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

