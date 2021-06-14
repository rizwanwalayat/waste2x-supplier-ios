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
        }
    func config(data:NewsModel,index:Int){
        loadRadio(radioURL: data.result[index].fileUrl)
        self.titleLabel.text = data.result[index].title
    }
    @IBAction func playPauseAction(_ sender: Any) {
        print(played)
        played = !played
        if played
        {playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            player?.play()
        }
        else
        {
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            player?.pause()
        }
        
        
    }
    
    
    
    
}
