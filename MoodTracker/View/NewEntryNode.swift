//
//  NewEntryNode.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/20/22.
//

import Foundation
import AsyncDisplayKit

class NewEntryNode : ASDisplayNode {
    
    var datePicker = ASDisplayNode(viewBlock: {() -> UIView in
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        return picker
    })
    var timePicker = ASDisplayNode(viewBlock: {() -> UIView in
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .time
        return picker
    })
    var moodSlider = ASDisplayNode(viewBlock: {() -> UIView in
        let slider = UISlider()
        slider.minimumValue = -3
        slider.maximumValue = 3
        slider.value = 0
        slider.minimumTrackTintColor = UIColor.systemRed
        return slider
    })
    var titleLabel = ASTextNode()
    var lowLabel = ASTextNode()
    var highLabel = ASTextNode()
    var nextBtn = ASButtonNode()
    var cancelBtn = ASButtonNode()
    
    static let mainBtnAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 22)!,
                              NSAttributedString.Key.foregroundColor: UIColor.white]
    static let cancelBtnAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 18)!,
                                NSAttributedString.Key.foregroundColor: UIColor.gray,
                                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
    
    override init() {
        super.init()
        backgroundColor = .white
        
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        datePicker.style.height = .init(unit: .points, value: 25)
        datePicker.style.width = .init(unit: .points, value: 100)
        
        timePicker.style.height = .init(unit: .points, value: 30)
        timePicker.style.width = .init(unit: .points, value: 100)
        
        let titleAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 30)!,
                         NSAttributedString.Key.foregroundColor: UIColor.black]
        let moodLevelAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 12)!,
                             NSAttributedString.Key.foregroundColor: UIColor.black]
        
        moodSlider.style.height = .init(unit: .points, value: 20)
        
        titleLabel.attributedText = NSAttributedString(string: "My Mood", attributes: titleAttr)
        
        lowLabel.attributedText = NSAttributedString(string: "Low", attributes: moodLevelAttr)
        
        highLabel.attributedText = NSAttributedString(string: "High", attributes: moodLevelAttr)
        
        nextBtn.setAttributedTitle(NSAttributedString(string: "Next", attributes: NewEntryNode.mainBtnAttr), for: .normal)
        nextBtn.backgroundColor = UIColor(named: "BlueBase")
        nextBtn.style.width = .init(unit: .points, value: 100)
        nextBtn.style.height = .init(unit: .points, value: 50)
        nextBtn.cornerRadius = 10
        
        cancelBtn.setAttributedTitle(NSAttributedString(string: "Cancel", attributes: NewEntryNode.cancelBtnAttr), for: .normal)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        //FIXME:
        let dateTimeStack = ASStackLayoutSpec(direction: .vertical,
                                              spacing: 10,
                                              justifyContent: .start,
                                              alignItems: .center,
                                              children: [datePicker, timePicker])
        
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
                                            children: [dateTimeStack, moodStack])
        
        let bigStack = ASStackLayoutSpec(direction: .vertical,
                                         spacing: 10,
                                         justifyContent: .spaceBetween,
                                         alignItems: .stretch,
                                         children: [secondStack, navigationStack])
        
        return ASInsetLayoutSpec(insets: .init(top: 100, left: 10, bottom: 10, right: 10), child: bigStack)
    }
}
