//
//  TabBarController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/22/22.
//

import UIKit
import RxCocoa
import RxSwift
import AsyncDisplayKit

class TabBarController : UITabBarController {
    
    // reference for middle button: https://betterprogramming.pub/how-to-create-a-nice-uitabbar-for-your-ios-app-using-swift-5-pt-2-9285466846c8
    var layerHeight = CGFloat()
    var middleButton: UIButton = {
        let b = UIButton()
        let c = UIImage.SymbolConfiguration(pointSize: 15, weight: .heavy, scale: .large)
        
        b.setImage(UIImage(systemName: "plus", withConfiguration: c), for: .normal)
        b.imageView?.tintColor = UIColor(named: "BlueBase")
        b.backgroundColor = UIColor.systemBackground
        b.layer.borderColor = UIColor(named: "BlueBase")?.cgColor
        b.layer.borderWidth = 3
        
        return b
    }()
    
    var entriesNav = NavController()
    var insightsNav = NavController()
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SET CUSTOM TAB BAR TO TAB BAR VIEW CONTROLLER PROGRAMMATICALLY
        self.setValue(CustomTabBar(), forKey: "tabBar")
        
        let addEntryNav = NavController() // no use because it will be disabled
        
        self.entriesNav.isListEntires = true
        self.insightsNav.isListEntires = false
        
        self.entriesNav.tabBarItem = UITabBarItem(title: "Entries", image: UIImage(systemName: "list.bullet.rectangle.portrait"), selectedImage: UIImage(systemName: "list.bullet.rectangle.portrait.fill"))
        
        addEntryNav.tabBarItem = UITabBarItem(title: "Add", image: nil, selectedImage: nil)
        self.insightsNav.tabBarItem = UITabBarItem(title: "Insights", image: UIImage(systemName: "lightbulb"), selectedImage: UIImage(systemName: "lightbulb.fill"))
        
        self.setViewControllers([self.entriesNav, addEntryNav, self.insightsNav], animated: false)
        
        addMiddleButton()
        styleTab()
    }
    
    func styleTab() {
        let tabBarAppearance = UITabBarAppearance()
        let tabBarItemAppearance = UITabBarItemAppearance()
        
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(named: "BlueBase")
        
        // color for title in tab bar items
        tabBarItemAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Avenir", size: 15)!,
            NSAttributedString.Key.foregroundColor: UIColor.systemGray5
        ]
        tabBarItemAppearance.selected.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Avenir", size: 15)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        // color for the image icon
        tabBarItemAppearance.normal.iconColor = UIColor.systemGray4
        tabBarItemAppearance.selected.iconColor = UIColor.white
        
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        
        self.tabBar.standardAppearance = tabBarAppearance
        
        if #available(iOS 15.0, *) {
            self.tabBar.scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    func addMiddleButton() {
        // DISABLE TABBAR ITEM - behind the "+" custom button:
        DispatchQueue.main.async {
            if let items = self.tabBar.items {
                items[1].isEnabled = false
            }
        }
        
        // shape, position and size
        tabBar.addSubview(middleButton)
        let size = CGFloat(70)
        
        // set constraints
        let constraints = [
            middleButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            middleButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor, constant: 0),
            middleButton.heightAnchor.constraint(equalToConstant: size),
            middleButton.widthAnchor.constraint(equalToConstant: size)
        ]
        
        for constraint in constraints {
            constraint.isActive = true
        }
        
        // border radius
        middleButton.layer.cornerRadius = size / 2
        
        // shadow
        middleButton.layer.shadowColor = UIColor.black.cgColor
        middleButton.layer.shadowOffset = CGSize(width: 0,
                                                 height: 8)
        middleButton.layer.shadowOpacity = 0.75
        middleButton.layer.shadowRadius = 13
        
        // other
        middleButton.layer.masksToBounds = false
        middleButton.translatesAutoresizingMaskIntoConstraints = false
        
        // action
        middleButton.rx.tap
            .subscribe(
                onNext: { tap in
                    if self.selectedIndex == 0 {
                        self.entriesNav.pushViewController(AddEditEntryController(node: AddEditEntryNode()), animated: true)
                    } else {
                        self.insightsNav.pushViewController(AddEditEntryController(node: AddEditEntryNode()), animated: true)
                    }
                    
                }
            ).disposed(by: disposeBag)
    }
}
