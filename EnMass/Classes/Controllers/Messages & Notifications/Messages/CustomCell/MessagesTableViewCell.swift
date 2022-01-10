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
    @IBOutlet weak var fileTextView: UITextView!
    @IBOutlet weak var receiverHolderView: UIView!
    @IBOutlet weak var receiverTimeLabel: UILabel!
    @IBOutlet weak var receiverMessageLabel: UILabel!
    @IBOutlet weak var receiverFileTextView: UITextView!
    
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
        timeLabel.text = cellData.timestampAsDate?.dateToString("HH:mm")
        
        if cellData.hasMedia() {
            
//
//            cellData.getMediaWith(OutputStream, onStarted: <#T##TCHMediaOnStarted?##TCHMediaOnStarted?##() -> Void#>, onProgress: <#T##TCHMediaOnProgress?##TCHMediaOnProgress?##(UInt) -> Void#>, onCompleted: <#T##TCHMediaOnCompleted?##TCHMediaOnCompleted?##(String) -> Void#>, completion: <#T##TCHCompletion?##TCHCompletion?##(TCHResult) -> Void#>)
            let attrStr = NSMutableAttributedString(string: cellData.mediaFilename ?? "File")
            attrStr.addAttribute(.link, value: "", range: NSRange(location: 0, length: 1))
            receiverFileTextView.attributedText = attrStr
            fileTextView.attributedText = attrStr
        }
        receiverMessageLabel.text = cellData.body
        receiverTimeLabel.text = cellData.timestampAsDate?.dateToString("HH:mm")
        self.transform  = CGAffineTransform(scaleX: 1, y: -1)
        if let author = cellData.author?.trimmingCharacters(in: .whitespaces).uppercased(), let phone = DataManager.shared.getUser()?.result?.phone.trimmingCharacters(in: .whitespaces).uppercased() {
            
            let authorPhone = author.split(separator: "=").last ?? ""
            if authorPhone.contains(phone)
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
        let dateString = dateTime?.dateToString("HH:mm")
        return dateString
    }
    func date(){
        
    }
}
