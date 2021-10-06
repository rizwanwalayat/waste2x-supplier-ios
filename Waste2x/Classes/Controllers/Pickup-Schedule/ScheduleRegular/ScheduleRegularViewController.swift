//
//  ScheduleRegularViewController.swift
//  Waste2x
//
//  Created by MAC on 06/10/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class ScheduleRegularViewController: BaseViewController {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var availableDaysView: UIView!
    @IBOutlet weak var collectionViewAvailableDays: UICollectionView!
    @IBOutlet weak var availableTimeHolderView: UIView!
    @IBOutlet weak var availableTImeValueLabel: UILabel!
    @IBOutlet weak var dateHolderView: UIView!
    @IBOutlet weak var dateValueLabel: UILabel!
    @IBOutlet weak var notesHolderView: UIView!
    @IBOutlet weak var notesTextView: UITextView!
    
    
    // MARK: - Outlets
    
    var weekDaysArray = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var selectedWeeksArray = [Int]()
    var placeHolderText = "Type some details about your pickup ... "
    
    // MARK: - Controller's Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        notesTextView.text = placeHolderText
        notesTextView.textColor = UIColor.lightGray
        
    }

    
    private func initialUiHandlings()
    {
        collectionViewAvailableDays.register(UINib(nibName: "DaysNameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DaysNameCollectionViewCell")
    }

    
    func showPopupViewHandlings()
    {
        let regularData = ["Morning", "Evening"]
        
        let optionsCustompopup               = ScheduleOptionsViewController(nibName: "ScheduleOptionsViewController", bundle: nil)
        optionsCustompopup.modalPresentationStyle = .overFullScreen
        optionsCustompopup.delegate = self
        optionsCustompopup.optionsData = regularData
        optionsCustompopup.alreadySelectedString = availableTImeValueLabel.text ?? ""
        self.present(optionsCustompopup, animated: false, completion: nil)
    }
    
    func showCalenderView()
    {
        let calenderVC               = CalenderPopupViewController(nibName: "CalenderPopupViewController", bundle: nil)
        calenderVC.modalPresentationStyle = .overFullScreen
        calenderVC.delegate = self
        calenderVC.alreadySelectedDateTime = dateValueLabel.text ?? ""
        self.present(calenderVC, animated: false, completion: nil)
    }
    
    // MARK: - Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func availableTimeButtonPressed(_ sender: Any) {
        
        showPopupViewHandlings()
    }
    
    @IBAction func selectDateButtonPressed(_ sender: Any) {
        
        showCalenderView()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
    }
}

extension ScheduleRegularViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        weekDaysArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DaysNameCollectionViewCell", for: indexPath) as! DaysNameCollectionViewCell
        
        cell.daysValueLabel.text = weekDaysArray[indexPath.item]
        
        if selectedWeeksArray.contains(indexPath.item)
        {
            cell.selectedItems()
        }
        else
        {
            cell.unSelectedItems()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectedWeeksArray.contains(indexPath.item){
            
            if let index = selectedWeeksArray.firstIndex(of: indexPath.item) {
                selectedWeeksArray.remove(at: index)
            }
        }
        else
        {
            selectedWeeksArray.append(indexPath.item)
        }
        
        collectionViewAvailableDays.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionViewAvailableDays.bounds.width / 2) - 9 // 9 is difference between cells
        return CGSize(width: width, height: 40)
    }
    
    
}


extension ScheduleRegularViewController: ScheduleOptionsViewControllerDelegate
{
    func didSelectOption(_ selectedOption: String) {
        
        availableTImeValueLabel.text = selectedOption
    }
    
    func didDismiss() {
        
    }
    
    
}

extension ScheduleRegularViewController: CalenderPopupViewControllerDelegate
{
    func didSelectDate(dateString: String) {
        
        dateValueLabel.text = dateString
    }
    
}

extension ScheduleRegularViewController: UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor(hexString: "2A2A2A")
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolderText
            textView.textColor = UIColor.lightGray
        }
    }
}
