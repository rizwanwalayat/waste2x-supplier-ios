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
    var category = "video"
    var timer : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(slideToNext), userInfo: nil, repeats: true)
    }
    @objc func slideToNext() {
        self.category = "audio"
        tableView.reloadData()
    }



}


//MARK: - Extentions
extension NewsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if category == "video" || category == "audio" || category == "detail" {
            return 3
        }
        else {
            return 1 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if category == cellType.video.rawValue {
            
            let cell = tableView.register(VideoTableViewCell.self, indexPath: indexPath)
            cell.textLabel?.text = "Video"
            return cell
        }
        if category == cellType.audio.rawValue {
            let cell = tableView.register(AudioTableViewCell.self, indexPath: indexPath)
            cell.textLabel?.text = "Audio"
            return cell
        }
        if category == cellType.detail.rawValue {
            let cell = tableView.register(DetailTableViewCell.self, indexPath: indexPath)
            cell.textLabel?.text = "Description"
            return cell
        }
        let cell = tableView.register(DetailTableViewCell.self, indexPath: indexPath)
        cell.textLabel?.text = "Noting Found"
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if category == cellType.video.rawValue{
            return 300
        }
        else if category == cellType.audio.rawValue{
            return 80
        }
        else {
            return 50
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

