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
    
    //MARK: - Outlets
    
    //@IBOutlet weak var hiddenViewHeight: NSLayoutConstraint!
    @IBOutlet weak var nextButtonBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var mainViewWithNav: UIView!
    @IBOutlet weak var constHeightOfCollection : NSLayoutConstraint!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    //MARK: - Declarations
    
    var supplyProcessQuestions = [QuestionsSuppyProcess]()
    var selectionData = [String: Any]()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Global.shared.apiCurve ? (cancelButton.isHidden = false) : (cancelButton.isHidden = true)
        collectionView.reloadData()
        DispatchQueue.main.async {
            self.constHeightOfCollection.constant = self.collectionView.contentSize.height
            self.view.layoutIfNeeded()
        }
        
        questionLabel.text = supplyProcessQuestions.first?.title
    }
    
    @IBAction func nextAction(_ sender: Any) {
        
        var questionsArray = selectionData["question_responses"] as! [String]
        let selectedOption = supplyProcessQuestions.first?.options[collectionViewIndex].title ?? ""
        
        for question in questionsArray
        {
            if supplyProcessQuestions.first!.options.contains(where: { $0.title == question })
            {
                questionsArray.removeAll { $0 == question }
            }
        }
        
        questionsArray.append(selectedOption)
        selectionData["question_responses"] = questionsArray
        
        // removing first because we have already used this first option, in next screen we will again use first option again
        var tempArray = self.supplyProcessQuestions
        tempArray.removeFirst()
        
        let vc = FormSubTypesViewController(nibName: "FormSubTypesViewController", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.supplyProcessQuestions = tempArray
        vc.selectionData = selectionData
        self.present(vc, animated: false, completion: nil)
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        Utility.homeViewController()
    }
    

}

//MARK: - CollectionView extention
extension FormOfWasteViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return supplyProcessQuestions.first?.options.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.register(SupplyingCollectionViewCell.self, indexPath: indexPath)
        
        let cellData = supplyProcessQuestions.first?.options[indexPath.item]
        
        cell.configForForm(cellData?.title ?? "", cellData?.icon_url ?? "")
        
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

