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
        
        if #available(iOS 13.0, *) {
            segmentControl.selectedSegmentTintColor = UIColor(named: "OrangeSecondary")
        } else {
            segmentControl.tintColor = UIColor(named: "OrangeSecondary")
        }
        segmentControl.setTitleTextAttributes([ .foregroundColor: UIColor.white ], for: .selected)
        
        return segmentControl
    }
    
    var entryTable = ASTableNode()
    var todayBtn = ASDisplayNode()
    var todayImage = ASImageNode()
    var noEntriesLabel = ASTextNode()
    
    override init() {
        super.init()
        
        backgroundColor = .systemBackground
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        // Attributes
        calendarSegmentControl.style.height = .init(unit: .points, value: 50)
        
        todayImage.image = UIImage(systemName: "calendar")
        todayBtn.setAttributedTitle(NSAttributedString(string: "Today", attributes: AttributesFormat.todayBtnAttr), for: .normal)
        
        entryTable.style.height = .init(unit: .fraction, value: 0.8)
//        entryTable.style.flexBasis = ASDimensionMake("60%")
        
        noEntriesLabel.attributedText = NSAttributedString(string: "_ Entries", attributes: AttributesFormat.numEntryAttr)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let todayStack = ASStackLayoutSpec(direction: .horizontal,
                                           spacing: 10,
                                           justifyContent: .center,
                                           alignItems: .center,
                                           children: [todayImage, todayBtn])
        
        let numEntryContainer = ASInsetLayoutSpec(insets: .init(top: 0, left: 15, bottom: 0, right: 15),
                                                  child: noEntriesLabel)
        
        let verticalStack = ASStackLayoutSpec(direction: .vertical,
                                              spacing: 10,
                                              justifyContent: .start,
                                              alignItems: .stretch,
                                              children: [calendarSegmentControl, todayStack, numEntryContainer, entryTable])
        
        return ASInsetLayoutSpec(insets: .init(top: 100, left: 10, bottom: 30, right: 10), child: verticalStack)
    }
}

