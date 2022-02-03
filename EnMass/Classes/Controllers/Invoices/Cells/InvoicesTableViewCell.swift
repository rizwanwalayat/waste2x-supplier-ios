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
    @IBOutlet weak var paidStatusImage: UIImageView!
    @IBOutlet weak var paidStatusView: UIView!
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
    
    
    
    func configCell(data: InvoicesResult) {
        
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
        
        
        paidStatusText.text = data.status
        
        guard let status = PaidStatus(rawValue: data.status) else { return }
        switch status {
        case .paid:
            paidStatusText.textColor = UIColor.badgeGreen
            paidStatusImage.image = UIImage(named: "accept-icon")
            paidStatusView.backgroundColor = UIColor.badgeGreenBg
            
        case .unpaid:
            paidStatusText.textColor = UIColor.badgeYellow
            paidStatusImage.image = UIImage(named: "Pending-Icon")
            paidStatusView.backgroundColor = UIColor.badgeGreenBg
            
        }
    }
}
