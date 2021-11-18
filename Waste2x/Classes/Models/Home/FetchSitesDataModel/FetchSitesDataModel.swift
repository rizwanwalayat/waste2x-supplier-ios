//
//  FetchSitesDataModel.swift
//  Waste2x
//
//  Created by MAC on 18/11/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation

protocol FetchSitesDataModelDelegate {
    func sitesEmpty()
}
class FetchSitesDataModel : NSObject {
    
    static var shared : FetchSitesDataModel = FetchSitesDataModel()
    private var resultData : HomeResultDataModel?
    private var fetchSitesData = [FetchSitesCustomModel]()
    var delegate : FetchSitesDataModelDelegate?
    
    func reloadData() {
        fetchFarmsFromServer()
    }
    
    func sites() -> [FetchSitesCustomModel]
    {
        return fetchSitesData
    }
    
    fileprivate func fetchFarmsFromServer()
    {
        HomeFetchFarmsDataModel.fetchSites { response, error, statusCode,message in
            
            if error != nil
            {
                print("Error: \(error!.localizedDescription)")
                //Utility.showAlertController(self, error!.localizedDescription)
            }
            
            if response != nil {
                
                if statusCode == true {
                    
                    self.resultData = response!.result
                    self.homeDatapopulate()
                }
                else
                {
                    print("Error: \(message)")
                    //Utility.showAlertController(self, "Data not fetched")
                }
            }
        }
    }
    
    fileprivate func homeDatapopulate()
    {
        
        self.fetchSitesData.removeAll()
        if self.resultData != nil
        {
//            let progress = Float(self.resultData!.percentage) / 100
//            progressBar.setProgress(progress, animated: true)
//            self.welcomeLabel.attributedText =  self.setAttributedTextInLable(boldString: "Hello, ", emailAddress: DataManager.shared.getUserEmail() )
//            self.progressPointsLabel.text = "\(DataManager.shared.getUser()?.result?.percentage.shortValue ?? "")/100"
            
            
            DataManager.shared.setWasteType(value: self.resultData!.waste_type)
            
            // if commodity_farms is empty then will move to create site button
            if self.resultData!.commodity_farms.count == 0 {
                delegate?.sitesEmpty()
                return
            }
            
            for commudity in self.resultData!.commodity_farms
            {
                if commudity.farms != nil
                {
                    for farms in commudity.farms!
                    {
                        var cropTypeName = commudity.crop_type?.components(separatedBy: "-").first ?? ""
                        cropTypeName = cropTypeName.trimmingCharacters(in: .whitespaces)
                        
                        let farmsData = FetchSitesCustomModel(farms.name, farms.id
                                                              , cropTypeName, commudity.crop_type_id ?? 0, commudity.crop_type_image ?? "", commudity.crop_type ?? "")
                        
                        self.fetchSitesData.append(farmsData)
                    }
                }
            }
            
            if self.resultData!.waste_type_questions != nil && self.resultData!.waste_type_questions?.waste_types != nil {
                
                for wasteType in self.resultData!.waste_type_questions!.waste_types!
                {
                    if let cropTypeNameArray = wasteType.title {
                        
                        let cropName = cropTypeNameArray.trimmingCharacters(in: .whitespaces)
                        
                        if let row = self.fetchSitesData.firstIndex(where: {$0.cropType == cropName}) {
                            let objectIndex = self.fetchSitesData[row]
                            objectIndex.sharedIconUrl = wasteType.share_icon_url ?? ""
                        }
                        
                    }
                }
            }
            
//            self.wasteTypeCollectionView.reloadData()
//            self.tableView.reloadData()
//
//            DispatchQueue.main.async {
//                self.tableViewHeight.constant = self.tableView.contentSize.height
//                self.tableView.layoutIfNeeded()
//            }
        }
        else
        {
            print("Error: Invalid token, data not fetched")
            //Utility.showAlertController(self, "Invalid token, data not fetched")
        }
    }
}
