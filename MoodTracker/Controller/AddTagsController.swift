//
//  AddTagsController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/20/22.
//

import Foundation
import AsyncDisplayKit

class AddTagsController : ASDKViewController<AddTagNode> {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add Tags"
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "BlueBase")
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.node.doneBtn.addTarget(self, action: #selector(donePressed), forControlEvents: .touchUpInside)
        self.node.cancelBtn.addTarget(self, action: #selector(cancelPressed), forControlEvents: .touchUpInside)
        self.node.addNoteBtn.addTarget(self, action: #selector(addNotePressed), forControlEvents: .touchUpInside)
        
        self.node.tagBtns.forEach { (btnNode) in
            btnNode.addTarget(self, action: #selector(tagPressed(_:)), forControlEvents: .touchUpInside)
        }
    }
    
    @objc func donePressed() {
        print("Done pressed")
    }
    
    @objc func cancelPressed() {
        print("Cancel pressed")
    }
    
    @objc func addNotePressed() {
        self.navigationController?.pushViewController(AddNoteController(node: AddNoteNode()), animated: true)
    }
    
    @objc func tagPressed(_ sender: ASButtonNode) {
        sender.isSelected = !sender.isSelected
    }
    
}
