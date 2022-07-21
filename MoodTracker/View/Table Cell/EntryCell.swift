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
        slider.minimumTrackTintColor = UIColor.systemRed
        slider.isEnabled = false
        
        return slider
    }
    
//    var tagStrArray: [String] = []
//    var tagBtns: [ASButtonNode] = []
    
    var showNoteBtn = ASButtonNode()
    var showNoteImage = ASImageNode()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
    }
    
//    init(tagStrArray: [String]) {
//        self.tagStrArray = tagStrArray
//
//        for _ in self.tagStrArray {
//            self.tagBtns.append(ASButtonNode())
//        }
//
//        super.init()
//        automaticallyManagesSubnodes = true
//    }
    
    override func didLoad() {
        super.didLoad()
        
//        self.style.height = .init(unit: .points, value: 400)
        
        card.borderWidth = 1
        card.borderColor = UIColor.lightGray.cgColor
        card.style.flexGrow = 1
        
        moodSlider.style.height = .init(unit: .points, value: 20)
        moodSlider.style.width = .init(unit: .fraction, value: 0.7)
        print((moodSlider.view as? UISlider)?.value)
        
//        for (index, element) in tagBtns.enumerated() {
//            element.setAttributedTitle(NSAttributedString(string: tagStrArray[index], attributes: AddTagNode.tagBtnNorAttr), for: .normal)
//        }
        
//        tagBtns.forEach { (tagBtn) in
//            tagBtn.borderWidth = 1
//            tagBtn.borderColor = UIColor.lightGray.cgColor
//            tagBtn.cornerRadius = 15
//            tagBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
//        }
        
        showNoteImage.image = UIImage(systemName: "calendar")
//        showNoteImage.style.height = .init(unit: .points, value: 10)
//        showNoteImage.style.width = .init(unit: .points, value: 10)
            
        showNoteBtn.setAttributedTitle(NSAttributedString(string: "Added Note", attributes: EntriesNode.noEntryAttr), for: .normal)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let timeSliderStack = ASStackLayoutSpec(direction: .horizontal,
                                                spacing: 10,
                                                justifyContent: .spaceBetween,
                                                alignItems: .start,
                                                children: [timeLabel, moodSlider])
        
//        let tagBtnStack = ASStackLayoutSpec(direction: .horizontal,
//                                            spacing: 0,
//                                            justifyContent: .center,
//                                            alignItems: .start,
//                                            flexWrap: .wrap,
//                                            alignContent: .center,
//                                            lineSpacing: 10,
//                                            children: tagBtns)
        
        let showNoteStack = ASStackLayoutSpec(direction: .horizontal,
                                              spacing: 10,
                                              justifyContent: .spaceBetween,
                                              alignItems: .start,
                                              children: [showNoteImage, showNoteBtn])
        
        let bigVerticalStack = ASStackLayoutSpec(direction: .vertical,
                                                 spacing: 10,
                                                 justifyContent: .spaceBetween,
                                                 alignItems: .stretch,
                                                 children: [timeSliderStack, showNoteBtn])
        
        let insetContent = ASInsetLayoutSpec(insets: .init(top: 10, left: 10, bottom: 10, right: 10), child: bigVerticalStack)
        
        let carded = ASBackgroundLayoutSpec(child: insetContent, background: card)
        
        return ASInsetLayoutSpec(insets: .init(top: 10, left: 10, bottom: 10, right: 10), child: carded)
    }
}
