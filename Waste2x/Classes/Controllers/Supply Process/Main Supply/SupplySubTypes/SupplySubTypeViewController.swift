//
//  SupplySubTypeViewController.swift
//  Waste2x
//
//  Created by MAC on 09/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit

class SupplySubTypeViewController: BaseViewController {

    // MARK: - Outlet
    
    @IBOutlet weak var mainHolderView: UIView!
    @IBOutlet weak var constHeightMainHolderview: NSLayoutConstraint!
    @IBOutlet weak var constTopMainHolderview: NSLayoutConstraint!
    @IBOutlet weak var dataContentView: UIView!
    @IBOutlet weak var typeOfWasteLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constHeightTableview: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    
    
    // MARK: - Declarations
    
    var heightOfHiddenView : CGFloat = 0.0
    var tabaleViewIndex = 0
    var supplyProcessQuestions = [QuestionsSuppyProcess]()
    var panGestureRecognizer : UIPanGestureRecognizer?
    var originalPosition : CGPoint?
    var currentPositionTouched : CGPoint?
    var optionsCount = 0
    var selectionData = [String : Any]()
    var isDismissable = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tableView.reloadData()
        
        optionsCount = supplyProcessQuestions.count
        typeOfWasteLabel.text =  supplyProcessQuestions.first?.title ?? ""
        tabGestureInit()
    }


    override func viewWillDisappear(_ animated: Bool)
    {
        self.tableView.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        mainHolderView.layer.cornerRadius = 36
        mainHolderView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        mainHolderView.layer.masksToBounds = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.heightOfHiddenView = self.dataContentView.bounds.height + 82 // 82 is margin of bottom button
        let estimatedMaxScreenHeight = UIScreen.main.bounds.height - 100 // coz have to give minimum margin from top
        if self.heightOfHiddenView > estimatedMaxScreenHeight {
            self.heightOfHiddenView = estimatedMaxScreenHeight
        }
        self.constHeightMainHolderview.constant = self.heightOfHiddenView
        self.constTopMainHolderview.constant   = -self.heightOfHiddenView
        
        UIView.animate(withDuration: 0.3,
                   delay: 0.1,
                   options: UIView.AnimationOptions.curveEaseInOut,
                   animations: { () -> Void in
                    
                    self.view.layoutIfNeeded()
                    
        }, completion: { (finished) -> Void in
        // ....
        })
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if(keyPath == "contentSize")
        {
            if let tableview = object as? UITableView
            {
                self.view.layoutIfNeeded()
                if tableview == self.tableView
                {
                    if let newvalue = change?[.newKey]{
                        let newsize  = newvalue as! CGSize
                        
                        self.constHeightTableview.constant = newsize.height
                    }
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    func hideView(_ forNavigate : Bool)
    {
        constTopMainHolderview.constant   = 0
        UIView.animate(withDuration: 0.3,
                   delay: 0.1,
                   options: UIView.AnimationOptions.curveEaseInOut,
                   animations: { () -> Void in
                    
                    self.view.alpha = 0
                    self.view.layoutIfNeeded()
                    
        }, completion: { (finished) -> Void in
            
            if forNavigate {
                
                let wasteType = self.selectionData["waste_type"] as? String
                let selectionTitle = self.supplyProcessQuestions.first?.options[self.tabaleViewIndex].title ?? ""
                let tempArrays = ["Hogs", "Cattle"]
                
                // in this condition we are judge if more then 3 question then questions will be related to forms other wise question will be related to tons
                if wasteType == "Livestock Waste" && tempArrays.contains(selectionTitle) {
                    
                    self.moveToAmountController()
                }
                else if self.optionsCount > 3 {
                    
                    // removing first because we have already used this first option, in next screen we will again use first option again
                    
                    var tempArray = self.supplyProcessQuestions
                    tempArray.removeFirst()
                    let vc = FormOfWasteViewController(nibName: "FormOfWasteViewController", bundle: nil)
                    vc.modalPresentationStyle = .overFullScreen
                    vc.supplyProcessQuestions = tempArray
                    vc.selectionData = self.selectionData
                    self.present(vc, animated: true, completion: nil)
                }
                else
                {
                    self.moveToAmountController()
                }
            }
            else
            {
                self.dismiss(animated: false, completion: nil)
            }
        })
    }
    
    func moveToAmountController()
    {
        let vc = AmountWasteViewController(nibName: "AmountWasteViewController", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.supplyProcessQuestions = self.supplyProcessQuestions
        vc.selectionData = self.selectionData
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        let selectedOption = supplyProcessQuestions.first?.options[tabaleViewIndex].title ?? ""
        
        let selectedOptionArray = [selectedOption]
        selectionData["question_responses"] = selectedOptionArray
        hideView(true)
    }
    
    @IBAction func backgroundButtonPressed(_ sender: Any) {
        
        if isDismissable {
            
            hideView(false)
        }
        else
        {
            Utility.homeViewController()
        }
    }
    
}


extension SupplySubTypeViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supplyProcessQuestions.first?.options.count ?? 0 //supplyProcessQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.register(SupplyDetailTableViewCell.self, indexPath: indexPath)
        
        cell.selectionStyle = .none
        
        if let cellDate = supplyProcessQuestions.first?.options[indexPath.row] {
            
            cell.configForType(cellDate.title ,  cellDate.icon_url)
        }
        
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

// tapGesture Handligs
extension SupplySubTypeViewController
{
    
    func tabGestureInit()
    {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        mainHolderView.addGestureRecognizer(panGestureRecognizer!)
        mainHolderView.isUserInteractionEnabled = true
    }
    
    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: view)
        
        if panGesture.state == .began {
            originalPosition = view.center
            currentPositionTouched = panGesture.location(in: view)
        } else if panGesture.state == .changed {
            let velocity = panGesture.velocity(in: view)
            if velocity.y <= 0
            {
                self.view.center = self.originalPosition!
            }
            else
            {
                view.frame.origin = CGPoint(
                    x: originalPosition!.x - self.view.frame.width / 2,  //translation.x,
                    y: translation.y
                )
            }
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: view)
            
            if velocity.y >= 1000 {
                UIView.animate(withDuration: 0.2
                    , animations: {
                        self.view.frame.origin = CGPoint(
                            x: self.view.frame.origin.x,
                            y: self.view.frame.size.height
                        )
                }, completion: { (isCompleted) in
                    if isCompleted {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
            else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.center = self.originalPosition!
                })
            }
        }
    }
}
