//
//  DetailPendingCollectionTableViewCell.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 03/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class UnconfirmPendingCollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var hiddenView: UIView!
    @IBOutlet weak var farmLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Functions
    func expandCollapseView(index:Int) {
        self.hiddenView.isHidden = !self.hiddenView.isHidden
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()}, completion: { finished in
                print("Expand \(index)")
        })
    }
    func pendingConfig(data:[PendingCollectionResultResponce],index:Int){
        self.statusLabel.text = data[index].status
        self.statusLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.statusImage.image = UIImage(named: "Pending-Icon")
        self.statusView.backgroundColor = .clear
        self.farmLabel.text = data[index].farm
        if data[index].frequency == "" {
            self.scheduleLabel.text = data[index].schedule_type
        }
        
        else{
            self.scheduleLabel.text = data[index].schedule_type + " (\(data[index].frequency))"
            
        }
        self.dateLabel.text = data[index].scheduleDate
        self.addressLabel.text = data[index].address
        
        
        
        
    }
    func unConfirmedConfig(data:[PendingCollectionResultResponce],index:Int){
        self.statusLabel.text = data[index].status
        self.statusImage.image = UIImage(named: "Pending")
        self.farmLabel.text = data[index].farm
        self.scheduleLabel.text = data[index].schedule_type + " (\(data[index].frequency))"
        if data[index].frequency == "" {
            self.scheduleLabel.text = data[index].schedule_type
        }
        
        else{
            self.scheduleLabel.text = data[index].schedule_type + " (\(data[index].frequency))"
            
        }
        self.dateLabel.text = data[index].scheduleDate
        
    }
    
}
