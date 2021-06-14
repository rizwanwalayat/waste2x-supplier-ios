//
//  NewsViewController.swift
//  ContainerView
//
//  Created by HaiD3R AwaN on 13/04/2021.
//

import UIKit
import AVFoundation
class NewsViewController: BaseViewController {
    
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    
    var NewsListModell : [NewsResult]?
    var NewsModell : NewsModel?
    
    //audio
    var playerItem:AVPlayerItem?
    var player:AVPlayer?
    var slider: UISlider?
    
    //MARK: - enums
    enum cellType {
        case video
        case audio
        case blog
        var rawValue : String
        {
            switch self{
                case .video:
                    return "Video"
                case .audio:
                    return "Audio"
                case .blog:
                    return "Blog"
                    
            }
            
        }
        
    }
    
    
    //MARK: - Variables
    var category = cellType.video.rawValue
    var timer : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newsApiCall()
        startPlayer()
    }
    func startPlayer() {
        let url = URL(string: "https://s3.amazonaws.com/kargopolov/kukushka.mp3")
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.tableView.layer.cornerRadius = 36
        self.tableView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        self.tableView.layer.masksToBounds = true
        globalObjectContainer?.tabbarHiddenView.isHidden = false
        self.bottomConst.constant = self.tabbarViewHeight
        
    }




}


//MARK: - Extentions
extension NewsViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NewsListModell?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if NewsListModell?[indexPath.row].type == cellType.video.rawValue {
            
            let cell = tableView.register(VideoTableViewCell.self, indexPath: indexPath)
            cell.selectionStyle = .none
            cell.config(data: NewsModell!, index: indexPath.row)
            return cell
        }
        else if NewsListModell?[indexPath.row].type == cellType.audio.rawValue {
            let cell = tableView.register(AudioTableViewCell.self, indexPath: indexPath)
            cell.config(data: NewsModell!, index: indexPath.row)
            return cell
        }
        else if NewsListModell?[indexPath.row].type == cellType.blog.rawValue {
            let cell = tableView.register(DetailTableViewCell.self, indexPath: indexPath)
            cell.config(data: NewsModell!, index: indexPath.row)
            cell.selectionStyle = .none
            return cell
        }
        else {
        let cell = tableView.register(DetailTableViewCell.self, indexPath: indexPath)
        cell.selectionStyle = .none
        cell.config(data: NewsModell!, index: indexPath.row)
        cell.textLabel?.text = "Noting Found"
            return cell
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if NewsListModell?[indexPath.row].type == cellType.video.rawValue
        {
            return 300
        }
        else if NewsListModell?[indexPath.row].type == cellType.audio.rawValue
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
        if NewsListModell?[indexPath.row].type == cellType.audio.rawValue{
        if let cell = tableView.cellForRow(at: indexPath) as? AudioTableViewCell
        {
            cell.config(data: NewsModell!, index: indexPath.row)
        }
            
        }
    }
    
    
}


//MARK: - Api Call
extension NewsViewController{
    
    func newsApiCall(){
        NewsModel.NewsApiCall { result, error, status in
            if status == 200{
                GCD.async(.Main) {
                    self.NewsModell = result
                    self.NewsListModell = result?.result
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
}

