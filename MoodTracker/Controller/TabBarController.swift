//
//  TabBarController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/22/22.
//

import UIKit
import RxCocoa
import RxSwift

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
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addEntryNav = NavController() // no use because it will be disabled
        
        // FIXME: - add in the future if needed...
        let settings = SettingsController()
        
        self.entriesNav.tabBarItem = UITabBarItem(title: "Entries", image: UIImage(systemName: "list.bullet.rectangle.portrait"), selectedImage: UIImage(systemName: "list.bullet.rectangle.portrait.fill"))
        
        addEntryNav.tabBarItem = UITabBarItem(title: "Add", image: nil, selectedImage: nil)
        settings.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape.fill"))
        
        self.setViewControllers([self.entriesNav, addEntryNav, settings], animated: false)
        
        addMiddleButton()
        styleTab()
    }
    
    func styleTab() {
        let tabBarAppearance = UITabBarAppearance()
        let tabBarItemAppearance = UITabBarItemAppearance()
        
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(named: "BlueBase")
        
        // color for title in tab bar items
        tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGray4]
        tabBarItemAppearance.disabled.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGray4]
        tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
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
                    self.entriesNav.pushViewController(AddEditEntryController(node: AddEditEntryNode()), animated: true)
                }).disposed(by: disposeBag)
        
    }
}
