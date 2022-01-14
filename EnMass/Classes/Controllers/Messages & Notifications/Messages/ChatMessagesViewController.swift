//
//  MessagesViewController.swift
//  Waste2x
//
//  Created by MAC on 07/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit
import TwilioChatClient
import IQKeyboardManagerSwift
import UniformTypeIdentifiers

class ChatMessagesViewController: BaseViewController {

    
    //MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var enterMessageTextView: UITextView!
    @IBOutlet weak var constHeightMessagesTextView: NSLayoutConstraint!
    @IBOutlet weak var tableViewMessages: UITableView!
    @IBOutlet weak var sendbutton: UIButton!
    @IBOutlet weak var sendIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bottomConstOfView: NSLayoutConstraint!
    
    
    //MARK: - Declarations
    
    var textFildPlaceholder = UIColor(hexString: "9F9F9F")
    var placeHolderText = "Write message"
    var identity: String = ""
    //var refreshControl = UIRefreshControl()
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enterMessageTextView.text       = placeHolderText
        enterMessageTextView.textColor  = textFildPlaceholder
        tableViewsIntegrations()

        identity.contains("_") ? (titleLabel.text = "Message Customer") : (titleLabel.text = "Message us")
        loginToTwillio(identity: identity)
        
        NotificationCenter.default.addObserver(self,
               selector: #selector(self.keyboardNotification(notification:)),
               name: UIResponder.keyboardWillChangeFrameNotification,
               object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        mainView.layer.cornerRadius = 36
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        mainView.layer.masksToBounds = true
        globalObjectContainer?.tabbarHiddenView.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        TwillioChatDataModel.shared.shutdown()
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
        NotificationCenter.default.removeObserver(self)
        
    }

    //MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        globalObjectContainer?.tabbarHiddenView.isHidden = false
    }
    
    @IBAction func selectAttachment(_ sender: Any) {
        let alert = UIAlertController(title: "Attachment Type", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Image", style: .default, handler: { action in
            ImagePickerVC.shared.sourceVC = self
            ImagePickerVC.shared.delegate = self
            ImagePickerVC.shared.proceedWithGallery()

        }))
        
        alert.addAction(UIAlertAction(title: "Document", style: .default, handler: { action in
            if #available(iOS 14.0, *) {
                let types = UTType.types(tag: "pdf", tagClass: UTTagClass.filenameExtension, conformingTo: nil)
                let documentPickerController  = UIDocumentPickerViewController(forOpeningContentTypes: types)
                documentPickerController.delegate = self
                self.present(documentPickerController, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
            }        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
        if enterMessageTextView.text == "" || enterMessageTextView.text == placeHolderText
        {
            self.enterMessageTextView.resignFirstResponder()
            return
        }
        
        self.sendbutton.isHidden = true
        self.sendIndicator.startAnimating()
        TwillioChatDataModel.shared.sendMessage(enterMessageTextView.text!) { result, message in
            
            self.sendbutton.isHidden = false
            self.sendIndicator.stopAnimating()
            
            if result != nil {
                
                if result!.isSuccessful() {
                    
                    self.enterMessageTextView.text = ""
                    self.enterMessageTextView.resignFirstResponder()
                    self.constHeightMessagesTextView.constant = 34.0
                    self.view.layoutIfNeeded()
                }
            } else {
                
                self.enterMessageTextView.resignFirstResponder()
                self.showToast(message: "Unable to send message")
            }
        }
    }
    
//    override func imageSelectedFromGalleryOrCamera(selectedImage: UIImage) {
//        TwillioChatDataModel.shared.sendImage(image: image, url: url)
//    }
    
    func tableViewsIntegrations()
    {
        tableViewMessages.register(UINib(nibName: "MessagesTableViewCell", bundle: nil), forCellReuseIdentifier: "MessagesTableViewCell")
        tableViewMessages.rowHeight = UITableView.automaticDimension
        tableViewMessages.estimatedRowHeight = UITableView.automaticDimension
        tableViewMessages.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableViewMessages.keyboardDismissMode = .interactive
        self.constHeightMessagesTextView.constant = 34
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
    
        if endFrameY >= UIScreen.main.bounds.size.height {
            self.bottomConstOfView?.constant = 0.0
        } else {
            self.bottomConstOfView?.constant = endFrame?.size.height ?? 0.0
        }
        
        UIView.animate(
            withDuration: duration,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { self.view.layoutIfNeeded() },
            completion: nil)
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
        if !TwillioChatDataModel.shared.messages.isEmpty {
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
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        let arrayIndex  = TwillioChatDataModel.shared.messages.count - indexPath.row
        let message = TwillioChatDataModel.shared.messages[arrayIndex - 1]
        if message.hasMedia() {
            message.getMediaContentTemporaryUrl { result, url in
                
                guard let url = url else { return }
                if let mediaType = message.mediaType {
                    if (mediaType.contains("image")){
                        self.showImagePreview(fileString: url)
                    } else if (mediaType.contains("pdf")) {
                        self.pdfPreview(urlString: url)
                    }
                }
            }
        }
    }
}

extension ChatMessagesViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myUrl = urls.first else {
            return
        }
        
        TwillioChatDataModel.shared.sendFile(url: myUrl)
    }
}

extension ChatMessagesViewController: UIImagePickerDelegate {
    func imagePicker(_ controller: UIViewController, image: UIImage, didPickImageAt fileName: String) {
        TwillioChatDataModel.shared.sendImage(image: image, fileName: fileName)
    }
        
}
