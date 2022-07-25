//
//  TagCell.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/25/22.
//

import Foundation
import AsyncDisplayKit

class TagCell : ASCellNode {
    
    var tag = ASTextNode()
    var card = ASDisplayNode()
    
    override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let tagCenter = ASCenterLayoutSpec(centeringOptions: .X,
                                           sizingOptions: .minimumY,
                                           child: tag)
        
        let carded = ASBackgroundLayoutSpec(child: tagCenter, background: card)
        
        return ASInsetLayoutSpec(insets: .init(top: 10, left: 10, bottom: 10, right: 10), child: carded)
    }
    
    func designCell() {
        card.borderWidth = 1
        card.borderColor = UIColor.lightGray.cgColor
        
        card.style.flexGrow = 1
        card.cornerRadius = 15
        
        
        
    }
}
