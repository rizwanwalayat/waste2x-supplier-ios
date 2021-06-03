//
//  ScheduleOptionsViewController.swift
//  Waste2x
//
//  Created by MAC on 02/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

protocol ScheduleOptionsViewControllerDelegate {
    func didSelectOption(_ selectedOption : String)
    func didDismiss()
}
class ScheduleOptionsViewController: BaseViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var mainHolderview: UIView!
    @IBOutlet weak var dataHolderview: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var constTableviewHeight : NSLayoutConstraint!
    
    // MARK: - Declarations
    
    var optionsData = [String]()
    var alreadySelectedString = ""
    var selectedIndex = IndexPath()
    var delegate : ScheduleOptionsViewControllerDelegate?
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        tableviewHandlings()
        self.dataHolderview.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        alreadySelectedDataHandlings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableview.reloadData()
        DispatchQueue.main.async {
            self.constTableviewHeight.constant = self.tableview.contentSize.height
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [],  animations: {
            
          self.dataHolderview.transform = .identity
        })
    }
    
    // MARK: - Custom Methods
    
    func tableviewHandlings()
    {
        tableview.register(UINib(nibName: "ScheduleOptionsTableViewCell", bundle: nil), forCellReuseIdentifier: "ScheduleOptionsTableViewCell")
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = UITableView.automaticDimension
        tableview.reloadData()
        DispatchQueue.main.async {
            self.constTableviewHeight.constant = self.tableview.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    func hidePopup()
    {
        dataHolderview.alpha = 1
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
            
            self.dataHolderview.alpha = 0
            self.dataHolderview.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

        }) { (success) in
            
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func alreadySelectedDataHandlings()
    {
        var counter = 0
        for option in optionsData
        {
            if option == alreadySelectedString
            {
                selectedIndex = IndexPath(row: counter, section: 0)
                break
            }
            counter = counter + 1
        }
        self.tableview.reloadData()
    }


    // MARK: - Actions
   
    @IBAction func backgroundButton(_ sender: Any) {
        
        hidePopup()
        delegate?.didDismiss()
    }
    
}

// MARK: - Tableview delegate and datasource

extension ScheduleOptionsViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleOptionsTableViewCell", for: indexPath) as! ScheduleOptionsTableViewCell
        
        cell.titleTextLable.text = optionsData[indexPath.row]
        if indexPath == selectedIndex
        {
            cell.selectedView(true)
        }
        else
        {
            cell.selectedView(false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        hidePopup()
        delegate?.didSelectOption(optionsData[indexPath.row])
    }
    
}
