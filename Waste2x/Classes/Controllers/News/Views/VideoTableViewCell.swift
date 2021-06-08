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
import youtube_ios_player_helper

class VideoTableViewCell: UITableViewCell {
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var playerView: YTPlayerView!
    var player: AVPlayer!
    var playerViewController: AVPlayerViewController!
    override func awakeFromNib() {
        super.awakeFromNib()
        let videoId = "so2lvlJ1Goc"
        playerView.load(withVideoId: videoId);
        playerView.playVideo()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
