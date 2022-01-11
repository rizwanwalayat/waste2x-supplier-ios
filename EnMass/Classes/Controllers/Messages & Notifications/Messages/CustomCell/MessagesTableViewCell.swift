//
//  MessagesTableViewCell.swift
//  Waste2x
//
//  Created by MAC on 07/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit
import TwilioChatClient

class MessagesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var mainHolderview : UIView!
    @IBOutlet weak var messageLabel : UILabel!
    @IBOutlet weak var timeLabel : UILabel!
    @IBOutlet weak var linkClickableButton: UIButton!
    
    @IBOutlet weak var receiverHolderView: UIView!
    @IBOutlet weak var receiverTimeLabel: UILabel!
    @IBOutlet weak var receiverMessageLabel: UILabel!
    @IBOutlet weak var receiverLinkClickableButton: UIButton!
  
    
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
        if cellData.hasMedia() {
            messageLabel.text = cellData.mediaFilename
            receiverMessageLabel.text = cellData.mediaFilename
            messageLabel.textColor = UIColor(named: "primary") ?? .blue
            receiverMessageLabel.textColor = UIColor(named: "primary") ?? .blue
        } else {
            messageLabel.text = cellData.body
            receiverMessageLabel.text = cellData.body
            messageLabel.textColor = .black
            receiverMessageLabel.textColor = .white
        }
      
       
        
        self.transform  = CGAffineTransform(scaleX: 1, y: -1)
        if let author = cellData.author?.trimmingCharacters(in: .whitespaces).uppercased(), let phone = DataManager.shared.getUser()?.result?.phone.trimmingCharacters(in: .whitespaces).uppercased() {
            
            let authorPhone = author.split(separator: "=").last ?? ""
            if authorPhone.contains(phone){
                
                if cellData.hasMedia() {
                    messageLabel.text = cellData.mediaFilename
                    messageLabel.textColor = UIColor(named: "primary") ?? .blue
                } else {
                    messageLabel.text = cellData.body
                    messageLabel.textColor = .white
                }
                timeLabel.text = cellData.dateCreatedAsDate?.dateToString("HH:mm")
                mainHolderview.isHidden = false
            }
            else{
               
                if cellData.hasMedia() {
                    receiverMessageLabel.text = cellData.mediaFilename
                    receiverMessageLabel.textColor = UIColor(named: "primary") ?? .blue
                } else {
                    receiverMessageLabel.text = cellData.body
                    receiverMessageLabel.textColor = .black
                }
                
                receiverTimeLabel.text = cellData.dateCreatedAsDate?.dateToString("HH:mm")
                receiverHolderView.isHidden = false
            }
        }
    }
    
    @IBAction func buttonClicked(sender : UIButton) {
  
    }
    
    
    func timeStampStringToTimeReturn(_ timeStamp : String) -> String?
    {
        let dateTime = timeStamp.stringToDate("yyyy-MM-dd'T'HH:mm:ss.SSSZ")
        let dateString = dateTime?.dateToString("HH:mm")
        return dateString
    }
    func date(){
        
    }
}
