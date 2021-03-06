//
//  CommunitiesViewController.swift
//  ContainerView
//
//  Created by HaiD3R AwaN on 13/04/2021.
//

import UIKit
import Alamofire
import ObjectMapper
protocol PaymentDelegate {
    func newPayment()
    func exsitingPayment()
}
protocol WeatherCallDelegate {
    func Weather()
}
class HomeViewController: BaseViewController{
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var notificationMark: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressPointsLabel: UILabel!
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var wasteTypeCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var indicatorMarker: UIPageControl!
    @IBOutlet weak var homeScrollview : UIScrollView!
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    
    @IBOutlet weak var mainView: UIScrollView!
    
    //MARK: - Variables
    var supplierCell: SupplierTableViewCell?
    var weatherCount  = 5
    var delegate:WeatherCallDelegate?
    var paymentDelegate:PaymentDelegate?
    var index = 0
    
    //MARK: - AppCycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        weatherCollectionView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.notification(notification:)), name: Notification.Name("notification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationIconGreen(notifications:)), name: Notification.Name("point"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationIconWhite(notifications:)), name: Notification.Name("notpoint"), object: nil)
        print(userData?.auth_token ?? "")
        Global.shared.nootification = DataManager.shared.getBoolData(key: "globalNotification")
        if Global.shared.nootification {
            notificationMark.backgroundColor = UIColor.init(red: 196, green: 210, blue: 150, alpha: 1)
        }
        else
        {
            notificationMark.backgroundColor = .clear
        }
        (UIApplication.shared.delegate as! AppDelegate).weaterCalldelegate = self
        bottomConst.constant = tabbarViewHeight
        welcomeLabel.attributedText =  setAttributedTextInLable(boldString: "Hello ,", emailAddress: DataManager.shared.getUser()?.result?.email ?? "")
        let progressbarAdjustment = UIScreen.main.bounds.height / 200
        progressBar.transform = CGAffineTransform(scaleX: 1, y: progressbarAdjustment)
        collectionDataSourceDelegate(outlet: weatherCollectionView)
        collectionDataSourceDelegate(outlet: wasteTypeCollectionView)
        tableDataSourceDelegate(outlet: tableView)
        weatherCollectionView.backgroundColor = .clear
        wasteTypeCollectionView.contentInset  = .zero
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        fetchFarmsFromServer()
        Global.shared.jump = 0
        self.weatherCollectionView.reloadData()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    
    //MARK: - OBJC Function
    
    @objc func notification(notification : Notification) {
        let notification = NotificationsViewController(nibName: "NotificationsViewController", bundle: nil)
        self.navigationController?.pushViewController(notification, animated: true)
    }
    
    @objc func notificationIconGreen(notifications : Notification) {
        Global.shared.nootification = true
        DataManager.shared.setBoolData(value: Global.shared.nootification, key: "globalNotification")
        
        if Global.shared.nootification {
            notificationMark.backgroundColor = UIColor.init(red: 251, green: 206, blue: 9, alpha: 1)
        }
        else
        {
            notificationMark.backgroundColor = .clear
        }
    }
    @objc func notificationIconWhite(notifications : Notification){
        Global.shared.nootification = false
        DataManager.shared.setBoolData(value: Global.shared.nootification, key: "globalNotification")
        if Global.shared.nootification {
            notificationMark.backgroundColor = UIColor.init(red: 251, green: 206, blue: 9, alpha: 1)
        }
        else
        {
            notificationMark.backgroundColor = .clear
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

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        mainView.layer.cornerRadius = 36
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        mainView.layer.masksToBounds = true
        self.navigationController?.navigationBar.isHidden = true
        globalObjectContainer?.tabbarHiddenView.isHidden = false
    }
    
    
    //MARK: - Functions
    func collectionDataSourceDelegate(outlet:UICollectionView){
        outlet.delegate = self
        outlet.dataSource = self
        
    }
    func tableDataSourceDelegate(outlet:UITableView){
        outlet.delegate = self
        outlet.dataSource = self
        
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

    
    //MARK: - ActionButtons
    @IBAction func sideMenuAction(_ sender: Any) {
        
        if let slideMenuController = self.slideMenuController() {
            slideMenuController.openLeft()
        }
    }
    
    @IBAction func notificationAction(_ sender: Any) {
        let notification = NotificationsViewController(nibName: "NotificationsViewController", bundle: nil)
        self.navigationController?.pushViewController(notification, animated: true)
    }
    
    @IBAction func viewAllAction(_ sender: Any) {
        
        if FetchSitesDataModel.shared.sites().count > 0
        {
            let vc = CurrentWasteViewController(nibName: "CurrentWasteViewController", bundle: nil)
            self.navigationController?.pushTo(controller: vc)
        }
    }
    
}


//MARK: - Extentions

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == weatherCollectionView {
            
            return weatherCount
        }
        else{
            self.indicatorMarker.numberOfPages = FetchSitesDataModel.shared.sites().count
            return FetchSitesDataModel.shared.sites().count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == weatherCollectionView {
            let cell = collectionView.register(WeatherCollectionViewCell.self, indexPath: indexPath)
            cell.config(index: indexPath.row)
                return cell
        }
            
        else
        {
            let cell = collectionView.register(WasteTypeCollectionViewCell.self, indexPath: indexPath)
            let cellData = FetchSitesDataModel.shared.sites()[indexPath.row]
            cell.config(cellData.farmName, cellData.cropType , cellData.cropTypeImage)
            let currentCenteredPoint = CGPoint(x: wasteTypeCollectionView.contentOffset.x + wasteTypeCollectionView.bounds.width, y: wasteTypeCollectionView.contentOffset.y + wasteTypeCollectionView.bounds.height/2)
            if let cell = wasteTypeCollectionView.indexPathForItem(at: currentCenteredPoint) {
                self.indicatorMarker.currentPage = cell.row - 1 
                self.index = cell.row - 1
                
                let cellData = FetchSitesDataModel.shared.sites()[cell.row - 1]
                supplierCell?.config(cellData.sharedIconUrl)
            }

            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == weatherCollectionView {
            return CGSize(width: (weatherCollectionView.bounds.width )/6, height: weatherCollectionView.bounds.height)
        }
        else{
            return CGSize(width: (wasteTypeCollectionView.bounds.width - 100), height: wasteTypeCollectionView.bounds.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
        if collectionView == wasteTypeCollectionView{
            collectionView.deselectItem(at: indexPath, animated: true)
            self.indicatorMarker.currentPage = indexPath.row
            if collectionView == wasteTypeCollectionView {
                let vc = WasteDetailViewController(nibName: "WasteDetailViewController", bundle: nil)
                vc.farmID = FetchSitesDataModel.shared.sites()[indexPath.row].farmId
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
    }
    
}

//MARK: - TableView
extension HomeViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
//        if resultData?.pendingCollection ?? false {
//        }
//        else {
//            return 1
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.register(SupplierTableViewCell.self, indexPath: indexPath)
            cell.selectionStyle = .none
            cell.pendingCOllectionConfig()
            
            return cell
//            if resultData?.pendingCollection == true {
//            }
//            else {
//
//                //tableViewHeight.constant = homeScrollview.bounds.height * 0.341297//200 // 0.341297
//                let cell = tableView.register(SupplierTableViewCell.self, indexPath: indexPath)
//                cell.selectionStyle = .none
//                supplierCell = cell
//                cell.imgHeight.constant = cell.frame.height * 0.7
//                return cell
//            }
        }
        
        if indexPath.row == 1 {
            //tableViewHeight.constant = 400
            let cell = tableView.register(SupplierTableViewCell.self, indexPath: indexPath)
            supplierCell = cell
//            cell.config(resultData?.waste_type_questions?.waste_types?[3].share_icon_url ?? "")
            cell.selectionStyle = .none
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0
        {
            let vc = PendingCollectionViewController(nibName: "PendingCollectionViewController", bundle: nil)
            self.navigationController?.pushTo(controller: vc)
//            if resultData?.pendingCollection == true
//            {
//            }
//            else
//            {
//                let vc = InviteSupplierViewController(nibName: "InviteSupplierViewController", bundle: nil)
//                self.navigationController?.pushTo(controller: vc)
//            }
        }
        else
        {
            let vc = InviteSupplierViewController(nibName: "InviteSupplierViewController", bundle: nil)
            self.navigationController?.pushTo(controller: vc)

        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView != self.weatherCollectionView {
//            let currentCenteredPoint = CGPoint(x: scrollView.contentOffset.x + wasteTypeCollectionView.bounds.width, y: scrollView.contentOffset.y + wasteTypeCollectionView.bounds.height/2)
//            if let cell = wasteTypeCollectionView.indexPathForItem(at: currentCenteredPoint) {
//                self.indicatorMarker.currentPage = cell.row - 1
//                self.index = cell.row - 1
//                tableView.reloadData()
//            }
        }
    }
    
}


//MARK: - API calls
extension HomeViewController: WeatherCallDelegate, FetchSitesDataModelDelegate {
        
    func fetchFarmsFromServer()
    {
        FetchSitesDataModel.shared.reloadData()
        FetchSitesDataModel.shared.delegate = self
        
    }
    
    //  delegate methods
    
    func Weather() {
        
    }
    
    func sitesEmpty() {
        self.showPopupToCreateSite()
    }
}
