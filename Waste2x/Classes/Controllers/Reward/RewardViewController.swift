//
//  RewardViewController.swift
//  Waste2x
//
//  Created by MAC on 07/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class RewardViewController: BaseViewController {

    
    // MARK: - Outlets
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var congratulationLabl: UILabel!
    @IBOutlet weak var rewardImageView: UIImageView!
    @IBOutlet weak var imageHolderView: UIView!
    @IBOutlet weak var rewardTitleLabel: UILabel!
    @IBOutlet weak var rewardDetailLabel: UILabel!
    @IBOutlet weak var okayButton: UIButton!
    
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }


    // MARK: - Actions

    @IBAction func okayButtonPressed(_ sender: Any) {
    }
}
