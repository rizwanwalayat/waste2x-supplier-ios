//
//  ContactViewController.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 27/05/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit

class ContactViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        globalObjectContainer?.tabbarHiddenView.isHidden = false
        
    }
    
    
}

extension ContactViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.register(ContactTableViewCell.self, indexPath: indexPath)
        cell.config(index: indexPath.row)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row == 0
        {
            let vc = ChatMessagesViewController(nibName: "ChatMessagesViewController", bundle: nil)
            globalObjectContainer?.tabbarHiddenView.isHidden = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 1{
            
            //+1 (984) 368 - 4092
            if let url = URL(string: "tel://+19843684092"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    
}

