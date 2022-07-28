//
//  InsightsNode.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/28/22.
//

import Foundation
import AsyncDisplayKit

class InsightsNode : ASDisplayNode {
    
    var dateComponentSegmentControl = ASDisplayNode { () -> UIView in
        let segmentControl = UISegmentedControl(items: ["This Week", "Last Week", "Last Month", "Overall"])
        segmentControl.selectedSegmentIndex = 0
        
        segmentControl.setTitleTextAttributes([ .underlineStyle: NSUnderlineStyle.single.rawValue ], for: .selected)
//        segmentControl.setTitleTextAttributes([ .foregroundColor: UIColor(named: "OrangeSecondary") ], for: .normal)
        
        segmentControl.layer.borderWidth = 1
        segmentControl.layer.cornerRadius = 3
        segmentControl.layer.borderColor = UIColor.systemGray4.cgColor
        segmentControl.layer.masksToBounds = true
        
        return segmentControl
    }
    
    var moodSlider = ASDisplayNode(viewBlock: {() -> UIView in
        let slider = UISlider()
        
        slider.minimumValue = -3
        slider.maximumValue = 3
        slider.value = 0
        slider.minimumTrackTintColor = UIColor(named: "OrangeSecondary")
        slider.thumbTintColor = UIColor(named: "OrangeSecondary")
        slider.isContinuous = false
        
        return slider
    })
    
    var titleLabel = ASTextNode()
    var lowLabel = ASTextNode()
    var highLabel = ASTextNode()
    
    var movedToggle = false
    var instructLabel = ASTextNode()
    
    var oftenLabel = ASTextNode()
    var tags: [TagFregComponent] = []
    var noTagLabel = ASTextNode()
    var noTagImage = ASImageNode()
    
    var grayBackground = ASDisplayNode()
    
    override init() {
        super.init()
        
        backgroundColor = .systemBackground
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        dateComponentSegmentControl.style.height = .init(unit: .points, value: 35)
        
        moodSlider.style.height = .init(unit: .points, value: 20)
        
        titleLabel.attributedText = NSAttributedString(
            string: "When I was feeling",
            attributes: AttributesFormat.titleInsightsAttr
        )
        
        lowLabel.attributedText = NSAttributedString(
            string: "Low",
            attributes: AttributesFormat.moodLevelAttr
        )
        
        highLabel.attributedText = NSAttributedString(
            string: "High",
            attributes: AttributesFormat.moodLevelAttr
        )
        
        instructLabel.attributedText = NSAttributedString(
            string: "Move toggle to see insights",
            attributes: AttributesFormat.moodLevelAttr
        )
        
        oftenLabel.attributedText = NSAttributedString(
            string: "And often with",
            attributes: AttributesFormat.titleInsightsAttr
        )
        
        noTagLabel.attributedText = NSAttributedString(
            string: "No entries found",
            attributes: AttributesFormat.recentLabelAttr
        )
        
        noTagImage.image = UIImage(systemName: "rectangle.on.rectangle.slash")
        noTagImage.style.width = .init(unit: .points, value: 30)
        noTagImage.style.height = .init(unit: .points, value: 30)
        
        grayBackground.backgroundColor = .systemGray5
        grayBackground.style.flexGrow = 1
        
        setUpTagFrequency()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let moodLevelStack = ASStackLayoutSpec(direction: .horizontal,
                                               spacing: 40,
                                               justifyContent: .spaceBetween,
                                               alignItems: .stretch,
                                               children: [lowLabel, highLabel])
        
        let titleLabelCenter = ASCenterLayoutSpec(centeringOptions: .X,
                                                  sizingOptions: .minimumY,
                                                  child: titleLabel)
        
        let secTitleLabelCenter = ASCenterLayoutSpec(centeringOptions: .X,
                                                  sizingOptions: .minimumY,
                                                  child: instructLabel)
        
        let moodStack = ASStackLayoutSpec(direction: .vertical,
                                          spacing: 10,
                                          justifyContent: .start,
                                          alignItems: .stretch,
                                          children: [titleLabelCenter, moodSlider, moodLevelStack])
//        moodStack.style.height = .init(unit: .fraction, value: 0.4)
        
        let insetContent = ASInsetLayoutSpec(insets: .init(top: 15, left: 15, bottom: 15, right: 15), child: moodStack)
        
        let moodStackWithBG = ASOverlayLayoutSpec(child: grayBackground, overlay: insetContent)
        
        
        
        let oftenLabelCenter = ASCenterLayoutSpec(centeringOptions: .X,
                                                  sizingOptions: .minimumY,
                                                  child: oftenLabel)
        
        let noTagFoundStack = ASStackLayoutSpec(direction: .vertical,
                                                  spacing: 5,
                                                  justifyContent: .center,
                                                  alignItems: .center,
                                                  children: [noTagImage, noTagLabel])
        noTagFoundStack.style.height = .init(unit: .fraction, value: 0.3)
        
        let tagLabelsStack = ASStackLayoutSpec(direction: .horizontal,
                                               spacing: 20,
                                               justifyContent: .start,
                                               alignItems: .center,
                                               flexWrap: .wrap,
                                               alignContent: .center,
                                               lineSpacing: 10,
                                               children: tags)
        
        let titleTagStack = ASStackLayoutSpec(direction: .vertical,
                                          spacing: 10,
                                          justifyContent: .start,
                                          alignItems: .center,
                                          children: [oftenLabelCenter, tagLabelsStack])
        
        var lastStack : [ASLayoutElement] = []
        if !self.movedToggle {
            lastStack.append(secTitleLabelCenter)
        } else if moodStore.state.insightTags.count != 0 {
            lastStack.append(titleTagStack)
        } else {
            lastStack.append(noTagFoundStack)
        }
        
        let bigVertStack = ASStackLayoutSpec(direction: .vertical,
                                             spacing: 100,
                                             justifyContent: .start,
                                             alignItems: .stretch,
                                             children: [dateComponentSegmentControl, moodStack] + lastStack)
        
        return ASInsetLayoutSpec(insets: .init(top: 120, left: 10, bottom: 30, right: 10), child: bigVertStack)
    }
    
    func setUpTagFrequency() {
        self.tags = []
        for (tag, freq) in moodStore.state.insightTags {
            let tagFreq = TagFregComponent()
            
            tagFreq.tagLabel.attributedText = NSAttributedString(string: tag, attributes: AttributesFormat.tagBtnAttr)
            tagFreq.tagLabel.borderWidth = 1
            tagFreq.tagLabel.borderColor = UIColor.lightGray.cgColor
            tagFreq.tagLabel.cornerRadius = 15
            tagFreq.tagLabel.textContainerInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
            
            tagFreq.freqLabel.attributedText = NSAttributedString(string: "x\(freq)", attributes: AttributesFormat.numEntryAttr)
            
            self.tags.append(tagFreq)
        }
    }
}
