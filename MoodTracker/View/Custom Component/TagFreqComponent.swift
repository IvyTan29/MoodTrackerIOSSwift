//
//  TagFreqComponent.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/28/22.
//

import Foundation
import AsyncDisplayKit

class TagFregComponent : ASDisplayNode {
    
    var tagLabel = ASTextNode()
    var freqLabel = ASTextNode()
    
    override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 5,
            justifyContent: .center,
            alignItems: .start,
            children: [tagLabel, freqLabel]
        )
    }
}
