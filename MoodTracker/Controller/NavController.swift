//
//  ViewController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/20/22.
//

import Foundation
import AsyncDisplayKit

class NavController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.viewControllers = [NewEntryController(node: NewEntryNode())]
        self.viewControllers = [EntriesController(node: EntriesNode())]
        
        if #available(iOS 15.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            let tabBarItemAppearance = UITabBarItemAppearance()
            
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = UIColor(named: "BlueBase")
            tabBarAppearance.selectionIndicatorTintColor = .white
            
            tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
            tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

            tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
            
            self.tabBarController?.tabBar.standardAppearance = tabBarAppearance
            self.tabBarController?.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
    }
    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        let newNavBarAppearance = customNavBarAppearance()
//            
//        let appearance = UINavigationBar.appearance()
//        appearance.scrollEdgeAppearance = newNavBarAppearance
//        appearance.compactAppearance = newNavBarAppearance
//        appearance.standardAppearance = newNavBarAppearance
//        
//        if #available(iOS 15.0, *) {
//            appearance.compactScrollEdgeAppearance = newNavBarAppearance
//        }
//
//        return true
//    }
    
//    @available(iOS 13.0, *)
//    func customNavBarAppearance() -> UINavigationBarAppearance {
//        let customNavBarAppearance = UINavigationBarAppearance()
//
//        // Apply a red background.
//        customNavBarAppearance.configureWithOpaqueBackground()
//        customNavBarAppearance.backgroundColor = .systemRed
//
//        // Apply white colored normal and large titles.
//        customNavBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        customNavBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//
//        // Apply white color to all the nav bar buttons.
//        let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
//        barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
//        barButtonItemAppearance.disabled.titleTextAttributes = [.foregroundColor: UIColor.lightText]
//        barButtonItemAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.label]
//        barButtonItemAppearance.focused.titleTextAttributes = [.foregroundColor: UIColor.white]
//        customNavBarAppearance.buttonAppearance = barButtonItemAppearance
//        customNavBarAppearance.backButtonAppearance = barButtonItemAppearance
//        customNavBarAppearance.doneButtonAppearance = barButtonItemAppearance
//
//        return customNavBarAppearance
//    }
}

