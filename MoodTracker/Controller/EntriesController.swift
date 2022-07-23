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
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "BlueBase")
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        self.tabBarItem = UITabBarItem(title: "Entries", image: UIImage(named: "note"), tag: 0)
        self.tabBarController?.tabBar.isHidden = false
        
        self.node.entryTable.delegate = self
        self.node.entryTable.dataSource = self
        self.node.entryTable.view.separatorStyle = .none
        
        self.node.noEntriesLabel.attributedText = NSAttributedString(string: "\(moodStore.state.moodList.count) Entries", attributes: EntriesNode.noEntryAttr)
        
        // TEMPORARY
        self.node.addBtn.addTarget(self, action: #selector(addMoodPressed), forControlEvents: .touchUpInside)
    }
    
    // TEMPORARY
    @objc func addMoodPressed () {
        print("Add pressed")
        self.navigationController?.pushViewController(NewEntryController(node: NewEntryNode()), animated: true)
    }
}

// MARK: - ASTableDataSource
extension EntriesController : ASTableDataSource {
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return moodStore.state.moodList.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = EntryCell(tagStrArray: moodStore.state.moodList[indexPath.row].tags ?? [])
        cell.designCell()
        
        let timeLabelAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir-Black", size: 22)!,
                            NSAttributedString.Key.foregroundColor: UIColor(named: "BlueBase") as Any] as [NSAttributedString.Key : Any]
        
        cell.timeLabel.attributedText = NSAttributedString(string: DateFormat.dateFormatToString(format: "h:mm a", date: moodStore.state.moodList[indexPath.row].dateTime ?? Date()), attributes: timeLabelAttr)
        
        (cell.moodSlider.view as? UISlider)?.value = moodStore.state.moodList[indexPath.row].moodValue ?? 0

        return cell
    }
}

// MARK: - ASTableDelegate
extension EntriesController : ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        // TODO: - help
//        let editor = ASEditController.create()
//        editor.load(model: modelStore.state.list[indexPath.row], indexPath: indexPath)
//        editor.delegate = self
//        self.navigationController?.pushViewController(editor, animated: true)
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
    }
}
