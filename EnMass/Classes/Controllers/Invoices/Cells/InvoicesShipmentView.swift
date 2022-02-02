//
//  InvoicesShipmentView.swift
//  EnMass
//
//  Created by Phaedra Solutions  on 01/02/2022.
//  Copyright © 2022 codesrbit. All rights reserved.
//

import UIKit

class InvoicesShipmentView: UIStackView {

    @IBOutlet weak var shipmentDate: UILabel!
    @IBOutlet weak var shipmentSubtotal: UILabel!
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
    
    func config(shipment: InvoicesShipment) {
        self.shipmentDate.text = shipment.date
        self.shipmentSubtotal.text = "$\(shipment.subtotal)"
    }

}
