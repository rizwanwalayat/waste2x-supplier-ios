//
//  Coordinator.swift
//  EnMass
//
//  Created by HaiDer's Macbook Pro on 28/12/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation
import UIKit
import SlideMenuControllerSwift

protocol Coordinator {
    
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func homeViewController()
    func loginRootViewController()
    //MARK: - Called Function
    
}


class MainCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.isHidden = true
    }
    
    func homeViewController() {
        let slider = SlideMenuController(mainViewController: ContainerViewController(), leftMenuViewController: SideMenuViewController())
        let navigationController = BaseNavigationViewController()
        navigationController.viewControllers = [slider]
        kApplicationWindow = UIWindow(frame: UIScreen.main.bounds)
        kApplicationWindow?.rootViewController = navigationController
        kApplicationWindow?.makeKeyAndVisible()
    }
    
    func loginRootViewController() {
        let loginViewController = LoginViewController()
        let navigationController = BaseNavigationViewController()
        navigationController.viewControllers = [loginViewController]
        kApplicationWindow = UIWindow(frame: UIScreen.main.bounds)
        kApplicationWindow?.rootViewController = navigationController
        kApplicationWindow?.makeKeyAndVisible()
    }
    
}
