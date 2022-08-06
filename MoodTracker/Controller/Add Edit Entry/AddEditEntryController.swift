//
//  NewEntryController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/20/22.
//

import Foundation
import AsyncDisplayKit
import RxSwift

class AddEditEntryController : ASDKViewController<AddEditEntryNode> {
    
    var indexPath: IndexPath?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if indexPath != nil {
            self.navigationItem.title = "Edit Entry"
        } else {
            self.navigationItem.title = "New Entry"
        }
        
        self.navigationItem.backBarButtonItem = NavController.backBarButton
    
        self.tabBarController?.tabBar.isHidden = true
        
        self.node.nextBtn.rxTap
            .subscribe(
                onNext: { tap in
                    self.nextPressed()
                }
            ).disposed(by: disposeBag)
        
        self.node.cancelBtn.rxTap
            .subscribe(
                onNext: { tap in
                    self.navigationController?.popViewController(animated: true)
                }
            ).disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    func nextPressed() {
        moodStore.dispatch(EditorDateLevelAction.init(dateTime: (self.node.dateTimePicker.view as? UIDatePicker)?.date ?? Date(), moodValue: (self.node.moodSlider.view as? UISlider)?.value ?? 0))
        
        let editorTag = AddTagsController(node: AddTagNode())
        
        // for editing purposes
        if let safeIndexPath = self.indexPath {
            editorTag.load(safeIndexPath)
            editorTag.node.setAddNoteBtnText(string: "Edit note")
        } else {
            editorTag.node.setAddNoteBtnText(string: "Add note")
        }
        
        self.navigationController?.pushViewController(editorTag, animated: true)
    }
    
    func load(_ indexPath: IndexPath) {
        self.indexPath = indexPath
        
        // assign values
        (self.node.dateTimePicker.view as? UIDatePicker)?.date = moodStore.state.filterMoodList[indexPath.row].dateTime ?? Date()
        (self.node.moodSlider.view as? UISlider)?.value = moodStore.state.filterMoodList[indexPath.row].moodValue ?? 50
    }
    
}
