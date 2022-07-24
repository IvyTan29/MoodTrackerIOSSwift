//
//  NewEntryController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/20/22.
//

import Foundation
import AsyncDisplayKit

class AddEditEntryController : ASDKViewController<AddEditEntryNode> {
    
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if indexPath != nil {
            self.navigationItem.title = "Edit Entry"
        } else {
            self.navigationItem.title = "New Entry"
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "BlueBase")
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
//        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(named: "chevron.backward"), style: .plain, target: self, action: #selector(backLeftNavButtonPressed))]
        
        
//        CustomBackButton.createWithImage(UIImage(named: "yourImageName")!, color: UIColor.yourColor(), target: weakSelf, action: #selector(YourViewController.tappedBackButton)
        
        
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.node.nextBtn.addTarget(self, action: #selector(nextPressed), forControlEvents: .touchUpInside)
        self.node.cancelBtn.addTarget(self, action: #selector(cancelPressed), forControlEvents: .touchUpInside)
    }
    
    @objc func nextPressed() {
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
    
    @objc func cancelPressed() {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
//    @objc func backLeftNavButtonPressed() {
//        self.tabBarController?.tabBar.isHidden = false
//    }
    
    func load(_ indexPath: IndexPath) {
        self.indexPath = indexPath
        
        // assign values
        (self.node.dateTimePicker.view as? UIDatePicker)?.date = moodStore.state.moodList[indexPath.row].dateTime ?? Date()
        (self.node.moodSlider.view as? UISlider)?.value = moodStore.state.moodList[indexPath.row].moodValue ?? 50
    }
    
}
