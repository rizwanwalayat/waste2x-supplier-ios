//
//  SupplyingTypeViewController.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 07/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class SupplyingTypeViewController: BaseViewController {

    //MARK: - Variables
    var count = 7
    
    //MARK: - Outlets
    
    @IBOutlet weak var nextButtonBottomConstraints: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        nextButtonBottomConstraints.constant = tabbarViewHeight+10
        
    }
    
    
    

}

//MARK: - Extentions
extension SupplyingTypeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.register(SupplyingCollectionViewCell.self, indexPath: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(collectionView.frame.height)
        print(collectionView.frame.width)
        print(collectionView.bounds.width)
        print(collectionView.bounds.width)
        return CGSize(width: (collectionView.frame.width/2), height: (collectionView.bounds.height/2))
    }
    
}
