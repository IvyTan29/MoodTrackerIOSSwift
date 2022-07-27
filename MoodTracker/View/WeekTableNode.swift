//
//  WeekTableNode.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/27/22.
//

import Foundation
import AsyncDisplayKit

class WeekTableNode : ASDisplayNode {
    
    var weeksTitle = ASTextNode()
    var weeksTable = ASTableNode()
    
    override init() {
        super.init()
        
        backgroundColor = .systemBackground
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        weeksTitle.attributedText = NSAttributedString(string: "List of Weeks", attributes: AttributesFormat.timeLabelAttr)
        
        weeksTable.style.height = .init(unit: .fraction, value: 0.8)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec(direction: .vertical,
                                      spacing: 10,
                                      justifyContent: .start,
                                      alignItems: .center,
                                      children: [weeksTitle, weeksTable])
        
        return ASInsetLayoutSpec(insets: .init(top: 50, left: 20, bottom: 10, right: 20), child: stack)
    }
}
