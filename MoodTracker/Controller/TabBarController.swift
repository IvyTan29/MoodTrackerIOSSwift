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
        
        self.setViewControllers([NavController()], animated: true)
    }
    
//    func setupMiddleButton() {
//        
//        centerButton = UIButton(frame: CGRect(x: (self.bounds.width / 2)-(centerButtonHeight/2), y: -16, width: centerButtonHeight, height: centerButtonHeight))
//        centerButton!.setNeedsDisplay()
//        centerButton!.layer.cornerRadius = centerButton!.frame.size.width / 2.0
//        centerButton!.setTitle(buttonTitle, for: .normal)
//        centerButton!.setImage(UIImage(named: "plus"), for: .normal)
//        centerButton!.backgroundColor = .init(red: 0.07, green: 0.83, blue: 0.05, alpha: 1.0)
//        centerButton!.tintColor = UIColor.white
//        
//        //add to the tabbar and add click event
//        self.addSubview(centerButton!)
////        centerButton!.addTarget(self, action: #selector(self.centerButtonAction), for: .touchUpInside)
//    }
    
    
    
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//                    let myTabBar = tabBar as! CustomizedTabBar
//        if (myTabBar.items?[3] == item) {
//            myTabBar.arc = false
//        } else {
//            myTabBar.arc = true
//        }
//    }
}
