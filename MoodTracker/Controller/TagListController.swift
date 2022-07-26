//
//  TagListController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/25/22.
//

import Foundation
import AsyncDisplayKit

class TagListController : ASDKViewController<TagListNode> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.node.tagsTable.delegate = self
        self.node.tagsTable.dataSource = self
        self.node.tagsTable.view.separatorStyle = .none
    }
}


extension TagListController : ASTableDataSource {
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return moodStore.state.tableTags.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = TagCell()
        let index =  moodStore.state.tableTags.index(moodStore.state.tableTags.startIndex, offsetBy: indexPath.row)
        
        cell.designCell()
        cell.tag.attributedText = NSAttributedString(string: moodStore.state.tableTags[index],
                                                     attributes: AttributesFormat.tagBtnAttr)
                                                     
        return cell
    }
}

// MARK: - ASTableDelegate
extension TagListController : ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        
        // TODO: - when selected, add it to the chosen stack
    }
}
