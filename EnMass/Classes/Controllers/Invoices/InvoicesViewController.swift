//
//  InvoicesViewController.swift
//  EnMass
//
//  Created by Phaedra Solutions  on 03/02/2022.
//  Copyright © 2022 codesrbit. All rights reserved.
//

import UIKit

enum PaidStatus: String {
    case paid = "Paid"
    case unpaid = "Unpaid"
}

class InvoicesViewController: BaseViewController {

    // MARK: - Variables
    var viewModel: InvoicesVM?

    // MARK: - Outlets
    @IBOutlet weak var backgroundHolderview: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var invoicesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        invoicesTableView.register(UINib(nibName: "InvoicesTableViewCell", bundle: nil), forCellReuseIdentifier: "InvoicesTableViewCell")
        invoicesTableView.estimatedRowHeight = UITableView.automaticDimension
        invoicesTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        roundTopHeader()
        
                viewModel = InvoicesVM()
                viewModel?.fetchInvoicesData({ result, error, status, message in
        
                    if status ?? false, error == nil {
                        self.checkData()
                    } else {
                        self.showToast(message: error?.localizedDescription ?? message)
                    }
                })
    }
      
    func roundTopHeader(){
        backgroundHolderview.layer.cornerRadius = 36
        backgroundHolderview.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        backgroundHolderview.layer.masksToBounds = true
    }
    
    func checkData(){
    
            if let count = viewModel?.data?.result.count, count > 0 {
                showTable(true)
            } else {
                showTable(false)
            }
            self.invoicesTableView.reloadData()
        }
    
        func showTable(_ flag: Bool){
            if flag {
                invoicesTableView.isHidden = false
                noDataLabel.isHidden = true
            } else {
                invoicesTableView.isHidden = true
                noDataLabel.text = "No Invoices Available"
                noDataLabel.isHidden = false
            }
        }
    
    //MARK: - IBOutlets
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

   
}

extension InvoicesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return viewModel?.data?.result.count ?? 0
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvoicesTableViewCell", for: indexPath) as! InvoicesTableViewCell
        let cellData = viewModel?.data?.result[indexPath.section]
        cell.configCell(data: cellData!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 13
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                tableView.beginUpdates()
        if let cell = tableView.cellForRow(at: indexPath) as? InvoicesTableViewCell
                  {
                      cell.expand()
                  }
                tableView.endUpdates()
    }
    
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
    
    
}
