//
//  WasteDetailViewModel.swift
//  Waste2x
//
//  Created by MAC on 25/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Collectionview Delegate and Datasource
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


// MARK: - NewWasteSizeViewControllerDelegate
extension WasteDetailViewController : NewWasteSizeViewControllerDelegate
{
    func detailSizeUpdated(_ updatedSize: String) {
        self.sizeDetailLabel.text = updatedSize
    }
    
    
}


// MARK: - WasteDetailLocationViewControllerDelegate
extension WasteDetailViewController : WasteDetailLocationViewControllerDelegate {
    func selectedLocationDetail(address: String) {
        
        addressLabel.text = address
    }
}


// MARK: - API Calling Handlings
extension WasteDetailViewController {
    
    
    func fetchDataFromServer()
    {
        let farmData = ["farm_id" : farmID] as [String : AnyObject]
        
        WasteDataModel.fetchWasteDetail(params: farmData) { response, error, success, message in
            
            
            if error != nil
            {
                Utility.showAlertController(self, error!.localizedDescription)
            }
            
            if response != nil {
                
                if let isSuccess = success {
                    
                    if isSuccess {
                        
                        if let result = response?.result {
                            
                            self.wasteDeatil = result
                            self.dataPopulateInUI()
                        }
                        else
                        {
                            Utility.showAlertController(self, "Faild!, \(message)")
                        }
                    }
                    else
                    {
                        Utility.showAlertController(self, "Faild!, \(message)")
                    }
                    
                }
                else
                {
                    Utility.showAlertController(self, "Faild!, \(message)")
                }
            }
        }
    }
    
    func dataPopulateInUI()
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.blinderView.alpha = 0
        }) { (_) in
            self.blinderView.isHidden = true
        }
        siteTitleLabel.text = wasteDeatil?.farm_name ?? ""
        siteDetailLabel.text = wasteDeatil?.commodity ?? ""
        sizeDetailLabel.text = "\(wasteDeatil?.farm_size ?? 0)"
        addressLabel.text = wasteDeatil?.address ?? ""
        if (wasteDeatil?.commodity_image.count ?? 0) > 1 {
            
            guard let imageUrl = URL(string: wasteDeatil?.commodity_image ?? "") else { print("URL not created for imagesURL String"); return }
            setImage(imageView: wasteTitleImageview, url: imageUrl)
        }
        else
        {
            wasteTitleImageview.image = #imageLiteral(resourceName: "poultry")
        }
    }
    
    
    func imageToUpload()
    {
        let postDict =  postDictToSaveImage as [String : AnyObject]
        WasteDataModel.uploadImage(params: postDict) { data, error, success, message in
            
            if error != nil
            {
                Utility.showAlertController(self, error!.localizedDescription)
            }
            
            if data != nil {
                
                if let isSuccess = success {
                    
                    if isSuccess {
                        
                        let image = self.postDictToSaveImage["farm_image"] as! UIImage
                        self.updateImageLibrary(image)
                    }
                    else
                    {
                        Utility.showAlertController(self, "Faild!, \(message)")
                    }
                    
                }
                else
                {
                    Utility.showAlertController(self, "Faild!, \(message)")
                }
            }
        }
    }
}
