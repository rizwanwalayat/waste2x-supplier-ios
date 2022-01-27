//
//  InovicesTableViewCell.swift
//  EnMass App
//
//  Created by Phaedra Solutions  on 29/07/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class InvoicesTableViewCell: UITableViewCell {

    @IBOutlet weak var bottomBorder: UIView!
    @IBOutlet weak var dispatchButton: UIButton!
    @IBOutlet weak var deliveryDateLabel: UILabel!
    @IBOutlet weak var commodityLabel: UILabel!
    @IBOutlet weak var pickUpLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var dispatchIDLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var expandView: UIStackView!
    @IBOutlet weak var expandArrow: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        expandView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func expand(_ flag: Bool)
    {
        self.expandView.isHidden = !flag
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                        self.layoutIfNeeded()}, completion: { finished in
                            if self.expandArrow.image == UIImage(named: "Arrow Up")
                            {
                                self.expandArrow.image = UIImage(named: "Arrow Down")
                            }
                            else
                            {
                                self.expandArrow.image = UIImage(named: "Arrow Up")
                            }
                        })
    }
    
    
    
    func configCell(data: InvoicesResultItem, status: DispatchesStatus) {
        // ExpandView Collapsed Initially with Arrow Down
        self.expandView.isHidden = true
        self.expandArrow.image = UIImage(named: "Arrow Down")
        
        // Populating Data
        commodityLabel.text = data.commodity
        deliveryLabel.text = data.drop_off
        dispatchIDLabel.text = "\(data.id)"
        weightLabel.text = data.weight
        
        var statusColor: UIColor
        
        switch status {
        case .paid:
            statusColor = UIColor(named: "redScheduled") ??  UIColor.red
          
        case .in_transit:
            statusColor = UIColor(named: "yellowTransit") ??  UIColor.yellow
            
        case .delivered:
            statusColor = UIColor(named: "greenDelivered") ??  UIColor.green
            
            
        }
        bottomBorder.backgroundColor = statusColor
        
        if data.pick_up.isEmpty {
            pickUpLabel.text = "--"
            deliveryDateLabel.text = "--"
            dispatchButton.isEnabled = false
            dispatchButton.backgroundColor = UIColor(named: "innerBorderColor") ?? UIColor.lightGray
            dispatchButton.setTitleColor(UIColor(named: "tabUnselectedGrey") ?? UIColor.gray, for: .disabled)
        } else {
            pickUpLabel.text = data.pick_up
            deliveryDateLabel.text = data.deliveryDate
            dispatchButton.isEnabled = true
            dispatchButton.backgroundColor = statusColor
            dispatchButton.titleLabel?.textColor = UIColor.white
        }
    }
}
