//
//  NotificationsTableViewCell.swift
//  Waste2x
//
//  Created by MAC on 27/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var mainHolderview               : UIView!
    @IBOutlet weak var expandArrow                  : UIImageView!
    @IBOutlet weak var notificationTitle            : UILabel!
    @IBOutlet weak var notificationStatusHolderView : UIView!
    @IBOutlet weak var notificationStatusImageView  : UIImageView!
    @IBOutlet weak var notificationStatusLabel      : UILabel!
    @IBOutlet weak var notificationDetailLabel      : UILabel!
    @IBOutlet weak var notificationQuestionLabel    : UILabel!
    @IBOutlet weak var notificationYesButton        : UIButton!
    @IBOutlet weak var notificationNoButton         : UIButton!
    @IBOutlet weak var mainStackview                : UIStackView!
    @IBOutlet weak var headerView                   : UIView!
    @IBOutlet weak var bodyView                     : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    func notificationStatusHandlings(_ status : NotificationStatus)
    {
        switch status {
        case .accepted:
            
            self.notificationStatusHolderView.backgroundColor = UIColor(hexString: "7D9D15", alpha: 0.15)
            self.notificationStatusLabel.textColor = UIColor(hexString: "7D9D15")
            self.notificationStatusLabel.text      = "Accepted"
            self.notificationStatusImageView.image = UIImage(named: "accept-icon")
        case .rejected:
            
            self.notificationStatusHolderView.backgroundColor = UIColor(hexString: "FA5656", alpha: 0.15)
            self.notificationStatusLabel.textColor = UIColor(hexString: "FA5656")
            self.notificationStatusLabel.text      = "Rejected"
            self.notificationStatusImageView.image = UIImage(named: "reject-icon")
            
        case .pending:
            
            self.notificationStatusHolderView.backgroundColor = UIColor(hexString: "FFD367", alpha: 0.15)
            self.notificationStatusLabel.textColor = UIColor(hexString: "FFD367")
            self.notificationStatusLabel.text      = "Pending"
            self.notificationStatusImageView.image = UIImage(named: "Pending-Icon")
            
        }
    }
    
    
    func expandCollapse() {
        self.bodyView.isHidden = !self.bodyView.isHidden
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()}, completion: { finished in
            if self.expandArrow.image == UIImage(named: "Down-Arrow")
            {
                self.expandArrow.image = UIImage(named: "Right-arrow-gray")
            }
            else
            {
                self.expandArrow.image = UIImage(named: "Down-Arrow")
            }
        })
    }
}

enum NotificationStatus {
    case accepted
    case rejected
    case pending
}
