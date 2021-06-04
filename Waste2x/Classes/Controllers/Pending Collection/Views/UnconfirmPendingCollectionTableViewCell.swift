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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func expandCollapseView(index:Int) {
        self.hiddenView.isHidden = !self.hiddenView.isHidden
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()}, completion: { finished in
                print("Expand \(index)")
        })
    }
    
}
