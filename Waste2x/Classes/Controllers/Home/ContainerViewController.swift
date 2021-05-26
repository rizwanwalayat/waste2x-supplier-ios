//
//  ContainerViewController.swift
//  ContainerView
//
//  Created by HaiD3R AwaN on 13/04/2021.
//

import UIKit
class ContainerViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tabsView: UIView!
    @IBOutlet weak var communitiesButton: UIButton!
    @IBOutlet weak var tabbarViewHeight: NSLayoutConstraint!
    @IBOutlet weak var listingsButton: UIButton!
    @IBOutlet weak var newsButton: UIButton!
    @IBOutlet weak var notificationsButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var communitiesLabel: UILabel!
    @IBOutlet weak var listingsLabel: UILabel!
    @IBOutlet weak var newsLabel: UILabel!
    @IBOutlet weak var notificationsLabel: UILabel!
    @IBOutlet weak var moreLabel: UILabel!
    
    //MARK: - Variables
    override func viewDidLoad() {
        super .viewDidLoad()
        activeViewController = CommunitiesViewController()
        
    }
    
    
    //MARK: - Actions
    
    @IBAction func didTapCommunities(_ sender: Any) {
        activeViewController = CommunitiesViewController()

        buttonSelect(button: communitiesButton)
        buttonDeselect(button: listingsButton)
        buttonDeselect(button: newsButton)
        buttonDeselect(button: notificationsButton)
        buttonDeselect(button: moreButton)
    }
    
    @IBAction func didTapListings(_ sender: Any) {
        activeViewController = ListingsViewController()
//        tabbarViewHeight.constant = 0
        buttonSelect(button: listingsButton)
        buttonDeselect(button: communitiesButton)
        buttonDeselect(button: newsButton)
        buttonDeselect(button: notificationsButton)
        buttonDeselect(button: moreButton)
        
    }
    
    @IBAction func didTapNews(_ sender: Any) {
        activeViewController = NewsViewController()
        
        buttonSelect(button: newsButton)
        buttonDeselect(button: listingsButton)
        buttonDeselect(button: communitiesButton)
        buttonDeselect(button: notificationsButton)
        buttonDeselect(button: moreButton)
    }
    
    @IBAction func didNotifications(_ sender: Any) {
        activeViewController = NotificationsViewController()
        buttonSelect(button: notificationsButton)
        buttonDeselect(button: listingsButton)
        buttonDeselect(button: newsButton)
        buttonDeselect(button: communitiesButton)
        buttonDeselect(button: moreButton)
        
    }
    
    @IBAction func didTapMore(_ sender: Any) {
        activeViewController = MoreViewController()
        buttonSelect(button: moreButton)
        buttonDeselect(button: listingsButton)
        buttonDeselect(button: newsButton)
        buttonDeselect(button: notificationsButton)
        buttonDeselect(button: communitiesButton)
    }
    
    
    //MARK: - Override Functions
    override func viewWillAppear(_ animated: Bool) {
        tabsView.layer.cornerRadius = 15
        tabsView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        tabsView.layer.masksToBounds = true
    }
    
    
    //MARK: - Functions
    func config(){
        
    }
    func buttonSelect(button:UIButton){
        button.isSelected = true
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 1
        button.layer.borderWidth = 1
        button.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 0.25)
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 4.0
    }
    func buttonDeselect(button:UIButton){
        button.isSelected = false
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        button.layer.shadowOpacity = 0.0
        button.layer.shadowRadius = 0
        button.layer.borderWidth = 0
        button.layer.borderColor = .none
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 0.0
    }
    
    //MARK: - Private Functions
    private var activeViewController: UIViewController? {
            didSet {
                removeInactiveViewController(inactiveViewController: oldValue)
                updateActiveViewController()
            }
        }

        private func removeInactiveViewController(inactiveViewController: UIViewController?) {
            if let inActiveVC = inactiveViewController {
                // call before removing child view controller's view from hierarchy
                inActiveVC.willMove(toParent: nil)

                inActiveVC.view.removeFromSuperview()

                // call after removing child view controller's view from hierarchy
                inActiveVC.removeFromParent()
            }
        }

        private func updateActiveViewController() {
            if let activeVC = activeViewController {
                // call before adding child view controller's view as subview
                addChild(activeVC)

                activeVC.view.frame = contentView.bounds
                contentView.addSubview(activeVC.view)

                // call before adding child view controller's view as subview
                activeVC.didMove(toParent: self)
            }
        }
    
}
