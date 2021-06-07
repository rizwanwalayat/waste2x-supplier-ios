//
//  NotificationsViewController.swift
//  Waste2x
//
//  Created by MAC on 27/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainHolderView: UIView!
    @IBOutlet weak var notificationsTableview : UITableView!
    @IBOutlet weak var bottomConst : NSLayoutConstraint!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationsTableview.register(UINib(nibName: "NotificationsTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationsTableViewCell")
        notificationsTableview.rowHeight = UITableView.automaticDimension
        notificationsTableview.estimatedRowHeight = UITableView.automaticDimension
        
        mainHolderView.roundCorners(uiViewCorners: .top, radius: 32)
        bottomConst.constant = tabbarViewHeight
        self.view.layoutIfNeeded()
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func yesButtonPress(sender:UIButton){
        switch sender.tag {
        case 4:
            let vc = TrackerViewController(nibName: "TrackerViewController", bundle: nil)
            self.navigationController?.pushTo(controller: vc)
        default:
            let vc = NotificationsViewController(nibName: "NotificationsViewController", bundle: nil)
            self.navigationController?.pushTo(controller: vc)
        }
    }
    
}

extension NotificationsViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell", for: indexPath) as! NotificationsTableViewCell
        cell.notificationYesButton.tag = indexPath.row
        cell.notificationYesButton.addTarget(self, action: #selector(yesButtonPress(sender:)), for: .touchUpInside)
        switch indexPath.row {
        
        
        case 0:
            
            cell.notificationStatusHandlings(.pending, notificationTitle: "Purchase Request from Enmass", detailText: "EnMass Energy requested you to sell 10 Tons waste of commodity “Crop waste - Cotton” at price of $100.", questionText: "Do you want to sell?")
            
        case 1:
            
            cell.notificationStatusHandlings(.rejected, notificationTitle: "Purchase Request from Enmass", detailText: "EnMass Energy requested you to sell 10 Tons waste of commodity “Crop waste - Cotton” at price of $100.", questionText: "Do you want to sell?")
            
        case 2:
            
            cell.notificationStatusHandlings(.accepted, notificationTitle: "Purchase Request from Enmass", detailText: "EnMass Energy requested you to sell 10 Tons waste of commodity “Crop waste - Cotton” at price of $100.", questionText: "Do you want to sell?")
            
        case 3:
            
            cell.notificationStatusHandlings(.confirmed, notificationTitle: "Pickup schedule has been confirmed", detailText: "You can check your pickup schedule information on Pending Collection or by clicking this button.", questionText: "")
            
        case 4:
            
            cell.notificationStatusHandlings(.onway, notificationTitle: "Vehicle on route to your location", detailText: "EnMass Energy vehicle is on the way to your supplies location.", questionText: "")
            
        default:
            
            print("Default select")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? NotificationsTableViewCell
        {
            cell.expandCollapse()
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}
