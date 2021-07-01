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
    var progressbar : UISlider?
    var previousPlayingFileName = ""
    var lastPlayingIndex = -1
    
    //audio
    var audioPlayer : AVAudioPlayer?
    var timer : Timer?
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
    var timerTest : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.tableView.layer.cornerRadius = 36
        self.tableView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        tableView.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        self.tableView.layer.masksToBounds = true
        globalObjectContainer?.tabbarHiddenView.isHidden = false
        self.bottomConst.constant = self.tabbarViewHeight + 10
        if Global.shared.newsApiCheck{
            newsApiCall()
        }
        else{
            self.NewsModell = Global.shared.newsModel
            self.NewsListModell = Global.shared.NewsListModell
            self.tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        audioPlayer?.stop()
    }

    @objc func startPlayPause(_ sender:UIButton)
    {
        NewsModell!.result[sender.tag].isSongPlaying = !NewsModell!.result[sender.tag].isSongPlaying
        let isPlaying = NewsModell!.result[sender.tag].isSongPlaying
        
        let urlString = NewsModell!.result[sender.tag].fileUrl
                
        if lastPlayingIndex != sender.tag && lastPlayingIndex != -1
        {
            NewsModell!.result[lastPlayingIndex].isSongPlaying = false
            NewsModell!.result[lastPlayingIndex].isSongLoading = false
        }
        
        if urlString == previousPlayingFileName{
            
            if isPlaying
            {
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
                
            }
            else
            {
                audioPlayer?.pause()
            }
        }
        else
        {
            guard let url = URL.init(string: urlString) else { return }
            self.downloadFileFromURL(url: url, senderButton: sender)
        }

        tableView.reloadData()
    }
    
    @objc func sliderValueChange(_ sender : UISlider, event: UIEvent)
    {
        if sender.tag == lastPlayingIndex
        {
            audioPlayer?.currentTime = TimeInterval(self.progressbar?.value ?? 0.0)
            startTimer()
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        }
        else
        {
            return
        }
    }
    
    @objc func updateTime(_ timer: Timer) {
        
        // slider current value
        
        //progressbar?.value = Float(audioPlayer?.currentTime ?? 0.0)
        
        let objDict : [String : Any] = ["index" : lastPlayingIndex,
                       "pValue": Float(audioPlayer?.currentTime ?? 0.0),
                       "mValue" : Float(self.audioPlayer?.duration ?? 0.0)]
        NotificationCenter.default.post(name: Notification.Name("progressbarValue"), object: nil, userInfo: objDict as [AnyHashable : Any])
    }
    
    
    func downloadFileFromURL(url:URL, senderButton : UIButton){

        // then lets create your document folder url
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(url.lastPathComponent)
        print(destinationUrl)
        
        
        if url.pathExtension != "mp3"
        {
            if lastPlayingIndex > NewsModell!.result.count {
                
                NewsModell!.result[lastPlayingIndex].isSongPlaying = false
                NewsModell!.result[lastPlayingIndex].isSongLoading = false
            }
            Utility.showAlertController(self, "file is not in correct formet , this file is in \(url.pathExtension) format.")
            return
        }
        
        audioPlayer?.stop()
        audioPlayer = nil
        previousPlayingFileName = url.absoluteString
        lastPlayingIndex = senderButton.tag
        
        NewsModell!.result[senderButton.tag].isSongLoading = true
        
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            print("The file already exists at path")
            
            DispatchQueue.main.async {
                self.NewsModell!.result[senderButton.tag].isSongLoading = false
                self.handlePlayPause(destinationUrl, senderButton: senderButton)
            }
            
        } else {
            
            // you can use NSURLSession.sharedSession to download the data asynchronously
            URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                guard let location = location, error == nil else { return }
                do {
                    // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: location, to: destinationUrl)
                    print("File moved to documents folder")
                    
                    DispatchQueue.main.async {
                        self.NewsModell!.result[senderButton.tag].isSongLoading = false
                        self.handlePlayPause(destinationUrl, senderButton: senderButton)
                    }
                   
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }).resume()
        }
        
            
        

        
//        var downloadTask:URLSessionDownloadTask
//        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { downloadedUrl, response, error in
//
//            DispatchQueue.main.async {
//                self.NewsModell!.result[senderButton.tag].isSongLoading = false
//            }
//
//            if let urlDownloaded = downloadedUrl {
//
//                self.handlePlayPause(urlDownloaded, senderButton: senderButton)
//
//            }
//        })
//        downloadTask.resume()
    }
    
    func handlePlayPause(_ url : URL, senderButton : UIButton)
    {
        do {
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            startTimer()
//            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
            
//            if let cell = self.tableView.cellForRow(at: IndexPath(row: senderButton.tag, section: 0)) as? AudioTableViewCell {
//
//                cell.progressbar.maximumValue = Float(self.audioPlayer?.duration ?? 0.0)
//                cell.progressbar.value = 0.0
//                self.progressbar = cell.progressbar
//                self.progressbar?.tag = senderButton.tag
//                // code for handle slider control
//            }
            
        }
        catch
        {
            print(error)
        }
        
        tableView.reloadData()
    }
    
    func startTimer ()
    {
      timerTest =  Timer.scheduledTimer(
          timeInterval: TimeInterval(1.0),
          target      : self,
          selector    : #selector(self.updateTime(_:)),
          userInfo    : nil,
          repeats     : true)
    }
    
    func stopTimer() {
      timerTest?.invalidate()
      timerTest = nil
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
            cell.selectionStyle = .none
            
            cell.playPauseButton.tag = indexPath.row
            cell.playPauseButton.addTarget(self, action: #selector(startPlayPause(_:)), for: .touchUpInside)
            cell.progressbar.tag = indexPath.row
            cell.progressbar.addTarget(self, action: #selector(sliderValueChange(_:event:)), for: .valueChanged)
            cell.config(data: NewsModell!, index: indexPath.row)
            cell.currentIndex = indexPath.row
            
            
            if self.NewsModell!.result[indexPath.row].isSongPlaying {
                
                cell.playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                cell.progressbar.value = Float(audioPlayer?.currentTime ?? 0.0)
                if self.NewsModell!.result[indexPath.row].isSongLoading {
                    cell.activityIndicator.startAnimating()
                    cell.playPauseButton.isHidden = true
                }
                else {
                    
                    cell.activityIndicator.stopAnimating()
                    cell.playPauseButton.isHidden = false
                }
            }
            else {
                
                cell.playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                cell.progressbar.value = 0.0
                cell.activityIndicator.stopAnimating()
                cell.playPauseButton.isHidden = false
            }
            
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
            return 100
        }
        else
        {
            return 125
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if NewsListModell?[indexPath.row].type == cellType.audio.rawValue{
//        if let cell = tableView.cellForRow(at: indexPath) as? AudioTableViewCell
//        {
////
//        }
            
        }
    }
    
    
}


//MARK: - Api Call
extension NewsViewController{
    
    func newsApiCall(){
        NewsModel.NewsApiCall { result, error, status,message in
            Global.shared.newsApiCheck = false
            if status == true{
                GCD.async(.Main) {
                    self.NewsModell = result
                    self.NewsListModell = result?.result
                    Global.shared.newsModel = result
                    Global.shared.NewsListModell = result?.result
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
}


// MARK: - audio player handling
extension NewsViewController
{
    
    func checkBookFileExists(withLink link: String, completion: @escaping ((_ filePath: URL)->Void))
    {
        let urlString = link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if let url  = URL.init(string: urlString ?? ""){
            
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(url.lastPathComponent)
            
            let filePath = destinationUrl.appendingPathComponent(url.lastPathComponent, isDirectory: false)
            
            do {
                if try filePath.checkResourceIsReachable() {
                    print("file exist")
                    completion(filePath)
                    
                } else {
                    print("file doesnt exist")
                    downloadFile(withUrl: url, andFilePath: filePath, completion: completion)
                }
            } catch {
                print("file doesnt exist")
                downloadFile(withUrl: url, andFilePath: filePath, completion: completion)
            }
           
        }else{
                print("file doesnt exist")
        }
    }
    
    func downloadFile(withUrl url: URL, andFilePath filePath: URL, completion: @escaping ((_ filePath: URL)->Void)){
        
        
        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: filePath.path) {
            print("The file already exists at path")
            
            // if the file doesn't exist
        } else {
            
            var downloadTask:URLSessionDownloadTask
            downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { downloadedUrl, response, error in

                if let urlDownloaded = downloadedUrl {
                    
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: urlDownloaded, to: filePath)
                        print("File moved to documents folder")
                        DispatchQueue.main.async {
                            completion(filePath)
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
            })
            downloadTask.resume()
        }
    }
}


