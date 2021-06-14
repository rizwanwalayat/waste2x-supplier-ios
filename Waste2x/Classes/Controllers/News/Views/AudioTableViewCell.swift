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
    
    var player : AVPlayer?
    var played = Bool()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func loadRadio(radioURL: String) {

            guard let url = URL.init(string: radioURL) else { return }
            let playerItem = AVPlayerItem.init(url: url)
            player = AVPlayer.init(playerItem: playerItem)
            player?.play()
        }
    func config(data:NewsModel,index:Int){
        player?.pause()
        loadRadio(radioURL: data.result[index].fileUrl)
    }
    
    
    
    
}
