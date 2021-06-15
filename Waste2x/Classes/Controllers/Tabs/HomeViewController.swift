//
//  CommunitiesViewController.swift
//  ContainerView
//
//  Created by HaiD3R AwaN on 13/04/2021.
//

import UIKit
import Alamofire
import ObjectMapper
protocol WeatherCallDelegate {
    func Weather()
}
var globalObjectHome : HomeViewController?
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
    
    
    //MARK: - Variables
    
    var notification:Bool = true
    var email:String = "Haid3rawan@icloud.com"
    var pendingCollection = false
    var timer: Timer?
    var count = Int()
    var selecetedIndex = 0
    var supplierCell: SupplierTableViewCell?
    var images = [#imageLiteral(resourceName: "poultry"),#imageLiteral(resourceName: "bottle"),#imageLiteral(resourceName: "tire"),#imageLiteral(resourceName: "food")]
    var weatherCount  = 5
    var delegate:WeatherCallDelegate?
    var resultData : HomeResultDataModel?
    var fetchSitesData = [FetchSitesCustomModel]()
    
    //MARK: - AppCycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        print(Data?.auth_token ?? "")
        (UIApplication.shared.delegate as! AppDelegate).weaterCalldelegate = self
        bottomConst.constant = tabbarViewHeight
        globalObjectHome = self
        tableView.reloadData()
        setAttributedTextInLable(emailAddress: DataManager.shared.getUser()?.result?.email ?? "")
        self.indicatorMarker.currentPage = 0
        indicatorMarker.numberOfPages = images.count
        let progressbarAdjustment = UIScreen.main.bounds.height / 222
        progressBar.transform = CGAffineTransform(scaleX: 1, y: progressbarAdjustment)
        count = images.count-1
        collectionDataSourceDelegate(outlet: weatherCollectionView)
        collectionDataSourceDelegate(outlet: wasteTypeCollectionView)
        tableDataSourceDelegate(outlet: tableView)
        weatherCollectionView.backgroundColor = .clear
        
        
        if notification {
            notificationMark.backgroundColor = UIColor.init(red: 196, green: 210, blue: 150, alpha: 1)
        }
        else
        {
            notificationMark.backgroundColor = .clear
        }
        
        wasteTypeCollectionView.contentInset  = .zero
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.reloadData()
        DispatchQueue.main.async {
            self.tableViewHeight.constant = self.tableView.contentSize.height
            self.view.layoutIfNeeded()
        }
        
        fetchFarmsFromServer()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        weatherCollectionView.reloadData()
        tableView.reloadData()
    }
    
    
    //MARK: - Logic For Slider
    
    @objc func slideToNext() {
        if count > 0  {
            print(selecetedIndex)
            moveOn(index: selecetedIndex)
            selecetedIndex = selecetedIndex + 1
            count = count - 1

        }
        else {
            print(selecetedIndex)
            moveOn(index: selecetedIndex)
            selecetedIndex = 0
            count = images.count-1
            
        }
    }
    func moveOn(index: Int){
        //supplierCell?.config(index: index)
        indicatorMarker.currentPage = selecetedIndex
        wasteTypeCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
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
    
    func setAttributedTextInLable(emailAddress :String)
    {
        let boldfont       = UIFont(name: "Poppins-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .semibold)
        let activityAttribute   = [ NSAttributedString.Key.font: boldfont, NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "ffffff")]
        let nameAttrString      = NSMutableAttributedString(string: "Hello, ", attributes: activityAttribute)
        
        let emailFont            = UIFont(name: "Poppins", size: 18) ?? UIFont.systemFont(ofSize: 18)
        let nameAttribute       = [ NSAttributedString.Key.font: emailFont, NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "ffffff")]
        let activityAttrString  = NSAttributedString(string: emailAddress, attributes: nameAttribute)
        
        nameAttrString.append(activityAttrString)
        
        welcomeLabel.attributedText = nameAttrString
    }

    
    //MARK: - ActionButtons
    @IBAction func sideMenuAction(_ sender: Any) {
        
        if let slideMenuController = self.slideMenuController() {
            slideMenuController.openLeft()
        }
        let vc = ScheduleViewController(nibName: "ScheduleViewController", bundle: nil)
        vc.array = ["ali","haid3r"]
    }
    
    @IBAction func notificationAction(_ sender: Any) {
        let notification = NotificationsViewController(nibName: "NotificationsViewController", bundle: nil)
        self.navigationController?.pushViewController(notification, animated: true)
    }
    
    @IBAction func viewAllAction(_ sender: Any) {
        let vc = CurrentWasteViewController(nibName: "CurrentWasteViewController", bundle: nil)
        self.navigationController?.pushTo(controller: vc)
    }
    
}


//MARK: - Extentions

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == weatherCollectionView {
            
            return weatherCount
        }
        else{
            return fetchSitesData.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == weatherCollectionView{
            let cell = collectionView.register(WeatherCollectionViewCell.self, indexPath: indexPath)
            let weatherTemp = DataManager.shared.getWeather()?.list[indexPath.row].main?.temp ?? 00
            cell.tempratureLabel.text = "\(weatherTemp.shortValue)°" + ""
               
            cell.config()
            return cell
            
        }
        else
        {
            let cell = collectionView.register(WasteTypeCollectionViewCell.self, indexPath: indexPath)
            
            let cellData = fetchSitesData[indexPath.row]
//            var cropTypeName = cellData.cropType.components(separatedBy: "-").first ?? ""
//            cropTypeName = cropTypeName.trimmingCharacters(in: .whitespaces)
            cell.config(cellData.farmName, cellData.cropType , cellData.cropTypeImage)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == weatherCollectionView {
            return CGSize(width: (weatherCollectionView.frame.width )/6, height: weatherCollectionView.frame.height)
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
            let cellData = fetchSitesData[indexPath.row]
            supplierCell?.config(cellData.sharedIconUrl)
            if collectionView == wasteTypeCollectionView {
                let wasteDetails = CurrentWasteViewController(nibName: "CurrentWasteViewController", bundle: nil)
                self.navigationController?.pushViewController(wasteDetails, animated: true)
                
            }
        }
    }
}

//MARK: - TableView
extension HomeViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if pendingCollection {
            return 2
        }
        else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            //tableViewHeight.constant = 400
            let cell = tableView.register(SupplierTableViewCell.self, indexPath: indexPath)
            supplierCell = cell
            cell.selectionStyle = .none
            return cell
        }
        
        else if pendingCollection == true {
            //tableViewHeight.constant = 400
            let cell = tableView.register(SupplierTableViewCell.self, indexPath: indexPath)
            cell.selectionStyle = .none
            cell.pendingCOllectionConfig()
            return cell
        }
        
        else {
            //tableViewHeight.constant = homeScrollview.bounds.height * 0.341297//200 // 0.341297
            let cell = tableView.register(SupplierTableViewCell.self, indexPath: indexPath)
            cell.selectionStyle = .none
            supplierCell = cell
            cell.imgHeight.constant = cell.frame.height * 0.7
            return cell
        }
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return pendingCollection ? (tableView.frame.height / 2) : tableView.frame.height
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0{
        if pendingCollection
        {
            let vc = PendingCollectionViewController(nibName: "PendingCollectionViewController", bundle: nil)
            self.navigationController?.pushTo(controller: vc)
        }
        }
        else
        {
            let text = "Invite Supplieer."
            let textToShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       let cell = wasteTypeCollectionView.visibleCells.first
        
        let indexPath = wasteTypeCollectionView.indexPath(for: cell ?? UICollectionViewCell())
        if let index = indexPath{
            
            let cellData = fetchSitesData[index.row]
            supplierCell?.config(cellData.sharedIconUrl)
        }
        
        if scrollView != self.weatherCollectionView {
            let index = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            self.indicatorMarker.currentPage = index
        }
    }
    
}


//MARK: - API calls
extension HomeViewController: WeatherCallDelegate {
    

    func Weather() {
        self.weatherCount = DataManager.shared.getWeather()?.list.count ?? 0
        self.weatherCollectionView.reloadData()
    }
    
    
    func fetchFarmsFromServer()
    {
        HomeFetchFarmsDataModel.fetchSites { response, error, statusCode in
            
            if error != nil
            {
                Utility.showAlertController(self, error!.localizedDescription)
            }
            
            if response != nil {
                
                if statusCode == 200 {
                    
                    self.resultData = response!.result
                    self.homeDatapopulate()
                }
                else
                {
                    Utility.showAlertController(self, "Data not fetched")
                }
            }
        }
    }
    
    func homeDatapopulate()
    {
        
        self.fetchSitesData.removeAll()
        if self.resultData != nil
        {
            progressBar.progress = Float(self.resultData!.percentage)
            self.setAttributedTextInLable(emailAddress: Data?.email ?? "")
            self.progressPointsLabel.text = "\(Int((DataManager.shared.getUser()?.result?.percentage ?? 0 )*100))/100"
            
            for commudity in self.resultData!.commodity_farms
            {
                if commudity.farms != nil
                {
                    for farms in commudity.farms!
                    {
                        var cropTypeName = commudity.crop_type?.components(separatedBy: "-").first ?? ""
                        cropTypeName = cropTypeName.trimmingCharacters(in: .whitespaces)
                        
                        let farmsData = FetchSitesCustomModel(farms.name, farms.id
                                                              , cropTypeName, commudity.crop_type_id ?? 0, commudity.crop_type_image ?? "")
                        
                        self.fetchSitesData.append(farmsData)
                    }
                }
            }
            
            if self.resultData!.waste_type_questions != nil && self.resultData!.waste_type_questions?.waste_types != nil {
                
                for wasteType in self.resultData!.waste_type_questions!.waste_types!
                {
                    if let cropTypeNameArray = wasteType.title {
                        
                        let cropName = cropTypeNameArray.trimmingCharacters(in: .whitespaces)
                        
                        if let row = self.fetchSitesData.firstIndex(where: {$0.cropType == cropName}) {
                            let objectIndex = self.fetchSitesData[row]
                            objectIndex.sharedIconUrl = wasteType.share_icon_url ?? ""
                        }
                        
                    }
                }
            }
            
            self.wasteTypeCollectionView.reloadData()
        }
        else
        {
            Utility.showAlertController(self, "Invalid token, data not fetched")
        }
    }
}
