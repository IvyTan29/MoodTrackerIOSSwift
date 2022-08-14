//
//  TabController.swift
//  AsdkApp
//
//  Created by Mini on 7/27/22.
//

import Foundation
import UIKit

class TabController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        let left = ListController()
//        left.tabBarItem = UITabBarItem(title: left.title, image: UIImage(systemName: "multiply.circle.fill"), tag: 1)
//
//
//        let middle = UIViewController()
//        middle.tabBarItem = UITabBarItem(title: "Add", image: UIImage(named: "plus"), tag: 2)
//        // IMPORTANT
//        middle.tabBarItem.imageInsets = .init(top: -40, left: 0, bottom: 0, right: 0)
//
//
//        let right = SettingController()
//        right.tabBarItem = UITabBarItem(title: right.title, image: UIImage(systemName: "multiply.circle.fill"), tag: 3)
        
        
        
//        self.viewControllers = [left, middle, right]
//        
//        
        self.delegate = self
        
        
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 2 {
            print(">>> middle button pressed")
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 2 {
            return false
        }
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if viewController.tabBarItem.tag == 2 {
            print(">>> middle viewcontroller selected")
        }
    }
}
