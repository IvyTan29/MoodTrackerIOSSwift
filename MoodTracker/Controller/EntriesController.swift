//
//  EntriesController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/21/22.
//

import Foundation
import AsyncDisplayKit
import ReSwift

class EntriesController : ASDKViewController<EntriesNode> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Entries"
        self.navigationItem.backBarButtonItem = NavController.backBarButton
        
        self.tabBarController?.tabBar.isHidden = false
        
        self.node.entryTable.delegate = self
        self.node.entryTable.dataSource = self
        self.node.entryTable.view.separatorStyle = .none
        
        self.node.noEntriesLabel.attributedText = NSAttributedString(string: "\(moodStore.state.moodList.count) Entries", attributes: AttributesFormat.numEntryAttr)
    }
}

// MARK: - ASTableDataSource
extension EntriesController : ASTableDataSource {
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return moodStore.state.moodList.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = EntryCell(tagStrSet: moodStore.state.moodList[indexPath.row].tags ?? [])
        
        cell.designCell()
        
        cell.timeLabel.attributedText = NSAttributedString(string: DateFormat.dateFormatToString(format: "h:mm a", date: moodStore.state.moodList[indexPath.row].dateTime ?? Date()), attributes: AttributesFormat.timeLabelAttr)
        (cell.moodSlider.view as? UISlider)?.value = moodStore.state.moodList[indexPath.row].moodValue ?? 0
        
        cell.indexPathInCell = indexPath
        cell.delegate = self

        return cell
    }
}

// MARK: - ASTableDelegate
extension EntriesController : ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        
        let editor = AddEditEntryController(node: AddEditEntryNode())
        editor.load(indexPath)
        
//        editor.delegate = self
        self.navigationController?.pushViewController(editor, animated: true)
    }
}

// MARK: - EntryCellDelegate
extension EntriesController : EntryCellDelegate {
    func didDisplayNote(index: IndexPath) {
        let noteEditor = AddNoteController(node: AddNoteNode())
        noteEditor.load(index, .display)
        
        self.navigationController?.pushViewController(noteEditor, animated: true)
        
    }
}

// MARK: - StoreSubscriber
extension EntriesController : StoreSubscriber {
    override func viewWillAppear(_ animated: Bool) {
       moodStore.subscribe(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
       moodStore.unsubscribe(self)
    }

    func newState(state: MoodState) {
        self.node.entryTable.reloadData()
        self.node.noEntriesLabel.attributedText = NSAttributedString(string: "\(moodStore.state.moodList.count) Entries", attributes: AttributesFormat.numEntryAttr)
    }
}
