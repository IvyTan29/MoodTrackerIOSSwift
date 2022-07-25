//
//  NewEntryNode.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/20/22.
//

import Foundation
import AsyncDisplayKit

class AddEditEntryNode : ASDisplayNode {
    
    var dateTimePicker = ASDisplayNode(viewBlock: {() -> UIView in
        let picker = UIDatePicker()
        
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .dateAndTime
        
        return picker
    })
    
    var moodSlider = ASDisplayNode(viewBlock: {() -> UIView in
        let slider = UISlider()
        
        slider.minimumValue = -3
        slider.maximumValue = 3
        slider.value = 0
        slider.minimumTrackTintColor = UIColor(named: "OrangeSecondary")
        slider.thumbTintColor = UIColor(named: "OrangeSecondary")
        
        return slider
    })
    
    var titleLabel = ASTextNode()
    var lowLabel = ASTextNode()
    var highLabel = ASTextNode()
    var nextBtn = ASCustomButton()
    var cancelBtn = ASCustomButton()
    
    override init() {
        super.init()
        
        backgroundColor = .systemBackground
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        dateTimePicker.style.height = .init(unit: .points, value: 40)
        dateTimePicker.style.width = .init(unit: .fraction, value: 0.5)
        
        moodSlider.style.height = .init(unit: .points, value: 20)
        
        titleLabel.attributedText = NSAttributedString(string: "My Mood", attributes: AttributesFormat.myMoodAttr)
        
        lowLabel.attributedText = NSAttributedString(string: "Low", attributes: AttributesFormat.moodLevelAttr)
        
        highLabel.attributedText = NSAttributedString(string: "High", attributes: AttributesFormat.moodLevelAttr)
        
        nextBtn.setAttributedTitle(NSAttributedString(string: "Next", attributes: AttributesFormat.proceedBtnAttr), for: .normal)
        nextBtn.backgroundColor = UIColor(named: "BlueBase")
        nextBtn.style.width = .init(unit: .points, value: 100)
        nextBtn.style.height = .init(unit: .points, value: 50)
        nextBtn.cornerRadius = 10
        
        cancelBtn.setAttributedTitle(NSAttributedString(string: "Cancel", attributes: AttributesFormat.cancelBtnAttr), for: .normal)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let dateTimeCenter = ASCenterLayoutSpec(centeringOptions: .X,
                                                sizingOptions: .minimumY,
                                                child: dateTimePicker)
        
        let moodLevelStack = ASStackLayoutSpec(direction: .horizontal,
                                               spacing: 40,
                                               justifyContent: .spaceBetween,
                                               alignItems: .stretch,
                                               children: [lowLabel, highLabel])
        
        let titleLabelCenter = ASCenterLayoutSpec(centeringOptions: .X,
                                                  sizingOptions: .minimumY,
                                                  child: titleLabel)
        
        let moodStack = ASStackLayoutSpec(direction: .vertical,
                                          spacing: 40,
                                          justifyContent: .start,
                                          alignItems: .stretch,
                                          children: [titleLabelCenter, moodSlider, moodLevelStack])
        
        let navigationStack = ASStackLayoutSpec(direction: .vertical,
                                                spacing: 10,
                                                justifyContent: .start,
                                                alignItems: .center,
                                                children: [nextBtn, cancelBtn])
        
        let secondStack = ASStackLayoutSpec(direction: .vertical,
                                            spacing: 90,
                                            justifyContent: .start,
                                            alignItems: .stretch,
                                            children: [dateTimeCenter, moodStack])
        
        let bigStack = ASStackLayoutSpec(direction: .vertical,
                                         spacing: 10,
                                         justifyContent: .spaceBetween,
                                         alignItems: .stretch,
                                         children: [secondStack, navigationStack])
        
        return ASInsetLayoutSpec(insets: .init(top: 100, left: 10, bottom: 20, right: 10), child: bigStack)
    }
}
