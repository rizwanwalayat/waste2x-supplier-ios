//
//  InvoicesViewController.swift
//  CarrierApp
//
//  Created by MAC on 26/07/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit


class InvoicesViewController2: BaseViewController {
    
    // MARK: - Variables
    var viewModel: InvoicesVM?
    var selectedIndex : IndexPath?
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var backgroundHolderview: UIView!
    
    
    // MARK: - Controller's LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        roundTopHeader()
        
//        viewModel = InvoicesVM()
//        viewModel?.fetchInvoicesData({ result, error, status, message in
//
//            if status ?? false, error == nil {
//                self.checkData()
//            } else {
//                self.showToast(message: error?.localizedDescription ?? message)
//            }
//        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableviewHandlings()

        
    }
    func roundTopHeader(){
        backgroundHolderview.layer.cornerRadius = 36
        backgroundHolderview.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        backgroundHolderview.layer.masksToBounds = true
    }
    func tableviewHandlings(){
        
        tableView.register(UINib(nibName: "InvoicesTableViewCell", bundle: nil), forCellReuseIdentifier: "InvoicesTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
//    func checkData(){
//
//        if let count = viewModel?.data?.result.count, count > 0 {
//            showTable(true)
//        } else {
//            showTable(false)
//        }
//        self.tableView.reloadData()
//    }
//
//    func showTable(_ flag: Bool){
//        if flag {
//            tableView.isHidden = false
//            noDataLabel.isHidden = true
//        } else {
//            tableView.isHidden = true
//            noDataLabel.text = "No Invoices Available"
//            noDataLabel.isHidden = false
//        }
//    }
    
    // MARK: - IBOutlets

    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension InvoicesViewController2 : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  3 //viewModel?.data?.result?.array.count ??
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoicesTableViewCell", for: indexPath) as! InvoicesTableViewCell
 
//        let cellData = viewModel?.data?.result[indexPath.row]
//        cell.configCell(data: cellData!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        tableView.beginUpdates()
//        if selectedIndex == indexPath {
//
//            if let cell = tableView.cellForRow(at: indexPath) as? InvoicesTableViewCell
//            {
//                cell.expand(false)
//                self.selectedIndex = nil
//            }
//        }
//        else if selectedIndex != nil
//        {
//            if let cell = tableView.cellForRow(at: selectedIndex!) as? InvoicesTableViewCell
//            {
//                cell.expand(false)
//            }
//
//            if let cell = tableView.cellForRow(at: indexPath) as? InvoicesTableViewCell
//            {
//                cell.expand(true)
//            }
//            selectedIndex = indexPath
//        }
//        else if selectedIndex == nil {
//            if let cell = tableView.cellForRow(at: indexPath) as? InvoicesTableViewCell
//            {
//                cell.expand(true)
//                self.selectedIndex = indexPath
//            }
//        }
//
//        tableView.endUpdates()
       
    }
}

