//
//  AddNoteController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/21/22.
//

import Foundation
import AsyncDisplayKit

class AddNoteController: ASDKViewController<AddNoteNode> {
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if indexPath != nil {
            self.navigationItem.title = "Edit Note"
        } else {
            self.navigationItem.title = "Add Note"
        }

        self.navigationController?.navigationBar.barTintColor = UIColor(named: "BlueBase")
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(donePressed))
        
        self.tabBarController?.tabBar.isHidden = true
        
//        UIBarButtonItemAppearance(style: UIBarButtonItem.Style)
        
//        UIBarButtonItem.Style(rawValue: <#T##Int#>)
    }
    
    @objc func donePressed() {
        moodStore.dispatch(EditorNoteAction.init(note: self.node.noteTextView.textView.text ?? ""))
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func load(_ indexPath: IndexPath) {
        self.indexPath = indexPath
        
        // assign value
        self.node.noteTextView.textView.text = moodStore.state.moodList[indexPath.row].note
    }
}
