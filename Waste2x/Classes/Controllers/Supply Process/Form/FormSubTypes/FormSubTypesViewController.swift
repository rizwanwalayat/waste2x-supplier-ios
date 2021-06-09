//
//  FormSubTypesViewController.swift
//  Waste2x
//
//  Created by MAC on 09/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class FormSubTypesViewController: BaseViewController {

    
    // MARK: - Outlet
    
    @IBOutlet weak var mainHolderView: UIView!
    @IBOutlet weak var constHeightMainHolderview: NSLayoutConstraint!
    @IBOutlet weak var constTopMainHolderview: NSLayoutConstraint!
    @IBOutlet weak var dataContentView: UIView!
    @IBOutlet weak var formOfWasteLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constHeightTableview: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    
    
    // MARK: - Declarations
    
    var heightOfHiddenView : CGFloat = 0.0
    var tableViewCount =  3
    var tabaleViewIndex = 0
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainHolderView.roundCorners(uiViewCorners: .top, radius: 32)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        self.tableView.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(animated)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.heightOfHiddenView = self.dataContentView.bounds.height
        self.constHeightMainHolderview.constant = self.heightOfHiddenView
        self.constTopMainHolderview.constant   = -self.heightOfHiddenView
        
        UIView.animate(withDuration: 0.3,
                   delay: 0.1,
                   options: UIView.AnimationOptions.curveEaseInOut,
                   animations: { () -> Void in
                    
                    self.view.layoutIfNeeded()
                    
        }, completion: { (finished) -> Void in
        // ....
        })
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if(keyPath == "contentSize")
        {
            if let tableview = object as? UITableView
            {
                self.view.layoutIfNeeded()
                if tableview == self.tableView
                {
                    if let newvalue = change?[.newKey]{
                        let newsize  = newvalue as! CGSize
                        
                        self.constHeightTableview.constant = newsize.height
                    }
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    func hideView(_ forNavigate : Bool)
    {
        constTopMainHolderview.constant   = 0
        UIView.animate(withDuration: 0.3,
                   delay: 0.1,
                   options: UIView.AnimationOptions.curveEaseInOut,
                   animations: { () -> Void in
                    
                    self.view.alpha = 0
                    self.view.layoutIfNeeded()
                    
        }, completion: { (finished) -> Void in
            
            if forNavigate {
                
                let vc = FormOfWasteViewController(nibName: "FormOfWasteViewController", bundle: nil)
                vc.modalPresentationStyle = .overFullScreen
                vc.formForLiveStock = true
                self.present(vc, animated: true, completion: nil)
            }
            else
            {
                self.dismiss(animated: false, completion: nil)
            }
        })
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        hideView(true)
    }
    
    @IBAction func backgroundButtonPressed(_ sender: Any) {
        
        hideView(false)
    }
}


//MARK: - TableView

extension FormSubTypesViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.register(SupplyDetailTableViewCell.self, indexPath: indexPath)
        cell.selectionStyle = .none
        cell.configForGrade(index: indexPath.row)
        if tabaleViewIndex == indexPath.row {
            cell.mainView.borderColor = UIColor(named: "themeColor")
            cell.mainView.borderWidth = 2
        }
        else {
            cell.mainView.borderColor = .clear
            cell.mainView.borderWidth = 0
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let confirmCell = tableView.cellForRow(at: indexPath) as? SupplyDetailTableViewCell
        {
            confirmCell.selection(index: indexPath.row)
        }
        self.tabaleViewIndex = indexPath.row
        tableView.reloadData()
    }
    
}