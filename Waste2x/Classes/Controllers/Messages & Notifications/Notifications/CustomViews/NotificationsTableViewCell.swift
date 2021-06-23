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
    @IBOutlet weak var stackViewButton : UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bodyView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    func notificationStatusHandlings(_ status : NotificationStatus, notificationTitle : String, detailText : String, questionText : String)
    {
        let acceptStatusColor = UIColor(hexString: "7D9D15", alpha: 0.15)
        let acceptLabelColor  = UIColor(hexString: "7D9D15")
        let acceptImage       = UIImage(named: "accept-icon")
        
        let rejectStatusColor = UIColor(hexString: "FA5656", alpha: 0.15)
        let rejectLabelColor  = UIColor(hexString: "FA5656")
        let rejectImage       = UIImage(named: "reject-icon")
        
        let pendingStatusColor = UIColor(hexString: "FFD367", alpha: 0.15)
        let pendingLabelColor  = UIColor(hexString: "FFD367")
        let pendingImage       = UIImage(named: "Pending-Icon")
        
        let confirmStatusColor = UIColor(hexString: "7D9D15", alpha: 0.15)
        let confirmLabelColor  = UIColor(hexString: "7D9D15")
        let confirmImage       = UIImage(named: "Confirm-icon")
        
        let otwStatusColor = UIColor(hexString: "7D9D15", alpha: 0.15)
        let otwLabelColor  = UIColor(hexString: "7D9D15")
        let otwImage       = UIImage(named: "Otw-Icon")
        
        switch status {
        case .accepted:
            self.notificationTitle.text = notificationTitle
            self.notificationDetailLabel.text = detailText
            self.notificationQuestionLabel.text = questionText
            self.notificationStatusHolderView.backgroundColor = acceptStatusColor
            self.notificationStatusLabel.textColor = acceptLabelColor
            self.notificationStatusLabel.text      = "Accepted"
            self.notificationStatusImageView.image = acceptImage
            self.stackViewButton.isHidden = true
            self.notificationQuestionLabel.isHidden = true
            self.notificationYesButton.setTitle("Yes", for: .normal)
            
        case .rejected:
            self.notificationTitle.text = notificationTitle
            self.notificationDetailLabel.text = detailText
            self.notificationQuestionLabel.text = questionText
            self.notificationStatusHolderView.backgroundColor = rejectStatusColor
            self.notificationStatusLabel.textColor = rejectLabelColor
            self.notificationStatusLabel.text      = "Rejected"
            self.notificationStatusImageView.image = rejectImage
            self.stackViewButton.isHidden = true
            self.notificationQuestionLabel.isHidden = true
            self.notificationYesButton.setTitle("Yes", for: .normal)
            
        case .pending:
            self.notificationTitle.text = notificationTitle
            self.notificationDetailLabel.text = detailText
            self.notificationQuestionLabel.text = questionText
            self.notificationStatusHolderView.backgroundColor = pendingStatusColor
            self.notificationStatusLabel.textColor = pendingLabelColor
            self.notificationStatusLabel.text      = "Pending"
            self.notificationStatusImageView.image = pendingImage
            self.notificationNoButton.isHidden = false
            self.notificationYesButton.isHidden = false
            self.notificationYesButton.setTitle("Yes", for: .normal)
            
        case .confirmed:
            self.notificationTitle.text = notificationTitle
            self.notificationDetailLabel.text = detailText
            self.notificationQuestionLabel.text = questionText
            self.notificationStatusHolderView.backgroundColor = confirmStatusColor
            self.notificationStatusLabel.textColor = confirmLabelColor
            self.notificationStatusLabel.text      = "Confrimed"
            self.notificationStatusImageView.image = confirmImage
            self.notificationNoButton.isHidden = true
            self.notificationQuestionLabel.isHidden = true
            self.notificationYesButton.setTitle("Check", for: .normal)
            
        case .onway:
            self.notificationTitle.text = notificationTitle
            self.notificationDetailLabel.text = detailText
            self.notificationQuestionLabel.text = questionText
            self.notificationStatusHolderView.backgroundColor = otwStatusColor
            self.notificationStatusLabel.textColor = otwLabelColor
            self.notificationStatusLabel.text      = "On Way"
            self.notificationStatusImageView.image = otwImage
            self.notificationNoButton.isHidden = true
            self.notificationQuestionLabel.isHidden = true
            self.notificationYesButton.setTitle("Track", for: .normal)
            
        }
    }
    
    
    func expand()
    {
        self.bodyView.isHidden = false
        print(index)
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
    
    func collapse()
    {
        self.bodyView.isHidden = true
        print(index)
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
    func config(data:NotificationModel,index:Int){
        self.notificationTitle.text = data.result?.notifications[index].title
        self.notificationDetailLabel.text = data.result?.notifications[index].message
        
        if  data.result?.notifications[index].response == "Yes"{
            self.notificationStatusHandlings(.accepted, notificationTitle: data.result!.notifications[index].title, detailText: data.result!.notifications[index].message, questionText: "Do you want to sell?")
            
        }
        else if data.result?.notifications[index].response == "No"{
            self.notificationStatusHandlings(.rejected, notificationTitle: data.result!.notifications[index].title, detailText: data.result!.notifications[index].message, questionText: "Do you want to sell?")
        }
        else if data.result?.notifications[index].response == "Onway"{
            self.notificationStatusHandlings(.onway, notificationTitle: data.result!.notifications[index].title, detailText: data.result!.notifications[index].message, questionText: "Do you want to sell?")
        }
        else if data.result?.notifications[index].response == "Confirmed"{
            self.notificationStatusHandlings(.confirmed, notificationTitle: data.result!.notifications[index].title, detailText: data.result!.notifications[index].message, questionText: "Do you want to sell?")
        }
        else {
            self.notificationStatusHandlings(.pending, notificationTitle: data.result!.notifications[index].title, detailText: data.result!.notifications[index].message, questionText: "Do you want to sell?")
        }
        
    }
    
}

enum NotificationStatus {
    case accepted
    case rejected
    case pending
    case confirmed
    case onway
}
