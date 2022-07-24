//
//  TabBarController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/22/22.
//

import UIKit

class TabBarController : UITabBarController {
    
    let centerButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false
        tabBar.tintColor = #colorLiteral(red: 0.05700000003, green: 0.09799999744, blue: 0.1070000008, alpha: 1)
        
        delegate = self
        
        let entriesNav = NavController()
        let addEntryNav = AddEditEntryController(node: AddEditEntryNode())
        let tempNav = NavController()
        
        entriesNav.tabBarItem = UITabBarItem(title: "Entries", image: UIImage(named: "note"), selectedImage: UIImage(named: "note"))
        addEntryNav.tabBarItem = UITabBarItem(title: nil, image: nil, selectedImage: nil)
        tempNav.tabBarItem = UITabBarItem(title: "TEST", image: UIImage(named: "note"), selectedImage: UIImage(named: "note"))
        
        self.setViewControllers([entriesNav, addEntryNav, tempNav], animated: false)
        
        print("WENT HERE")
        print(self.tabBar)
        guard let tabBar = self.tabBar as? CustomTabBar else { return }
        print(tabBar)
        print("WENT HERE TOO")
        tabBar.didTapButton = { [unowned self] in
            print("2")
            self.routeToCreateNewAd()
        }
    }
    
    func routeToCreateNewAd() {
        let addEntryNav = AddEditEntryController(node: AddEditEntryNode())
        addEntryNav.modalPresentationCapturesStatusBarAppearance = true
//        self.present(addEntryNav, animated: true, completion: nil)
    }
}
    
// MARK: - UITabBarController Delegate
extension TabBarController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        
        print("selected index: \(selectedIndex)")
        // Your middle tab bar item index.
        // In my case it's 1.
        if selectedIndex == 1 {
            return false
        }
        
        return true
    }
}


