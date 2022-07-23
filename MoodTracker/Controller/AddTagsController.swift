//
//  AddTagsController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/20/22.
//

import Foundation
import AsyncDisplayKit

class AddTagsController : ASDKViewController<AddTagNode> {
    
    var indexPath: IndexPath?
    var tagsSet: Set<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if indexPath != nil {
            self.navigationItem.title = "Edit Tags"
        } else {
            self.navigationItem.title = "Add Tags"
        }
        
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
        moodStore.dispatch(EditorTagsAction.init(tags: tagsSet))
        
        // FIXME: - change this to delegate ba?
        if let indexPath = self.indexPath {
            moodStore.dispatch(EditMoodAction.init(index: indexPath))
        } else {
            moodStore.dispatch(AddMoodAction.init())
        }
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func cancelPressed() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func addNotePressed() {
        let editorNote = AddNoteController(node: AddNoteNode())
        
        // for editing purposes
        if let safeIndexPath = self.indexPath {
            editorNote.load(safeIndexPath)
        }

        self.navigationController?.pushViewController(editorNote, animated: true)
    }
    
    @objc func tagPressed(_ sender: ASButtonNode) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            self.tagsSet.insert(sender.attributedTitle(for: .selected)?.string ?? "")
        } else {
            self.tagsSet.remove(sender.attributedTitle(for: .selected)?.string ?? "")
        }
    }
    
    func load(_ indexPath: IndexPath) {
        self.indexPath = indexPath
        
        self.tagsSet = moodStore.state.moodList[indexPath.row].tags ?? []
        
        // assign values
        for button in self.node.tagBtns {
            let buttonText = button.attributedTitle(for: .normal)?.string ?? ""
            let isChoice = moodStore.state.moodList[indexPath.row].tags?.contains(buttonText)
            
            if let isChoice = isChoice {
                if isChoice {
                    button.isSelected = true
                }
            }
        }
    }
}
