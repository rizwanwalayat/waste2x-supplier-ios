//
//  InvoicesViewController.swift
//  CarrierApp
//
//  Created by MAC on 26/07/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

enum DispatchesStatus:String {
    case paid = "Paid"
    case in_transit = "In Transit"
    case delivered = "Delivered"
}

class InvoicesViewController: BaseViewController {
    
    // MARK: - Variables
    var dispatchesStatusArray = [DispatchesStatus.paid, DispatchesStatus.in_transit, DispatchesStatus.delivered]
    var viewModel: InvoicesVM?
    var selectedIndex : IndexPath?
   
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var scheduledTab: UIButton!
    @IBOutlet weak var inTransitTab: UIButton!
    @IBOutlet weak var deliveredTab: UIButton!
    
    // MARK: - Controller's LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewHandlings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel = InvoicesVM()
//        viewModel?.fetchInvoicesData({ result, error, status, message in
//
//            if status ?? false, error == nil {
//                self.checkData()
//            } else {
//                self.showToast(message: error?.localizedDescription ?? message)
//            }
//        })
    }
    
    func tableviewHandlings(){
        
        tableView.register(UINib(nibName: "InvoicesTableViewCell", bundle: nil), forCellReuseIdentifier: "InvoicesTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func checkData(){
        
        if let count = viewModel?.data?.result?.array.count, count > 0 {
            showTable(true)
        } else {
            showTable(false)
        }
        self.tableView.reloadData()
    }
    
    func showTable(_ flag: Bool){
        if flag {
            tableView.isHidden = false
            noDataLabel.isHidden = true
        } else {
            tableView.isHidden = true
            noDataLabel.text = "No Invoices Available"
            noDataLabel.isHidden = false
        }
    }
    
    // MARK: - IBOutlets

}

extension InvoicesViewController : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1 //viewModel?.data?.result?.array.count ??
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoicesTableViewCell", for: indexPath) as! InvoicesTableViewCell
//        cell.dispatchButton.tag = indexPath.row
 
//        let cellData = viewModel?.data?.result?.array[0][indexPath.row]
//        cell.configCell(data: cellData!, status: dispatchesStatusArray[0])
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.beginUpdates()
        if selectedIndex == indexPath {
            
            if let cell = tableView.cellForRow(at: indexPath) as? InvoicesTableViewCell
            {
                cell.expand(false)
                self.selectedIndex = nil
            }
        }
        else if selectedIndex != nil
        {
            if let cell = tableView.cellForRow(at: selectedIndex!) as? InvoicesTableViewCell
            {
                cell.expand(false)
            }
            
            if let cell = tableView.cellForRow(at: indexPath) as? InvoicesTableViewCell
            {
                cell.expand(true)
            }
            selectedIndex = indexPath
        }
        else if selectedIndex == nil {
            if let cell = tableView.cellForRow(at: indexPath) as? InvoicesTableViewCell
            {
                cell.expand(true)
                self.selectedIndex = indexPath
            }
        }
        
        tableView.endUpdates()
       
    }
}

