//
//  ContainerViewController.swift
//  ContainerView
//
//  Created by HaiD3R AwaN on 13/04/2021.
//

import UIKit
var globalObjectContainer : ContainerViewController?

class ContainerViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tabsView: UIView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var messagesButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var faqButton: UIButton!
    @IBOutlet weak var newsButton: UIButton!
    @IBOutlet weak var homeHoverView: UIView!
    @IBOutlet weak var messagesHoverView: UIView!
    @IBOutlet weak var faqHoverView: UIView!
    @IBOutlet weak var newsHoverView: UIView!
    @IBOutlet weak var tabbarHiddenView: UIView!
    
    var nav = BaseNavigationViewController()

    
    //MARK: - Variables
    override func viewDidLoad() {
        super .viewDidLoad()
        globalObjectContainer = self
        messagesHoverView.isHidden = true
        faqHoverView.isHidden = true
        newsHoverView.isHidden = true
        homeButton.isSelected = true
        homeHoverView.isHidden = false
        nav.viewControllers = [HomeNewViewController()]
        activeViewController = self.nav
        self.tabbarHiddenView.isHidden = false
        
    }
    
    
    //MARK: - Actions
    
    @IBAction func didTapHome(_ sender: Any) {
        nav.viewControllers = [HomeNewViewController()]
        activeViewController = self.nav
        messagesHoverView.isHidden = true
        faqHoverView.isHidden = true
        newsHoverView.isHidden = true
        homeHoverView.isHidden = false
        buttonSelect(button: homeButton)
        buttonDeselect(button: messagesButton)
        buttonDeselect(button: addButton)
        buttonDeselect(button: faqButton)
        buttonDeselect(button: newsButton)
    }
    
    @IBAction func didTapMessages(_ sender: Any) {
        nav.viewControllers = [ContactViewController()]
        activeViewController = self.nav
        messagesHoverView.isHidden = false
        faqHoverView.isHidden = true
        newsHoverView.isHidden = true
        homeHoverView.isHidden = true
        buttonSelect(button: messagesButton)
        buttonDeselect(button: homeButton)
        buttonDeselect(button: addButton)
        buttonDeselect(button: faqButton)
        buttonDeselect(button: newsButton)
        
    }
    @IBAction func didTapPlus(_ sender: Any) {
        Global.shared.apiCurve = true
        nav.viewControllers = [HomeNewViewController(), ScheduleViewController()]
        activeViewController = self.nav
        messagesHoverView.isHidden = true
        faqHoverView.isHidden = true
        newsHoverView.isHidden = true
        homeHoverView.isHidden = true
        tabbarHiddenView.isHidden = true
//        buttonSelect(button: addButton)
//        buttonDeselect(button: messagesButton)
//        buttonDeselect(button: homeButton)
//        buttonDeselect(button: faqButton)
//        buttonDeselect(button: newsButton)
    }
    
    @IBAction func didTapFaq(_ sender: Any) {
        messagesHoverView.isHidden = true
        faqHoverView.isHidden = false
        newsHoverView.isHidden = true
        homeHoverView.isHidden = true
        nav.viewControllers = [FaqViewController()]
        activeViewController = self.nav
        buttonSelect(button: faqButton)
        buttonDeselect(button: messagesButton)
        buttonDeselect(button: addButton)
        buttonDeselect(button: homeButton)
        buttonDeselect(button: newsButton)
        
    }
    
    @IBAction func didTapNews(_ sender: Any) {
        nav.viewControllers = [NewsViewController()]
        activeViewController = self.nav
        messagesHoverView.isHidden = true
        faqHoverView.isHidden = true
        newsHoverView.isHidden = false
        homeHoverView.isHidden = true
        buttonSelect(button: addButton)
        buttonDeselect(button: messagesButton)
        buttonDeselect(button: homeButton)
        buttonDeselect(button: faqButton)
        buttonDeselect(button: newsButton)
    }
    
    
    //MARK: - Override Functions
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        tabsView.layer.cornerRadius = 15
        tabsView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        tabsView.layer.masksToBounds = true
        self.navigationController?.navigationBar.isHidden = true
        self.tabbarHiddenView.isHidden = false
        
    }
    
    
    //MARK: - Functions
    func config(){
        
    }
    func buttonSelect(button:UIButton){
        button.isSelected = true
        self.tabbarHiddenView.isHidden = false
//        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
//        button.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
//        button.layer.shadowOpacity = 1.0
//        button.layer.shadowRadius = 1
//        button.layer.borderWidth = 1
//        button.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 0.25)
//        button.layer.masksToBounds = false
//        button.layer.cornerRadius = 4.0
    }
    func buttonDeselect(button:UIButton){
        button.isSelected = false
        self.tabbarHiddenView.isHidden = false
//        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).cgColor
//        button.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        button.layer.shadowOpacity = 0.0
//        button.layer.shadowRadius = 0
//        button.layer.borderWidth = 0
//        button.layer.borderColor = .none
//        button.layer.masksToBounds = true
//        button.layer.cornerRadius = 0.0
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

                activeVC.view.frame = containerView.bounds
                containerView.addSubview(activeVC.view)

                // call before adding child view controller's view as subview
                activeVC.didMove(toParent: self)
            }
        }
    
}
