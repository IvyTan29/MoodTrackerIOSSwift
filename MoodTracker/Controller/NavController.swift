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
    }
}

