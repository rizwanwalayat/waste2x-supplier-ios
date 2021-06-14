//
//  NewsViewController.swift
//  ContainerView
//
//  Created by HaiD3R AwaN on 13/04/2021.
//

import UIKit

class NewsViewController: BaseViewController {
    
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - enums
    enum cellType {
        case video
        case audio
        case detail
        var rawValue : String
        {
            switch self{
                case .video:
                    return "video"
                case .audio:
                    return "audio"
                case .detail:
                    return "detail"
                    
            }
            
        }
        
    }
    
    
    //MARK: - Variables
    var category = cellType.video.rawValue
    var timer : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(slideToNext), userInfo: nil, repeats: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.tableView.layer.cornerRadius = 36
        self.tableView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        self.tableView.layer.masksToBounds = true
        globalObjectContainer?.tabbarHiddenView.isHidden = false
        
    }
    @objc func slideToNext() {
        self.category = cellType.detail.rawValue
        tableView.reloadData()
    }



}


//MARK: - Extentions
extension NewsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if category == cellType.audio.rawValue || category == cellType.video.rawValue || category == cellType.detail.rawValue {
            return 3
        }
        else {
            return 1
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.register(VideoTableViewCell.self, indexPath: indexPath)
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.register(AudioTableViewCell.self, indexPath: indexPath)
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row == 2 {
            let cell = tableView.register(DetailTableViewCell.self, indexPath: indexPath)
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.register(DetailTableViewCell.self, indexPath: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = "Noting Found"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return 300
        }
        else if indexPath.row == 1
        {
            return 80
        }
        else
        {
            return 125
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}


//MARK: - Api Call
extension NewsViewController{
    
    func newsApiCall(){
        
        
    }
}

