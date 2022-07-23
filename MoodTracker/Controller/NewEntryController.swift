//
//  NewEntryController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/20/22.
//

import Foundation
import AsyncDisplayKit

class NewEntryController : ASDKViewController<NewEntryNode> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "New Entry"
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "BlueBase")
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.node.nextBtn.addTarget(self, action: #selector(nextPressed), forControlEvents: .touchUpInside)
        self.node.cancelBtn.addTarget(self, action: #selector(cancelPressed), forControlEvents: .touchUpInside)
        (self.node.moodSlider.view as! UISlider).addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func nextPressed() {
        self.navigationController?.pushViewController(AddTagsController(node: AddTagNode()), animated: true)
    }
    
    @objc func cancelPressed() {
        print("Cancel pressed")
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        print("Slider value change")
    }
}
