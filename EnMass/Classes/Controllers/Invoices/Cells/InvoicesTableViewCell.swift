//
//  InovicesTableViewCell.swift
//  EnMass App
//
//  Created by Phaedra Solutions  on 29/07/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class InvoicesTableViewCell: UITableViewCell {
    var shipmentsData = [InvoicesShipment]()
    
    @IBOutlet weak var invoiceID: UILabel!
    @IBOutlet weak var invoiceTotal: UILabel!
    @IBOutlet weak var paidStatusText: UILabel!
    @IBOutlet weak var paidStatusImage: UIImageView!
    @IBOutlet weak var paidStatusView: UIView!
    @IBOutlet weak var expandArrow: UIImageView!
    @IBOutlet weak var shipmentsTableView: UITableView!
    @IBOutlet weak var constTableViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shipmentsTableView.isHidden = true
        shipmentsTableView.register(UINib(nibName: "InvoicesShipmentsTableViewCell", bundle: nil), forCellReuseIdentifier: "InvoicesShipmentsTableViewCell")
        shipmentsTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func expand()
    {
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                if self.expandArrow.image == UIImage(named: "Arrow Up")
                {
                    self.shipmentsTableView.isHidden = true
                    self.expandArrow.image = UIImage(named: "Arrow Down")
                }
                else
                {
                    self.shipmentsTableView.isHidden = false
                    self.expandArrow.image = UIImage(named: "Arrow Up")
                }
            }, completion: { finished in
                self.layoutIfNeeded()
            })
    }
    
    
    
    func configCell(data: InvoicesResult) {
        shipmentsData = data.shipments
        shipmentsTableView.dataSource = self
        shipmentsTableView.delegate = self
        // shipmentsTableView Collapsed Initially with Arrow Down
//        self.shipmentsTableView.isHidden = true
        self.expandArrow.image = UIImage(named: "Arrow Down")
        
        // Populating Data
        invoiceID.text = "\(data.id)"
        invoiceTotal.text = Utility.getCurrency(amount: data.total)
        
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
            paidStatusView.backgroundColor = UIColor.badgeYellowBg
            
        }
        
        
        DispatchQueue.main.async {
            self.shipmentsTableView.reloadData()
            self.constTableViewHeight.constant = CGFloat(self.shipmentsData.count * 60)
            self.layoutIfNeeded()
        }
    }
}

extension InvoicesTableViewCell:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shipmentsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = shipmentsTableView.dequeueReusableCell(withIdentifier: "InvoicesShipmentsTableViewCell", for: indexPath) as! InvoicesShipmentsTableViewCell
        cell.config(shipment: shipmentsData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}
