//
//  InvoicesShipmentsTableViewCell.swift
//  EnMass
//
//  Created by Phaedra Solutions  on 04/02/2022.
//  Copyright © 2022 codesrbit. All rights reserved.
//

import UIKit

class InvoicesShipmentsTableViewCell: UITableViewCell {

    @IBOutlet weak var shipmentDate: UILabel!
    @IBOutlet weak var shipmentSubtotal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(shipment: InvoicesShipment) {
        self.shipmentDate.text = shipment.date
        self.shipmentSubtotal.text = Utility.getCurrency(amount: shipment.subtotal)
    }
    
}
