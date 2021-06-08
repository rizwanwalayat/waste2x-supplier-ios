//
//  MessagesViewController.swift
//  Waste2x
//
//  Created by MAC on 07/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class ChatMessagesViewController: BaseViewController {

    
    //MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var enterMessageTextView: UITextView!
    @IBOutlet weak var constHeightMessagesTextView: NSLayoutConstraint!
    @IBOutlet weak var tableViewMessages: UITableView!
    
    
    //MARK: - Declarations
    
    var textFildPlaceholder = UIColor(hexString: "9F9F9F")
    var placeHolderText = "Write your message..."
    var messagesArray = [String]()
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        enterMessageTextView.text       = placeHolderText
        enterMessageTextView.textColor  = textFildPlaceholder
        
        tableViewMessages.register(UINib(nibName: "MessagesTableViewCell", bundle: nil), forCellReuseIdentifier: "MessagesTableViewCell")
        tableViewMessages.rowHeight = UITableView.automaticDimension
        tableViewMessages.estimatedRowHeight = UITableView.automaticDimension
        tableViewMessages.transform          = CGAffineTransform(scaleX: 1, y: -1)
        self.constHeightMessagesTextView.constant = 34
        self.view.layoutIfNeeded()
    }


    //MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        globalObjectContainer?.tabbarHiddenView.isHidden = false
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        if enterMessageTextView.text == "" || enterMessageTextView.text == placeHolderText
        {
            return
        }
        
        messagesArray.append(enterMessageTextView.text)
        tableViewMessages.reloadData()
        let indexPath = IndexPath(item: self.messagesArray.count - 1, section: 0)
        self.tableViewMessages.reloadRows(at: [indexPath], with: .bottom)
        
        enterMessageTextView.text = ""
        constHeightMessagesTextView.constant = 34.0
        self.view.layoutIfNeeded()
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
        
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesTableViewCell", for: indexPath) as! MessagesTableViewCell
        
        cell.messageLabel.text = messagesArray[indexPath.row]
        cell.transform  = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
    
    
}
