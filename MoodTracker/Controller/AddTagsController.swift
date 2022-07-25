//
//  AddTagsController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/20/22.
//

import Foundation
import AsyncDisplayKit
import RxSwift

class AddTagsController : ASDKViewController<AddTagNode> {
    
    var indexPath: IndexPath?
    var tagsSet: Set<String> = []
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if indexPath != nil {
            self.navigationItem.title = "Edit Tags"
        } else {
            self.navigationItem.title = "Add Tags"
        }
        
        self.navigationItem.backBarButtonItem = NavController.backBarButton
        
        self.tabBarController?.tabBar.isHidden = true
        
        // for done button on the upper right
        self.node.doneBtn.rxTap
            .subscribe(
                onNext: { tap in
                    self.donePressed()
                }
            ).disposed(by: disposeBag)
        
        // for the cancel button
        self.node.cancelBtn.rxTap
            .subscribe(
                onNext: { tap in
                    self.navigationController?.popToRootViewController(animated: true)
                    self.tabBarController?.tabBar.isHidden = false
                }
            ).disposed(by: disposeBag)

        // for the add button
        self.node.addNoteBtn.rxTap
            .subscribe(
                onNext: { tap in
                    self.addNotePressed()
                }
            ).disposed(by: disposeBag)
        
        // FIXME: change this to rxTap
        self.node.tagBtns.forEach { (btnNode) in
            btnNode.addTarget(self, action: #selector(tagPressed(_:)), forControlEvents: .touchUpInside)
        }
    }
    
    func donePressed() {
        moodStore.dispatch(EditorTagsAction.init(tags: self.tagsSet))
        
        // FIXME: - change this to delegate ba?
        if let indexPath = self.indexPath {
            moodStore.dispatch(EditMoodAction.init(index: indexPath))
        } else {
            moodStore.dispatch(AddMoodAction.init())
        }
        
        self.navigationController?.popToRootViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func addNotePressed() {
        let editorNote = AddNoteController(node: AddNoteNode())
        
        // for editing purposes
        if let safeIndexPath = self.indexPath {
            editorNote.load(safeIndexPath, Note.edit)
        } else {
            editorNote.load(nil, Note.add)
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
