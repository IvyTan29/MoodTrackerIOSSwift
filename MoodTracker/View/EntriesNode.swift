//
//  EntriesNode.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/21/22.
//

import Foundation
import AsyncDisplayKit

class EntriesNode: ASDisplayNode {
    
    var calendarSegmentControl = ASDisplayNode { () -> UIView in
        let segmentControl = UISegmentedControl(items: ["Day", "Week", "Month", "All"])
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }
    
    var entryTable = ASTableNode()
    var todayBtn = ASButtonNode()
    var todayImage = ASImageNode()
    var noEntriesLabel = ASTextNode()
    
    static let noEntryAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 18)!,
                       NSAttributedString.Key.foregroundColor: UIColor.lightGray as Any] as [NSAttributedString.Key : Any]
    
    override init() {
        super.init()
        
        backgroundColor = .white
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        // Attributes
        let todayBtnAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 22)!,
                            NSAttributedString.Key.foregroundColor: UIColor(named: "BlueBase") as Any,
                            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                            NSAttributedString.Key.underlineColor: UIColor.lightGray] as [NSAttributedString.Key : Any]
        
        
        calendarSegmentControl.style.height = .init(unit: .points, value: 50)
        
        todayImage.image = UIImage(systemName: "calendar")
        todayBtn.setAttributedTitle(NSAttributedString(string: "Today", attributes: todayBtnAttr), for: .normal)
        
        entryTable.style.height = .init(unit: .fraction, value: 0.8)
//        entryTable.style.flexBasis = ASDimensionMake("60%")
        
        noEntriesLabel.attributedText = NSAttributedString(string: "_ Entries", attributes: EntriesNode.noEntryAttr)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let todayStack = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .center, alignItems: .center, children: [todayImage, todayBtn])
        
        let verticalStack = ASStackLayoutSpec(direction: .vertical,
                                              spacing: 10,
                                              justifyContent: .start,
                                              alignItems: .stretch,
                                              children: [calendarSegmentControl, todayStack, noEntriesLabel, entryTable])
        
        return ASInsetLayoutSpec(insets: .init(top: 100, left: 10, bottom: 10, right: 10), child: verticalStack)
    }
}

