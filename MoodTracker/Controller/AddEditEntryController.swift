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
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.node.nextBtn.addTarget(self, action: #selector(nextPressed), forControlEvents: .touchUpInside)
        self.node.cancelBtn.addTarget(self, action: #selector(cancelPressed), forControlEvents: .touchUpInside)
    }
    
    @objc func nextPressed() {
        moodStore.dispatch(EditorDateLevelAction.init(dateTime: (self.node.dateTimePicker.view as? UIDatePicker)?.date,
                                                      moodValue: (self.node.moodSlider.view as? UISlider)?.value))
        
        let editorTag = AddTagsController(node: AddTagNode())
        
        // for editing purposes
        if let safeIndexPath = self.indexPath {
            editorTag.load(safeIndexPath)
        }
        
        self.navigationController?.pushViewController(editorTag, animated: true)
    }
    
    @objc func cancelPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func load(_ indexPath: IndexPath) {
        self.indexPath = indexPath
        
        // assign values
        (self.node.dateTimePicker.view as? UIDatePicker)?.date = moodStore.state.moodList[indexPath.row].dateTime ?? Date()
        (self.node.moodSlider.view as? UISlider)?.value = moodStore.state.moodList[indexPath.row].moodValue ?? 50
    }
    
}
