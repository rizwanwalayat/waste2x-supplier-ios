//
//  CommunitiesViewController.swift
//  ContainerView
//
//  Created by HaiD3R AwaN on 13/04/2021.
//

import UIKit

class HomeViewController: BaseViewController {
    
    
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
    
    //MARK: - Variables
    var notification:Bool = true
    var email:String = "Haid3rawan@icloud.com"
    var pendingCollection:Bool = true
    var timer: Timer?
    var count = Int()
    var selecetedIndex = 0
    var supplierCell: SupplierTableViewCell?
    var images = [#imageLiteral(resourceName: "poultry"),#imageLiteral(resourceName: "bottle"),#imageLiteral(resourceName: "tire"),#imageLiteral(resourceName: "food")]
    
    //MARK: - AppCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorMarker.numberOfPages = images.count
        count = images.count-1
//        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(slideToNext), userInfo: nil, repeats: true)
        collectionDataSourceDelegate(outlet: weatherCollectionView)
        collectionDataSourceDelegate(outlet: wasteTypeCollectionView)
        tableDataSourceDelegate(outlet: tableView)
        
        weatherCollectionView.backgroundColor = .clear
        self.progressPointsLabel.text = "\(Int(progressBar.progress*100))/100"
        welcomeLabel.text = email
        if notification {
            notificationMark.backgroundColor = UIColor.init(red: 196, green: 210, blue: 150, alpha: 1)
        }
        else
        {
            notificationMark.backgroundColor = .clear
        }
        
        wasteTypeCollectionView.contentInset  = .zero
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
        supplierCell?.config(index: index)
        indicatorMarker.currentPage = selecetedIndex
        wasteTypeCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
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
    
    
}


//MARK: - Extentions

extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == weatherCollectionView {
            return 5
        }
        else{
            return images.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == weatherCollectionView{
            let cell = collectionView.register(WeatherCollectionViewCell.self, indexPath: indexPath)
            cell.config()
            return cell
            
        }
        else
        {
            let cell = collectionView.register(WasteTypeCollectionViewCell.self, indexPath: indexPath)
            cell.config(index: indexPath.row)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == weatherCollectionView {
            return CGSize(width: weatherCollectionView.frame.width/6, height: weatherCollectionView.frame.height)
        }
        else{
            return CGSize(width: (wasteTypeCollectionView.bounds.width - 80), height: wasteTypeCollectionView.bounds.height)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        collectionView.deselectItem(at: indexPath, animated: true)
        self.indicatorMarker.currentPage = indexPath.row
        supplierCell?.config(index: indexPath.row)
        if collectionView == wasteTypeCollectionView {
            let wasteDetails = CurrentWasteViewController(nibName: "CurrentWasteViewController", bundle: nil)
            self.navigationController?.pushViewController(wasteDetails, animated: true)
            
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
            let cell = tableView.register(SupplierTableViewCell.self, indexPath: indexPath)
            supplierCell = cell
            cell.selectionStyle = .none
            return cell
        }
        
        else if pendingCollection == true {
            let cell = tableView.register(SupplierTableViewCell.self, indexPath: indexPath)
            cell.selectionStyle = .none
            cell.pendingCOllectionConfig()
            return cell
        }
        
        else {
            let cell = tableView.register(SupplierTableViewCell.self, indexPath: indexPath)
            cell.selectionStyle = .none
            supplierCell = cell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       let cell = wasteTypeCollectionView.visibleCells.first
        
        let indexPath = wasteTypeCollectionView.indexPath(for: cell ?? UICollectionViewCell())
        if let index = indexPath{
//            self.pendingCollection = ((supplierCell?.pendingCollectionCheck) != nil)
                supplierCell?.config(index: index.row)
        }
    }
    
}
