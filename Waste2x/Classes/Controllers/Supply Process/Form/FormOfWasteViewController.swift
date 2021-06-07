//
//  FormOfWasteViewController.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 07/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class FormOfWasteViewController: BaseViewController {
    var count =  4
    var selectionIndex = 0
    
    @IBOutlet weak var nextButtonBottomConstraints: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        globalObjectContainer?.tabbarHiddenView.isHidden = false
        nextButtonBottomConstraints.constant = tabbarViewHeight+10
        
    }
    @IBAction func nextAction(_ sender: Any) {
        
    }
    

}

//MARK: - Extentions
extension FormOfWasteViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.register(FormOfWasteCollectionViewCell.self, indexPath: indexPath)
        cell.config(index: indexPath.row)
        if selectionIndex == indexPath.row {
            cell.mainView.borderColor = UIColor(named: "themeColor")
            cell.mainView.borderWidth = 2
        }
        else {
            cell.mainView.borderColor = .clear
            cell.mainView.borderWidth = 0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width-30)/2
        return CGSize(width: size, height: size+10)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectionIndex = indexPath.row
        collectionView.reloadData()
        if let confirmCell = collectionView.cellForItem(at: indexPath) as? FormOfWasteCollectionViewCell
        {
            confirmCell.selection(index: indexPath.row)
        }
    }
    
}
