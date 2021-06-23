//
//  WeatherCollectionViewCell.swift
//  Waste2x
//
//  Created by HaiD3R AwaN on 26/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tempratureLabel: UILabel!
    @IBOutlet weak var cloudImgView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    func config(index:Int)
    {
        

        if Global.shared.jump < 40 && (DataManager.shared.getWeather()?.list.count ?? 0) > Global.shared.jump {
            self.dayLabel.text = dateCalculate(date: DataManager.shared.getWeather()?.list[Global.shared.jump].dtTxt ?? "")
            let weatherTemp = DataManager.shared.getWeather()?.list[Global.shared.jump].main?.temp ?? 00
            self.tempratureLabel.text = "\(weatherTemp.shortValue)°" + ""
            Global.shared.jump = Global.shared.jump+8
        }
        
        
            
    }
    func dateCalculate(date:String) -> String{
        var DateForConvert = date
        //APi date
        if let dotRange = date.range(of: " ") {
            DateForConvert.removeSubrange(dotRange.lowerBound..<DateForConvert.endIndex)
        }
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM d, yyyy"
        
        if let date: NSDate = dateFormatterGet.date(from: DateForConvert) as NSDate?{
            return dateFormatterPrint.string(from: date  as Date)
        }
        else {
            return ""
        }
        
}
    
    

}
