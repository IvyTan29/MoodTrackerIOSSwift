//
//  EntriesController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/21/22.
//

import Foundation
import AsyncDisplayKit

class EntriesController : ASDKViewController<EntriesNode> {
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Entries"
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "BlueBase")
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.node.entryTable.delegate = self
        self.node.entryTable.dataSource = self
        self.node.entryTable.view.separatorStyle = .none
        
        self.node.noEntriesLabel.attributedText = NSAttributedString(string: "\(MoodLogData.moodLogs.count) Entries", attributes: EntriesNode.noEntryAttr)
    }
}

extension EntriesController : ASTableDataSource, ASTableDelegate {
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return MoodLogData.moodLogs.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        print(MoodLogData.moodLogs[indexPath.row].tags)
        let cell = EntryCell(tagStrArray: MoodLogData.moodLogs[indexPath.row].tags)
        cell.designCell()

        dateFormatter.dateFormat = "h:mm a"
        
        let timeLabelAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir-Black", size: 22)!,
                            NSAttributedString.Key.foregroundColor: UIColor(named: "BlueBase") as Any] as [NSAttributedString.Key : Any]
        
        cell.timeLabel.attributedText = NSAttributedString(string: dateFormatter.string(from: MoodLogData.moodLogs[indexPath.row].dateTime), attributes: timeLabelAttr)
        
        (cell.moodSlider.view as? UISlider)?.value = MoodLogData.moodLogs[indexPath.row].moodValue

        return cell
    }
}
