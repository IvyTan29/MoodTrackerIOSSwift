//
//  AddTagsController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/20/22.
//

import Foundation
import AsyncDisplayKit
import RxSwift
import ReSwift

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

        // for the add note button
        self.node.addNoteBtn.rxTap
            .subscribe(
                onNext: { tap in
                    self.addNotePressed()
                }
            ).disposed(by: disposeBag)
        
        // for the more tags ("...") button
        self.node.moreTagsBtn.rxTap
            .subscribe(
                onNext: { tap in
                    self.present(TagListController(node: TagListNode()), animated: true)
                }
            ).disposed(by: disposeBag)
        
        // for the add tag button from text field
        self.node.addTagBtn.rxTap
            .subscribe(
                onNext: { tap in
                    let string = self.node.tagTextField.textView.text
                    
                    moodStore.dispatch(PickedTagBtnAction.init(tagStr: string ?? ""))
                }
            ).disposed(by: disposeBag)
        
        // for the tag buttons pressed
        self.node.tagBtns.forEach { (btnNode) in
            btnNode.rxTap
                .subscribe(
                    onNext: { tap in
                        self.tagPressed(btnNode)
                    }
                ).disposed(by: disposeBag)
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
        moodStore.dispatch(PickedTagBtnAction.init(tagStr:  sender.attributedTitle(for: .normal)?.string ?? ""))
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

// MARK: - StoreSubscriber
extension AddTagsController : StoreSubscriber {
    override func viewWillAppear(_ animated: Bool) {
       moodStore.subscribe(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
       moodStore.unsubscribe(self)
    }

    func newState(state: MoodState) {
        print("went here?")
        self.node.setRecentTagButton()
//        self.node.layoutSpecThatFits(<#T##constrainedSize: ASSizeRange##ASSizeRange#>)
        self.node.view.layoutIfNeeded()
        
    }
}

