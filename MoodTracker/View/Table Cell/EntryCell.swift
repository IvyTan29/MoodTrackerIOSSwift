//
//  EntryCell.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/21/22.
//

import Foundation
import AsyncDisplayKit

class EntryCell : ASCellNode {
    
    var card = ASDisplayNode()
    var timeLabel = ASTextNode()
    var moodSlider = ASDisplayNode { () -> UIView in
        let slider = UISlider()
        
        slider.minimumValue = -3
        slider.maximumValue = 3
        slider.minimumTrackTintColor = UIColor(named: "OrangeSecondary")
        slider.isEnabled = false
        slider.thumbTintColor = UIColor(named: "OrangeSecondary")
        
        return slider
    }
    
    var tagStrSet: Set<String> = []
    var tagBtns: [ASButtonNode] = []
    
    var showNoteBtn = ASButtonNode()
    var showNoteImage = ASImageNode()
    
    init(tagStrSet: Set<String>) {
        self.tagStrSet = tagStrSet
        
        for _ in self.tagStrSet {
            self.tagBtns.append(ASButtonNode())
        }
        
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let timeSliderStack = ASStackLayoutSpec(direction: .horizontal,
                                                spacing: 10,
                                                justifyContent: .spaceBetween,
                                                alignItems: .start,
                                                children: [timeLabel, moodSlider])
        
        let tagBtnStack = ASStackLayoutSpec(direction: .horizontal,
                                            spacing: 10,
                                            justifyContent: .start,
                                            alignItems: .start,
                                            flexWrap: .wrap,
                                            alignContent: .center,
                                            lineSpacing: 10,
                                            children: tagBtns)
        
        let showNoteStack = ASStackLayoutSpec(direction: .horizontal,
                                              spacing: 10,
                                              justifyContent: .start,
                                              alignItems: .start,
                                              children: [showNoteImage, showNoteBtn])
        
        let bigVerticalStack = ASStackLayoutSpec(direction: .vertical,
                                                 spacing: 20,
                                                 justifyContent: .spaceBetween,
                                                 alignItems: .stretch,
                                                 children: [timeSliderStack, tagBtnStack, showNoteStack])
        
        let insetContent = ASInsetLayoutSpec(insets: .init(top: 15, left: 15, bottom: 15, right: 15), child: bigVerticalStack)
        
        let carded = ASBackgroundLayoutSpec(child: insetContent, background: card)
        
        return ASInsetLayoutSpec(insets: .init(top: 10, left: 10, bottom: 10, right: 10), child: carded)
    }
    
    func designCell () {
        showNoteImage.image = UIImage(systemName: "note")
        
        card.borderWidth = 1
        card.borderColor = UIColor.lightGray.cgColor
        card.style.flexGrow = 1
        
        moodSlider.style.height = .init(unit: .points, value: 20)
        moodSlider.style.width = .init(unit: .fraction, value: 0.7)
        
        for (idx, element) in tagBtns.enumerated() {
            element.setAttributedTitle(NSAttributedString(string: tagStrSet[tagStrSet.index(tagStrSet.startIndex, offsetBy: idx)], attributes: AddTagNode.tagBtnNorAttr),
                                       for: .normal)
        }
        
        tagBtns.forEach { (tagBtn) in
            tagBtn.borderWidth = 1
            tagBtn.borderColor = UIColor.lightGray.cgColor
            tagBtn.cornerRadius = 15
            tagBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        }
        
        showNoteBtn.setAttributedTitle(NSAttributedString(string: "Added Note", attributes: EntriesNode.noEntryAttr), for: .normal)
    }
}
