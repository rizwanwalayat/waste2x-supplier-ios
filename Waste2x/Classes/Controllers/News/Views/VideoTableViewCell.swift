//
//  VideoTableViewCell.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 01/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoTableViewCell: BaseTableViewCell {
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var playerView: UIView!
    var player: AVPlayer!
    var playerViewController: AVPlayerViewController!
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func config(data:NewsModel,index:Int){
        self.titleLabel.text = data.result[index].title
        self.descriptionLabel.text = self.dateCalculate(date: data.result[index].date_published)
        print(data.result[index].fileUrl)
//        self.playerView.load(withVideoId: data.result[index].fileUrl);
    }
    
    
}
