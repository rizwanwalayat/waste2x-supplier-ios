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
    var tableViewCount =  3
    var collectionViewCount =  4
    var tabaleViewIndex = 0
    
    @IBOutlet weak var hiddenViewHeight: NSLayoutConstraint!
    @IBOutlet weak var nextButtonBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var mainViewWithNav: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - Guestures for dismiss
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismiss(_:)))
        mainViewWithNav.addGestureRecognizer(tap)
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        hiddenViewHeight.constant = 0
        globalObjectContainer?.tabbarHiddenView.isHidden = true
//        nextButtonBottomConstraints.constant = tabbarViewHeight+10
        
        
    }
    @IBAction func nextAction(_ sender: Any) {
        handleTap()
    }
    //MARK: - Bottom Sheet Tap
    @objc func handleTap() {
        // handling code
            hiddenViewHeight.constant = ScreenSize.SCREEN_HEIGHT-200
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                
            }
        nextButtonBottomConstraints.constant = 0
        globalObjectContainer?.tabbarHiddenView.isHidden = true
        
    }
    @objc func dismiss(_ sender: UITapGestureRecognizer? = nil) {
        if hiddenViewHeight.constant > 20{
            hiddenViewHeight.constant = 0
            globalObjectContainer?.tabbarHiddenView.isHidden = false
            nextButtonBottomConstraints.constant = tabbarViewHeight+10
            
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
        cell.configForForm(index: indexPath.row)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width-30)/2
        return CGSize(width: size, height: size+10)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionViewIndex = indexPath.row
        collectionView.reloadData()
        if let confirmCell = collectionView.cellForItem(at: indexPath) as? SupplyingCollectionViewCell
        {
            confirmCell.selection(index: indexPath.row)
        }
    }
    
}

//MARK: - TableView

extension FormOfWasteViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.register(SupplyDetailTableViewCell.self, indexPath: indexPath)
        cell.selectionStyle = .none
        cell.configForGrade(index: indexPath.row)
        if tabaleViewIndex == indexPath.row {
            cell.mainView.borderColor = UIColor(named: "themeColor")
            cell.mainView.borderWidth = 2
        }
        else {
            cell.mainView.borderColor = .clear
            cell.mainView.borderWidth = 0
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/4
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let confirmCell = tableView.cellForRow(at: indexPath) as? SupplyDetailTableViewCell
        {
            confirmCell.selection(index: indexPath.row)
        }
        self.tabaleViewIndex = indexPath.row
        tableView.reloadData()
    }
    
}

