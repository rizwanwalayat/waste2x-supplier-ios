//
//  WeatherCollectionViewCell.swift
//  Waste2x
//
//  Created by HaiD3R AwaN on 26/05/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tempratureLabel: UILabel!
    @IBOutlet weak var cloudImgView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    let date = Date.init()
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    func config(index:Int)
    {
        
        if index == 0{
            if Global.shared.jump < 40 && (DataManager.shared.getWeather()?.list.count ?? 0) > Global.shared.jump {
                self.dayLabel.text = dateCalculate(date: DataManager.shared.getWeather()?.list[Global.shared.jump].dtTxt ?? "")
                
                let weatherTemp = DataManager.shared.getWeather()?.list[Global.shared.jump].main?.temp ?? 00
                let faranhiet = (weatherTemp * 9/5) + 32
                if weatherTemp <= 30{
                    if #available(iOS 13.0, *) {
                        self.cloudImgView.image = UIImage(systemName: "cloud.rain")
                        self.cloudImgView.tintColor = UIColor(named: "themeColor")
                        
                    } else {
                        self.cloudImgView.image = UIImage(named: "Line")
                    }
                }
                else if weatherTemp > 30{
                    self.cloudImgView.image = UIImage(named: "greensunny")
                }
                else{
                    self.cloudImgView.image = UIImage(named: "Line")
                }
                self.tempratureLabel.text = "\(faranhiet.shortValue)°" + ""
                Global.shared.jump = Global.shared.jump+8
            }
        }
        else {
            mainView.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.05)
        if Global.shared.jump < 40 && (DataManager.shared.getWeather()?.list.count ?? 0) > Global.shared.jump {
            self.dayLabel.text = dateCalculate(date: DataManager.shared.getWeather()?.list[Global.shared.jump].dtTxt ?? "")
            let weatherTemp = DataManager.shared.getWeather()?.list[Global.shared.jump].main?.temp ?? 00
            let faranhiet = (weatherTemp * 9/5) + 32
            if weatherTemp <= 30{
                if #available(iOS 13.0, *) {
                    self.cloudImgView.image = UIImage(systemName: "cloud.rain")
                    self.cloudImgView.tintColor = .white
                    
                } else {
                    self.cloudImgView.image = UIImage(named: "whitecloud")
                }
            }
            else if weatherTemp > 30{
                self.cloudImgView.image = UIImage(named: "whitesunny")
            }
            else{
                self.cloudImgView.image = UIImage(named: "whitecloud")
            }
            self.tempratureLabel.text = "\(faranhiet.shortValue)°" + ""
            self.tempratureLabel.textColor = .white
            Global.shared.jump = Global.shared.jump+8
        }
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
