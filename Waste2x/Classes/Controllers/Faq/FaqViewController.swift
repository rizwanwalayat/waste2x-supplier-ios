//
//  NotificationsViewController.swift
//  ContainerView
//
//  Created by HaiD3R AwaN on 13/04/2021.
//

import UIKit

class FaqViewController: BaseViewController {
    
    
//MARK: - IBOutlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    var faqListModell : [FaqResult]?
    var faqModelobject : FaqModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        mainView.layer.cornerRadius = 36
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        mainView.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        mainView.layer.masksToBounds = true
        globalObjectContainer?.tabbarHiddenView.isHidden = false
        if Global.shared.faqApiCheck{
            faqApiCall()
        }
        else{
            self.faqModelobject = Global.shared.faqModel
            self.faqListModell = Global.shared.faqListModel
            self.tableView.reloadData()
        }
        
    }

}


//MARK: - Extentions
extension FaqViewController : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return faqModelobject?.result?.faqs.count ?? 0
            
        } else {
            return faqModelobject?.result?.other.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.register(FaqTableViewCell.self, indexPath: indexPath)
            cell.config(data: faqModelobject!, index: indexPath.row, section: indexPath.section)
            cell.selectionStyle = .none
            return cell
        }
        else
        {
            let cell = tableView.register(FaqTableViewCell.self, indexPath: indexPath)
            cell.config(data: faqModelobject!, index: indexPath.row, section: indexPath.section)
            cell.selectionStyle = .none
            return cell
        }
       
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? FaqTableViewCell
        {
            cell.expandCollapse()
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
           return "AboutApps"
        }
        else {
            return "Others"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel()
        label.frame = CGRect.init(x: 15, y: 25, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.font = UIFont(name: "Poppins-Medium", size: 18)
        label.textColor = .black
        if section == 0
        {
            label.text = "About Apps"
        }
        else
        {
            label.text = "Others"
        }
        headerView.addSubview(label)
        return headerView
    }
    

}

//MARK: - API Extention
extension FaqViewController{
    func faqApiCall(){
        FaqModel.FaqApiFunction{ result, error, status,message in
            Global.shared.faqApiCheck = false
            if status == true{
                    self.faqModelobject = result
                    self.faqListModell = result?.result?.faqs
                    Global.shared.faqModel = result
                    Global.shared.faqListModel = result?.result?.faqs
                    self.tableView.reloadData()
            }
        }
    }
}

