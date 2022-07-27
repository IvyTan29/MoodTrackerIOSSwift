//
//  AddNoteController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/21/22.
//

import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa

class AddNoteController: ASDKViewController<AddNoteNode> {
    
    var indexPath: IndexPath?
    var noteOperation: Note = Note.add
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = NavController.backBarButton
        
        if noteOperation == .add || noteOperation == .edit {
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: nil)
            self.navigationItem.rightBarButtonItem?.rx.tap
                .subscribe(
                    onNext: { tap in
                        moodStore.dispatch(EditorNoteAction.init(note: self.node.noteTextView.textView.text ?? "",
                                                                 index: self.indexPath))
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                ).disposed(by: disposeBag)
            
            if noteOperation == .add {
                self.navigationItem.title = "Add Note"
            } else {
                self.navigationItem.title = "Edit Note"
            }
            
        } else {
            self.navigationItem.title = "Your Note"
        }
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent && self.noteOperation == .display {
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    @objc func donePressed() {
        moodStore.dispatch(EditorNoteAction.init(note: self.node.noteTextView.textView.text ?? "",
                                                 index: self.indexPath))
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func load(_ indexPath: IndexPath?, _ noteOperation: Note) {
        self.indexPath = indexPath
        self.noteOperation = noteOperation
        
        // assign value
        if let safeIndexPath = self.indexPath {
            self.node.noteTextView.textView.text = moodStore.state.filterMoodList[safeIndexPath.row].note
            
            if self.noteOperation == .display {
                self.node.noteTextView.textView.isEditable = false
            }
        }
        
        if self.noteOperation == .add {
            self.node.noteTextView.textView.text = moodStore.state.editorMood?.note
        }
    }
}
