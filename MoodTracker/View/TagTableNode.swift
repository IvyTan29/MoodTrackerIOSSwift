//
//  TagTableNode.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/25/22.
//

import AsyncDisplayKit

class TagTableNode : ASDisplayNode {
    
    var tagsTitle = ASTextNode()
    var tagsTable = ASTableNode()
    
    override init() {
        super.init()
        
        backgroundColor = .systemBackground
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        tagsTitle.attributedText = NSAttributedString(string: "More Tags", attributes: AttributesFormat.timeLabelAttr)
        
        tagsTable.style.height = .init(unit: .fraction, value: 0.8)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec(direction: .vertical,
                                      spacing: 10,
                                      justifyContent: .start,
                                      alignItems: .center,
                                      children: [tagsTitle, tagsTable])
        
        return ASInsetLayoutSpec(insets: .init(top: 100, left: 10, bottom: 20, right: 10), child: stack)
    }
}
