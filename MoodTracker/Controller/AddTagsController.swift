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
        
        // for the add tag button from text field
        self.node.addTagBtn.rxTap
            .subscribe(
                onNext: { tap in
                    let string = self.node.tagTextField.textView.text
                    self.node.tagTextField.textView.text = ""
                    
                    if let string = string {
                        if string != "" {
                            moodStore.dispatch(AddTagAction.init(tagStr: string))
                        }
                    }
                }
            ).disposed(by: disposeBag)
    }
    
    func donePressed() {
        moodStore.dispatch(EditorTagsAction.init())
        
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
    
    func load(_ indexPath: IndexPath) {
        self.indexPath = indexPath
        
        moodStore.dispatch(InitializeTagsEditAction(index: indexPath))
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
        self.node.setChosenTagButton()
        
        let count = self.node.tagBtns.count - 1
        
        for idx in 0..<count {
            self.node.tagBtns[idx].rxTap
                .subscribe(
                    onNext: { tap in
                        moodStore.dispatch(AddTagAction.init(tagStr:  self.node.tagBtns[idx].attributedTitle(for: .normal)?.string ?? ""))
                    }
                ).disposed(by: disposeBag)
        }
        
        // for the more tags ("...") button
        self.node.moreTagsBtn.rxTap
            .subscribe(
                onNext: { tap in
                    self.present(TagListController(node: TagListNode()), animated: true)
                }
            ).disposed(by: disposeBag)

        self.node.chosenTagBtns.forEach({ button in
            button.rxTap
                .subscribe(
                    onNext: { tap in
                        moodStore.dispatch(DeleteTagAction.init(tagStr: button.attributedTitle(for: .normal)?.string ?? ""))
                    }
                ).disposed(by: disposeBag)
        })
        
        self.node.setNeedsLayout()
        self.node.layoutIfNeeded()
    }
}

