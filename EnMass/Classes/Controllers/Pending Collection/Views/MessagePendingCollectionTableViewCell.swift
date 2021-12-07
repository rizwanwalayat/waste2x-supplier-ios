//
//  MessagePendingCollectionTableViewCell.swift
//  Waste2x
//
//  Created by Phaedra Solutions  on 02/11/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class MessagePendingCollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var messageCustomerBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var declineBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var statusLable: UILabel!
    @IBOutlet weak var acceptDeclineButtons: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func statusViewHandlings(_ status : PoRequestStatus)
    {
        self.statusView.isHidden = false
        self.cancelBtn.isHidden = false
        self.acceptDeclineButtons.isHidden = false
        self.messageCustomerBtn.isHidden = false
        
        switch status {
        
        case .notSent:
            self.statusView.isHidden = true
            self.cancelBtn.isHidden = true
        case .pendingResponse:
            self.statusView.isHidden = true
            self.cancelBtn.isHidden = true
        case .denied:
            self.cancelBtn.isHidden = true
            self.acceptDeclineButtons.isHidden = true
            self.messageCustomerBtn.isHidden = true
            self.colorSchemeHandlings(status)
        case .approved:
            self.acceptDeclineButtons.isHidden = true
            self.colorSchemeHandlings(status)
        }
    }
    
    fileprivate func colorSchemeHandlings(_ status : PoRequestStatus){
        
        if status == .denied {
            
            statusView.backgroundColor = .failureMessage
            statusImageView.tintColor = .failureMessageTextIcon
            statusLable.textColor = .failureMessageTextIcon
        }
        
        else if status == .approved {
            
            statusView.backgroundColor = .successMessage
            statusImageView.tintColor = .successMessageTextIcon
            statusLable.textColor = .successMessageTextIcon
        }
    }
}
