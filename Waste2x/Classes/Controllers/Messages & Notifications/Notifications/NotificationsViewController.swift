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
    @IBOutlet weak var notificationsTableview : UITableView!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        notificationsTableview.register(UINib(nibName: "NotificationsTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationsTableViewCell")
        notificationsTableview.rowHeight = UITableView.automaticDimension
        notificationsTableview.estimatedRowHeight = UITableView.automaticDimension
    }
}

extension NotificationsViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell", for: indexPath) as! NotificationsTableViewCell
        switch indexPath.row {
        case 0:
            cell.notificationStatusHandlings(.pending)
        case 1:
            cell.notificationStatusHandlings(.rejected)
        default:
            cell.notificationStatusHandlings(.accepted)
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
