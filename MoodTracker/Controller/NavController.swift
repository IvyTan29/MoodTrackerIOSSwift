//
//  ViewController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/20/22.
//

import Foundation
import AsyncDisplayKit

class NavController : UINavigationController {
    
    static let backBarButton = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
    var isListEntires = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isListEntires {
            self.viewControllers = [EntriesController(node: EntriesNode())]
        } else {
            self.viewControllers = [InsightsController(node: InsightsNode())]
        }
        
        styleNavBar()
    }
    
    func styleNavBar() {
        // change the navigation background color and title
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(named: "BlueBase")
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont(name: "Avenir-Medium", size: 22) ?? UIFont()]
        
        
        let proxy = UINavigationBar.appearance()
        proxy.tintColor = .white // change color of the nav bar buttom items
        
        proxy.standardAppearance = navBarAppearance
        proxy.compactAppearance = navBarAppearance

        if #available(iOS 15.0, *) {
            proxy.scrollEdgeAppearance = navBarAppearance
        }
    }
    
}

