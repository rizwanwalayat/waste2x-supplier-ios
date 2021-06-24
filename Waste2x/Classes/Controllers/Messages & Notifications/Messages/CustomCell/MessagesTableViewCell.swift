//
//  MessagesTableViewCell.swift
//  Waste2x
//
//  Created by MAC on 07/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
import TwilioChatClient

class MessagesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var mainHolderview : UIView!
    @IBOutlet weak var messageLabel : UILabel!
    @IBOutlet weak var timeLabel : UILabel!
    @IBOutlet weak var receiverHolderView: UIView!
    @IBOutlet weak var receiverTimeLabel: UILabel!
    @IBOutlet weak var receiverMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func messagesHandling(_ cellData : TCHMessage)
    {
        receiverHolderView.isHidden = true
        mainHolderview.isHidden = true
        messageLabel.text = cellData.body
        timeLabel.text = cellData.timestampAsDate?.dateToString("HH:MM")
        receiverMessageLabel.text = cellData.body
        receiverTimeLabel.text = cellData.timestampAsDate?.dateToString("HH:MM")
        
        self.transform  = CGAffineTransform(scaleX: 1, y: -1)
        
        if let author = cellData.author?.trimmingCharacters(in: .whitespaces).uppercased(), let phone = DataManager.shared.getUser()?.result?.phone.trimmingCharacters(in: .whitespaces).uppercased() {
            
            let authorPhone = author.split(separator: "=").last ?? ""
            if authorPhone == phone
            {
                mainHolderview.isHidden = false
            }
            else
            {
                receiverHolderView.isHidden = false
            }
        }
    }
    
    func timeStampStringToTimeReturn(_ timeStamp : String) -> String?
    {
        let dateTime = timeStamp.stringToDate("yyyy-MM-dd'T'HH:mm:ss.SSSZ")
        let dateString = dateTime?.dateToString("HH:MM")
        return dateString
    }
}
