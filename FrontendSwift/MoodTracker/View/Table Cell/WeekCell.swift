//
//  WeekCell.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/27/22.
//

import Foundation
import AsyncDisplayKit

class WeekCell : ASCellNode {
    
    var weekRange = ASTextNode()
    
    override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .init(top: 10, left: 50, bottom: 10, right: 50),
                                 child: weekRange)
    }
}
