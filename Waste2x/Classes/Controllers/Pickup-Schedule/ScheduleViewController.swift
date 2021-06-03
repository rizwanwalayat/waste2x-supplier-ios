//
//  ScheduleViewController.swift
//  Waste2x
//
//  Created by MAC on 02/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class ScheduleViewController: BaseViewController {

    enum SelectionType {
        case none
        case onePickup
        case regular
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainHolderview: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var bottomConst : NSLayoutConstraint!
    @IBOutlet weak var nextButton : UIButton!
    
    
    // MARK: - Declarations
    
    var selectionType = SelectionType.none
    var filedsData    = [ScheduleType : String]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableviewHandlings()
        mainHolderview.roundCorners(uiViewCorners: .top, radius: 32)
        //bottomConst.constant = headerViewHeight
        self.view.layoutIfNeeded()
        
    }
    
    func tableviewHandlings()
    {
        tableview.register(UINib(nibName: "SchedulesTableViewCell", bundle: nil), forCellReuseIdentifier: "SchedulesTableViewCell")
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = UITableView.automaticDimension
    }

    
    // MARK: - Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
        
    @IBAction func nextButtonPressed(_ sender: UIButton)
    {
        print("next button pressed")
    }
}
