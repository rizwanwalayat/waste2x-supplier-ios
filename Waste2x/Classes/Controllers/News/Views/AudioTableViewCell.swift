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
    
    
    var played = Bool()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    
    
    
    
}
