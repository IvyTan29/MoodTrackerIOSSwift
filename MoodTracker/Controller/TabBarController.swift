//
//  TabBarController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/22/22.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addEntryNav = NavController() // no use because it will be disabled
        
        // FIXME: - add in the future if needed...
        let tempNav = NavController()
        
        self.entriesNav.tabBarItem = UITabBarItem(title: "Entries", image: UIImage(named: "list.bullet.rectangle.portrait"), selectedImage: UIImage(named: "list.bullet.rectangle.portrait.fill"))
        
        
        addEntryNav.tabBarItem = UITabBarItem(title: "Add", image: nil, selectedImage: nil)
        tempNav.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "gearshape"), selectedImage: UIImage(named: "gearshape.fill"))
        
        self.setViewControllers([self.entriesNav, addEntryNav, tempNav], animated: false)
        
        addMiddleButton()
        
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
        middleButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }

        return middleButton.frame.contains(point) ? middleButton : super.hitTest(point, with: event)
    }
    
    @objc func addButtonPressed() {
        self.entriesNav.pushViewController(AddEditEntryController(node: AddEditEntryNode()), animated: true)
    }
}

