//
//  MessagesViewController.swift
//  Waste2x
//
//  Created by MAC on 07/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
import TwilioChatClient

class ChatMessagesViewController: BaseViewController {

    
    //MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var enterMessageTextView: UITextView!
    @IBOutlet weak var constHeightMessagesTextView: NSLayoutConstraint!
    @IBOutlet weak var tableViewMessages: UITableView!
    @IBOutlet weak var sendbutton: UIButton!
    @IBOutlet weak var sendIndicator: UIActivityIndicatorView!
    
    
    //MARK: - Declarations
    
    var textFildPlaceholder = UIColor(hexString: "9F9F9F")
    var placeHolderText = "Write your message..."
    //var refreshControl = UIRefreshControl()
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        enterMessageTextView.text       = placeHolderText
        enterMessageTextView.textColor  = textFildPlaceholder
        tableViewsIntegrations()
        (TwillioChatDataModel.shared.messages.count == 0) ? (loginToTwillio()) : (TwillioChatDataModel.shared.delegate = self)
    }


    //MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        globalObjectContainer?.tabbarHiddenView.isHidden = false
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
        if enterMessageTextView.text == "" || enterMessageTextView.text == placeHolderText
        {
            return
        }
        
        self.sendbutton.isHidden = true
        self.sendIndicator.startAnimating()
        TwillioChatDataModel.shared.sendMessage(enterMessageTextView.text!) { result, message in
            
            self.sendbutton.isHidden = false
            self.sendIndicator.stopAnimating()
            
            if result.isSuccessful() {
                
                self.enterMessageTextView.text = ""
                self.enterMessageTextView.resignFirstResponder()
                self.constHeightMessagesTextView.constant = 34.0
                self.view.layoutIfNeeded()
            } else {
                self.showToast(message: "Unable to send message")
            }
        }
    }
    
    func tableViewsIntegrations()
    {
        tableViewMessages.register(UINib(nibName: "MessagesTableViewCell", bundle: nil), forCellReuseIdentifier: "MessagesTableViewCell")
        tableViewMessages.rowHeight = UITableView.automaticDimension
        tableViewMessages.estimatedRowHeight = UITableView.automaticDimension
        tableViewMessages.transform          = CGAffineTransform(scaleX: 1, y: -1)
        self.constHeightMessagesTextView.constant = 34
//        refreshControl.tintColor       = UIColor.appColor
//        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
//        tableViewMessages.addSubview(refreshControl)
        self.view.layoutIfNeeded()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        
        /// code for pagination
        if TwillioChatDataModel.shared.messages.count >= TwillioChatDataModel.shared.messagesPage * TwillioChatDataModel.shared.messagesPageCount
        {
            TwillioChatDataModel.shared.fetchMoreMesseges()
        }
    }
    
}


extension ChatMessagesViewController : UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == textFildPlaceholder {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolderText
            textView.textColor = textFildPlaceholder
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        view.layoutIfNeeded()
        let sizeToFitIn = CGSize(width: self.enterMessageTextView.bounds.size.width, height: CGFloat(100))
        let newSize = self.enterMessageTextView.sizeThatFits(sizeToFitIn)
        
        if newSize.height < 25
        {
            self.constHeightMessagesTextView.constant = 25
        }
        else if newSize.height > 100
        {
            self.constHeightMessagesTextView.constant = 100
        }
        else
        {
            self.constHeightMessagesTextView.constant = newSize.height
        }
        
        UIView.animate(withDuration: 1.0, animations: {
             self.view.layoutIfNeeded()
        })
    }
}


extension ChatMessagesViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return TwillioChatDataModel.shared.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesTableViewCell", for: indexPath) as! MessagesTableViewCell
        
        let arrayIndex  = TwillioChatDataModel.shared.messages.count - indexPath.row
        let message = TwillioChatDataModel.shared.messages[arrayIndex - 1]
        
        cell.messagesHandling(message)
        /// code for pagination
        if indexPath.row == TwillioChatDataModel.shared.messages.count - 1
        {
            if TwillioChatDataModel.shared.messages.count >= TwillioChatDataModel.shared.messagesPageCount
            {
                TwillioChatDataModel.shared.fetchMoreMesseges()
            }
        }
        
        return cell
    }
    
    
}
