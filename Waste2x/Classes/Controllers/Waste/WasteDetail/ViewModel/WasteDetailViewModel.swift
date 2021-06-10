//
//  WasteDetailViewModel.swift
//  Waste2x
//
//  Created by MAC on 25/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation
import UIKit

extension WasteDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WasteImageDetailCollectionViewCell", for: indexPath) as! WasteImageDetailCollectionViewCell
        
        cell.titleImageview.image = imagesArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 120, height: 143)
    }
    
}

extension WasteDetailViewController : NewWasteSizeViewControllerDelegate
{
    func detailSizeUpdated(_ updatedSize: String) {
        self.sizeDetailLabel.text = updatedSize
    }
    
    
}

extension WasteDetailViewController : WasteDetailLocationViewControllerDelegate {
    func selectedLocationDetail(address: String) {
        
        addressLabel.text = address
    }
    
    
}
