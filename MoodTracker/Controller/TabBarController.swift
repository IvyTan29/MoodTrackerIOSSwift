//
//  TabBarController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/22/22.
//

import Foundation
import AsyncDisplayKit

class TabBarController : UITabBarController {
    
    let centerButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false
        
        let entriesNav = NavController()
        let addEntryNav = AddEditEntryController(node: AddEditEntryNode())
        let tempNav = NavController()
        
        entriesNav.tabBarItem = UITabBarItem(title: "Entries", image: UIImage(named: "note"), selectedImage: UIImage(named: "note"))
        addEntryNav.tabBarItem = UITabBarItem(title: nil, image: nil, selectedImage: nil)
        tempNav.tabBarItem = UITabBarItem(title: "TEST", image: UIImage(named: "note"), selectedImage: UIImage(named: "note"))
        
        self.setViewControllers([entriesNav, addEntryNav, tempNav], animated: false)
        
        guard let tabBar = self.tabBar as? CustomTabBar else { return }
        
        tabBar.didTapButton = { [unowned self] in
            self.routeToCreateNewAd()
        }
    }
    
    func routeToCreateNewAd() {
        let createAdNavController = self.storyboard?.instantiateViewController(withIdentifier: "NewPostNav") as! UINavigationController
        createAdNavController.modalPresentationCapturesStatusBarAppearance = true
        self.present(createAdNavController, animated: true, completion: nil)
    }
}
    
// MARK: - UITabBarController Delegate
extension TabBarController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        
        // Your middle tab bar item index.
        // In my case it's 1.
        if selectedIndex == 1 {
            return false
        }
        
        return true
    }
}


