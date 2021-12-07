//
//  WebViewViewController.swift
//  CarrierApp
//
//  Created by MAC on 27/10/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: BaseViewController {

    
    //MARK: Declarations
    
    
    var webView   : WKWebView!
    var urlString =  ""
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var backShadowView : UIView!
    
    
    //MARK: Controllers LifeCycle
    
    override func loadView()
    {
        setupWebView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigation()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Utility.showLoading()
        if Utility.isConnectedToNetwork() == false {
            DispatchQueue.main.async {
                Utility.hideLoading()
            }
            let alertController = UIAlertController.init(title: NSLocalizedString("ID_ERROR", comment: ""), message: NSLocalizedString("NO_INTERNET_TITLE", comment: " "), preferredStyle: .alert)
            let okAction    = UIAlertAction(title:  NSLocalizedString("ID_OK", comment: ""), style: .default) { (action) in
                print("Ok Pressed")
                self.navigationController?.popViewController(animated: true)
            }
            
            alertController.addAction(okAction)
            present(alertController, animated: false, completion: nil)
            return
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Utility.hideLoading()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    fileprivate func setupWebView()
    {
        Utility.showLoading()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        self.view = webView
        
        loadWebView()
    }
    
    fileprivate func loadWebView()
    {
        let myURL = URL(string:urlString)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    fileprivate func setupNavigation()
    {
        let nav = self.navigationController?.navigationBar
        nav?.isHidden = false
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.delegate = self
        nav?.barTintColor = UIColor.appColor
        nav?.setBackgroundImage(UIImage(named: "NavBar Header"), for: .default)
        self.navigationController?.topViewController?.title = "Create Payment Account"
    }
}

extension WebViewViewController: WKUIDelegate, WKNavigationDelegate, UINavigationControllerDelegate{
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("pageLoadingFinish")
        Utility.hideLoading()
        let vc = HomeNewViewController(nibName: "HomeNewViewController", bundle: nil)
        Utility.setupRoot([vc], navgationController: self.navigationController)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        print("didFailProvisionalNavigation")
        let vc = HomeNewViewController(nibName: "HomeNewViewController", bundle: nil)
        Utility.setupRoot([vc], navgationController: self.navigationController)
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFail")
        let vc = HomeNewViewController(nibName: "HomeNewViewController", bundle: nil)
        Utility.setupRoot([vc], navgationController: self.navigationController)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        DispatchQueue.main.async {
            viewController.navigationItem.backBarButtonItem = item
        }
    }
}
