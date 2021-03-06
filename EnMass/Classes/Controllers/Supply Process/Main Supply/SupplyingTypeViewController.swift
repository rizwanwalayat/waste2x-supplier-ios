//
//  SupplyingTypeViewController.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 07/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit

class SupplyingTypeViewController: BaseViewController {

    
    //MARK: - Variables
    var collectionViewIndex = 0
    var supplyProcessData =  [SupplyProcessResponse]()
    var selectionData = [String : Any]()
    
    //MARK: - Outlets
    
    @IBOutlet weak var nextButtonBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var constCollectionViewHeigh: NSLayoutConstraint!
    @IBOutlet weak var mainViewwithNavBar: UIView!
    @IBOutlet weak var blindersView: UIView!

    static var selectedImageIcon = ""
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDataFromServer()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        collectionViewReload()
        globalObjectContainer?.tabbarHiddenView.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    func collectionViewReload()
    {
        collectionView.reloadData()
        DispatchQueue.main.async {
            self.constCollectionViewHeigh.constant = self.collectionView.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - IBOutlets
    
    @IBAction func nextAction(_ sender: Any) {
        
        if supplyProcessData.count > 0 {
            SupplyingTypeViewController.selectedImageIcon = supplyProcessData[collectionViewIndex].icon_url
            selectionData["waste_type"] = supplyProcessData[collectionViewIndex].title
            pushToNextController(true, questions: supplyProcessData[collectionViewIndex].questions)
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        Utility.CurrentSitesViewController()
        
    }
    
    func pushToNextController(_ isdismissable : Bool, questions: [QuestionsSuppyProcess])
    {
        let vc = SupplySubTypeViewController(nibName: "SupplySubTypeViewController", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.supplyProcessQuestions = questions
        vc.selectionData = selectionData
        vc.isDismissable = isdismissable
        vc.transitioningDelegate = self
        self.present(vc, animated: false, completion: nil)
    }
    
}

//MARK: - CollectionView extention
extension SupplyingTypeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return supplyProcessData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.register(SupplyingCollectionViewCell.self, indexPath: indexPath)
        
        let cellData = supplyProcessData[indexPath.item]
        
        cell.configForSupplying(cellData.title, cellData.icon_url)
        
        if collectionViewIndex == indexPath.row {
            cell.mainViewSelection.borderColor = UIColor.lineColor
            cell.mainViewSelection.borderWidth = 2
        }
        else {
            cell.mainViewSelection.borderColor = .clear
            cell.mainViewSelection.borderWidth = 0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = (collectionView.frame.width - 65) / 2
        return CGSize(width: size, height: size+10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionViewIndex = indexPath.row
        if let confirmCell = collectionView.cellForItem(at: indexPath) as? SupplyingCollectionViewCell
        {
            confirmCell.selection(index: indexPath.row)
        }
        collectionView.reloadData()
    }
    
}


// MARK: - API Calls Handlings
extension SupplyingTypeViewController {
    
    
    func fetchDataFromServer()
    {
        SupplyProcessDataModel.fetchSupplyProcess { response, error, statusCode,message in
            
            if error != nil
            {
                Utility.showAlertController(self, error!.localizedDescription)
            }
            
            if response != nil {
                
                if statusCode == true {
                    
                    self.supplyProcessData = response!.result
                    self.collectionViewReload()
                    
                    if self.supplyProcessData.count == 0
                    {
                        Utility.showAlertController(self, "Token Failed, Data not loaded")
                        DispatchQueue.main.async {
                            Utility.CurrentSitesViewController()
                        }
                    }
                    
                    let wasteType = DataManager.shared.getWasteType().trimmingCharacters(in: .whitespaces)
                    if Global.shared.apiCurve && self.supplyProcessData.count > 0 && wasteType.count > 0{
                        
//                        let wasteString = wasteType.split(separator: "-").first?.trimmingCharacters(in: .whitespaces)
                        
                        for waste in self.supplyProcessData{
                            if waste.title.trimmingCharacters(in: .whitespaces) == wasteType
                            {
                                self.selectionData["waste_type"] = waste.title
                                self.pushToNextController(false, questions: waste.questions)
                                break
                            }
                        }
                    }
                    else
                    {
                        self.blindersView.isHidden = true
                    }
                    
                    
                }
                else
                {
                    Utility.showAlertController(self, "Data not loaded")
                    DispatchQueue.main.async {
                        Utility.CurrentSitesViewController()
                    }
                }
            }
        }
    }
}

extension SupplyingTypeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       
        if Global.shared.apiCurve {
            Utility.CurrentSitesViewController()
        }
        return nil
    }
    
}
