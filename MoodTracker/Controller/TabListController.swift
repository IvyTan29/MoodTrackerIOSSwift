//
//  TabListController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/25/22.
//

import Foundation
import AsyncDisplayKit

class TabListController : ASDKViewController<TabListNode> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.node.tagsTable.delegate = self
        self.node.tagsTable.dataSource = self
        self.node.tagsTable.view.separatorStyle = .none
    }
}


extension TabListController : ASTableDataSource {
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return moodStore.state.tagsDict.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = TabCell()
        let index = moodStore.state.tagsDict.index(moodStore.state.tagsDict.startIndex, offsetBy: indexPath.row)
        
        cell.designCell()
        cell.tag.attributedText = NSAttributedString(string: moodStore.state.tagsDict[index].key,
                                                     attributes: AttributesFormat.tagBtnAttr)
                                                     
        return cell
    }
}

// MARK: - ASTableDelegate
extension TabListController : ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        
        // TODO: - when selected, add it to the chosen stack
    }
}
