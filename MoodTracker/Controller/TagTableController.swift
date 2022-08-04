//
//  TagTableController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/25/22.
//

import Foundation
import AsyncDisplayKit

protocol TagTableDelegate : AnyObject{
    func didClickTagInTable(tagStr: String)
}

class TagTableController : ASDKViewController<TagTableNode> {
    
    weak var delegate : TagTableDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.node.tagsTable.delegate = self
        self.node.tagsTable.dataSource = self
        self.node.tagsTable.view.separatorStyle = .none
    }
}


extension TagTableController : ASTableDataSource {
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return moodStore.state.tableTags.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = TagCell()
        let index =  moodStore.state.tableTags.index(moodStore.state.tableTags.startIndex, offsetBy: indexPath.row)
        
        cell.designCell()
        cell.tag.attributedText = NSAttributedString(string: moodStore.state.tableTags[index].name,
                                                     attributes: AttributesFormat.tagBtnAttr)
                                                     
        return cell
    }
}

// MARK: - ASTableDelegate
extension TagTableController : ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let index =  moodStore.state.tableTags.index(moodStore.state.tableTags.startIndex, offsetBy: indexPath.row)
        
        tableNode.deselectRow(at: indexPath, animated: true)
    
        self.delegate?.didClickTagInTable(tagStr: moodStore.state.tableTags[index].name)
        
        moodStore.dispatch(AddTagAction.init(tag: moodStore.state.tableTags[index]))
        
        self.node.tagsTable.reloadData()
    }
}
