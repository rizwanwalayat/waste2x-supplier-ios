//
//  AudioTableViewCell.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 01/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
import AVFoundation
class AudioTableViewCell: UITableViewCell {


    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressbar: UISlider!
    
    var currentIndex = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.progressValueChange(notification:)),
            name: Notification.Name("progressbarValue"),
            object: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func config(data:NewsModel,index:Int){
        self.titleLabel.text = data.result[index].title
    }
    @IBAction func playPauseAction(_ sender: Any) {

        
    }
    
    @objc private func progressValueChange(notification: NSNotification){
        
        if let object = notification.userInfo as? [String : Any] {
            
            guard let index = object["index"] as? Int else { return }
            guard let pValue = object["pValue"] as? Float else { return }
            guard let mValue = object["mValue"] as? Float else { return }
            if progressbar.isUserInteractionEnabled {
                
                progressbar.maximumValue = mValue
                progressbar.value = pValue
            }
//            if currentIndex == index
//            {
//                progressbar.maximumValue = mValue
//                progressbar.value = pValue
//            }
//            else
//            {
//                progressbar.value = 0.0
//            }
        }
    }
    
    
}
