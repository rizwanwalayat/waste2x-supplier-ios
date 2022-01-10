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
    
    
    var mainVC = UIViewController()
    var index = Int()
    var filesString = ""
    var indexMedia = [Int : DownloadedFilesStatus?]()
    var filesStatus = [DownloadedFilesStatus]()
    var indexesInProgress = [Int]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.linkClickableButton.setTitle("", for: .normal)
        self.receiverLinkClickableButton.setTitle("", for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    func messagesHandling(_ cellData : TCHMessage)
    {
        linkClickableButton.isHidden = true
        messageLabel.isHidden = true
        receiverMessageLabel.isHidden = true
        receiverLinkClickableButton.isHidden = true
        
        receiverHolderView.isHidden = true
        mainHolderview.isHidden = true
        messageLabel.text = cellData.body
        timeLabel.text = cellData.timestampAsDate?.dateToString("HH:mm")
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
        
        if cellData.hasMedia() {
            
            let mediaObj = DownloadedFilesStatus(index: index, fileStatus: .inProgress, fileName: "", fileString: "")
            indexMedia[index] = mediaObj
            guard let urlToFile = createProjectDirectoryPath(path: "mediaFiles", fileName: cellData.mediaFilename ?? "") else {
                fatalError("Cannot create directory")
            }
            
            guard let ostream = OutputStream(url: urlToFile, append: false) else {
                fatalError("Cannot open file")
            }
            ostream.open()
            
            cellData.getMediaWith(ostream) {
                
                print("Receing Starts")
                self.indexesInProgress.append(self.index)
                
            } onProgress: { bytes in
                
                print("bytes receiving \(bytes)")
                
            } onCompleted: { text in
                
                print("on completed \(text)")
                
            } completion: { result in
                
                if result.isSuccessful() {
                    
                    self.linkClickableButton.isHidden = false
                    self.receiverLinkClickableButton.isHidden = false
                    
                    let fileName = (urlToFile.absoluteString as NSString).lastPathComponent
                    self.filesString = urlToFile.relativeString
                    self.linkClickableButton.setTitle(fileName, for: .normal)
                    self.receiverLinkClickableButton.setTitle(fileName, for: .normal)
            
                    if let filesObj = self.indexMedia[self.indexesInProgress.first!] as? DownloadedFilesStatus {
                        
                        filesObj.fileName = fileName
                        filesObj.fileStatus = .completed
                        filesObj.fileString = self.filesString
                    }
                    
                    self.indexesInProgress.removeFirst()
                }
                else {
                    print("completetion failed")
                    
                }
            }
        }
        else
        {
            indexMedia[index] = nil
            messageLabel.isHidden = false
            receiverMessageLabel.isHidden = false
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

    
    @IBAction func buttonClicked(sender : UIButton) {
        
        let vcImageShow                         = FullScreenImageViewController(nibName: "FullScreenImageViewController", bundle: nil)
        
        vcImageShow.displayImageString = self.filesString
        mainVC.present(vcImageShow, animated: true, completion: nil)
    }
    
    fileprivate func createProjectDirectoryPath(path:String, fileName : String) -> URL? {
        
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.xyz")
            let logsURL = containerURL!.appendingPathComponent(path)
            do {
                try FileManager.default.createDirectory(at: logsURL, withIntermediateDirectories: true)
            } catch let error as NSError {
                NSLog("Unable to create directory %@", error.debugDescription)
                return nil
            }
            return logsURL
    }
}

enum fileDownloadStatus {
    case draft
    case inProgress
    case completed 
}

class DownloadedFilesStatus : NSObject {
    var fileIndex = 0
    var fileStatus = fileDownloadStatus.draft
    var fileName = ""
    var fileString = ""
    
    override init() {
        super.init()
    }
    
    init (index: Int, fileStatus: fileDownloadStatus, fileName: String,  fileString: String){
        
        self.fileIndex = index
        self.fileStatus = fileStatus
        self.fileName = fileName
        self.fileString = fileString
    }
}
