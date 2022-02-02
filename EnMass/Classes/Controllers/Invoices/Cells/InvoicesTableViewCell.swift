//
//  InovicesTableViewCell.swift
//  EnMass App
//
//  Created by Phaedra Solutions  on 29/07/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class InvoicesTableViewCell: UITableViewCell {

    @IBOutlet weak var invoiceID: UILabel!
    @IBOutlet weak var invoiceTotal: UILabel!
    @IBOutlet weak var paidStatusText: UILabel!
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
    
    
    
    func configCell(data: InvoicesResult, status: DispatchesStatus) {
        
        // ExpandView Collapsed Initially with Arrow Down
        self.expandView.isHidden = true
        self.expandArrow.image = UIImage(named: "Arrow Down")
        
        // Populating Data
        invoiceID.text = "\(data.id)"
        invoiceTotal.text = "$\(data.total)"
        
        for shipment in data.shipments {
            
            let shipmentStackView = InvoicesShipmentView()
            shipmentStackView.config(shipment: shipment)
            expandView.addArrangedSubview(shipmentStackView)
        }
        

        
        var statusColor: UIColor
        
        switch status {
        case .paid:
            statusColor = UIColor(named: "redScheduled") ??  UIColor.red
          
        case .in_transit:
            statusColor = UIColor(named: "yellowTransit") ??  UIColor.yellow
            
        case .delivered:
            statusColor = UIColor(named: "greenDelivered") ??  UIColor.green
            
            
        }
//
//        if data.pick_up.isEmpty {
//            pickUpLabel.text = "--"
//            deliveryDateLabel.text = "--"
//            dispatchButton.isEnabled = false
//            dispatchButton.backgroundColor = UIColor(named: "innerBorderColor") ?? UIColor.lightGray
//            dispatchButton.setTitleColor(UIColor(named: "tabUnselectedGrey") ?? UIColor.gray, for: .disabled)
//        } else {
//            pickUpLabel.text = data.pick_up
//            deliveryDateLabel.text = data.deliveryDate
//            dispatchButton.isEnabled = true
//            dispatchButton.backgroundColor = statusColor
//            dispatchButton.titleLabel?.textColor = UIColor.white
//        }
    }
}
