//
//  CreateSitePopupViewController.swift
//  Waste2x
//
//  Created by MAC on 04/11/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class CreateSitePopupViewController: BaseViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var mainHolderview : UIView!
    @IBOutlet weak var popupView : UIView!
    @IBOutlet weak var createNewSiteButton : UIButton!
    
    
    var createSitePressed: (()->())?
    
    // MARK: - Controller's lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.popupView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [],  animations: {
            
          self.popupView.transform = .identity
        })
    }
    
    func hidePopup()
    {
        popupView.alpha = 1
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
            
            self.popupView.alpha = 0
            self.popupView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

        }) { (success) in
            
            self.createSitePressed?()
            self.dismiss(animated: false, completion: nil)
        }
    }

    @IBAction func createSiteButtonPressed(_ sender: UIButton)
    {
        hidePopup()
    }
}
