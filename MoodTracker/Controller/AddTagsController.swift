//
//  AddTagsController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/20/22.
//

import Foundation
import AsyncDisplayKit

class AddTagsController : ASDKViewController<AddTagNode> {
    
    var tagsSet: Set<String> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add Tags"
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "BlueBase")
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.node.doneBtn.addTarget(self, action: #selector(donePressed), forControlEvents: .touchUpInside)
        self.node.cancelBtn.addTarget(self, action: #selector(cancelPressed), forControlEvents: .touchUpInside)
        self.node.addNoteBtn.addTarget(self, action: #selector(addNotePressed), forControlEvents: .touchUpInside)
        
        self.node.tagBtns.forEach { (btnNode) in
            btnNode.addTarget(self, action: #selector(tagPressed(_:)), forControlEvents: .touchUpInside)
        }
    }
    
    @objc func donePressed() {
        print(tagsSet)
        
        moodStore.dispatch(EditorTagsAction.init(tags: tagsSet))
        
        // FIXME: - change this to delegate ba?
        moodStore.dispatch(AddMoodAction.init())
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func cancelPressed() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func addNotePressed() {
        self.navigationController?.pushViewController(AddNoteController(node: AddNoteNode()), animated: true)
    }
    
    @objc func tagPressed(_ sender: ASButtonNode) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            tagsSet.insert(sender.attributedTitle(for: .selected)?.string ?? "")
        } else {
            tagsSet.remove(sender.attributedTitle(for: .selected)?.string ?? "")
        }
    }
    
}
