//
//  FormOfWasteViewController.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 07/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class FormOfWasteViewController: BaseViewController {
    
    
    //MARK: - Variables
    
    var collectionViewIndex = 0
    var collectionViewCount =  4
    var formForLiveStock = false
    
    //MARK: - Outlets
    
    //@IBOutlet weak var hiddenViewHeight: NSLayoutConstraint!
    @IBOutlet weak var nextButtonBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var mainViewWithNav: UIView!
    @IBOutlet weak var constHeightOfCollection : NSLayoutConstraint!
    @IBOutlet weak var collectionView : UICollectionView!
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formForLiveStock ? (collectionViewCount = 3) : (collectionViewCount =  4)
        collectionView.reloadData()
        DispatchQueue.main.async {
            self.constHeightOfCollection.constant = self.collectionView.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        
        if formForLiveStock {
            
            let vc = AmountWasteViewController(nibName: "AmountWasteViewController", bundle: nil)
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
        else
        {
            let vc = FormSubTypesViewController(nibName: "FormSubTypesViewController", bundle: nil)
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    

}

//MARK: - CollectionView extention
extension FormOfWasteViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionViewCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.register(SupplyingCollectionViewCell.self, indexPath: indexPath)
        cell.configForForm(index: indexPath.row, isForLiveStock: formForLiveStock)
        
        if collectionViewIndex == indexPath.row {
            cell.mainViewSelection.borderColor = UIColor(named: "themeColor")
            cell.mainViewSelection.borderWidth = 2
        }
        else {
            cell.mainViewSelection.borderColor = .clear
            cell.mainViewSelection.borderWidth = 0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let size = (collectionView.frame.width - 65) / 2
        return CGSize(width: size, height: size + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.collectionViewIndex = indexPath.row
        collectionView.reloadData()
        if let confirmCell = collectionView.cellForItem(at: indexPath) as? SupplyingCollectionViewCell
        {
            confirmCell.selection(index: indexPath.row)
        }
    }
    
}

