//
//  AddNoteController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/21/22.
//

import Foundation
import AsyncDisplayKit

class AddNoteController: ASDKViewController<AddNoteNode> {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add Note"
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "BlueBase")
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(donePressed))
        
        self.tabBarController?.tabBar.isHidden = true
        
//        UIBarButtonItemAppearance(style: UIBarButtonItem.Style)
        
//        UIBarButtonItem.Style(rawValue: <#T##Int#>)
    }
    
    @objc func donePressed() {
        self.navigationController?.pushViewController(EntriesController(node: EntriesNode()), animated: true)
    }
}
