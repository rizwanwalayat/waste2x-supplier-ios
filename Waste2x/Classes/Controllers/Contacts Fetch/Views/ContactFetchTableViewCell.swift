//
//  ContactFetchTableViewCell.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 08/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit
import Contacts

class ContactFetchTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func inviteAction(_ sender: Any) {
        
    }
    func config(index:Int,data:[ContactFetchModelResult],contacts:[CNContact]){
        print(data.count)
        if data.count > 0 {
            for i in data {
                
                for contact in contacts {
                    if i.contactName == contact.givenName{
                        self.inviteButton.makeEnable(value: false)
                        
                    }
                    else{
                        self.inviteButton.makeEnable(value: true)
                    }
                }
            }
        }
//        for _ in contacts {
//            if inviteButton.tag == 0 {
//                self.inviteButton.setTitle("Invite", for: .normal)
//                self.inviteButton.isEnabled = true
//                self.inviteButton.backgroundColor = UIColor(named: "lineColor")
//
//            }
//            else{
//                self.inviteButton.setTitle("Invited", for: .normal)
//                self.inviteButton.isEnabled = false
//                self.inviteButton.backgroundColor = .lightGray
//            }
//        }
    }
    
}
