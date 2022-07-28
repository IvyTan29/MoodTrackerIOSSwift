//
//  EntriesNode.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/21/22.
//

import Foundation
import AsyncDisplayKit

class EntriesNode : ASDisplayNode {
    
    var calendarSegmentControl = ASDisplayNode { () -> UIView in
        let segmentControl = UISegmentedControl(items: ["Day", "Week", "Month", "All"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.layer.backgroundColor = UIColor.clear.cgColor
        
        if #available(iOS 13.0, *) {
            segmentControl.selectedSegmentTintColor = UIColor(named: "OrangeSecondary")
        } else {
            segmentControl.tintColor = UIColor(named: "OrangeSecondary")
        }
        
        segmentControl.setTitleTextAttributes([ .foregroundColor: UIColor.white ], for: .selected)
        segmentControl.setTitleTextAttributes([ .foregroundColor: UIColor(named: "OrangeSecondary") ], for: .normal)
        
        segmentControl.layer.borderWidth = 2
        segmentControl.layer.cornerRadius = 5.0
        segmentControl.layer.borderColor = UIColor(named: "OrangeSecondary")?.cgColor
        segmentControl.layer.masksToBounds = true
        
        if #available(iOS 13.0, *) {
            //just to be sure it is full loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                for i in 0...(segmentControl.numberOfSegments-1)  {
                    let backgroundSegmentView = segmentControl.subviews[i]
                    //it is not enogh changing the background color. It has some kind of shadow layer
                    backgroundSegmentView.isHidden = true
                }
            }
        }
        
        return segmentControl
    }

    var dayDatePicker = ASDisplayNode(viewBlock: {() -> UIView in
        let picker = UIDatePicker()
        
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.date = Date()
        picker.maximumDate = Date()
        
        return picker
    })
    
    var monthPicker = ASDisplayNode(viewBlock: {() -> UIView in
        let picker = UIPickerView()
        
        return picker
    })
    
    var weekPicker = ASCustomButton()
    var calendarImage = ASImageNode()
    
    var noEntryLabel = ASTextNode()
    var noEntryImage = ASImageNode()
    var numEntriesLabel = ASTextNode()
    var entryTable = ASTableNode()
    
    var dateType : DateType = .dayControl
    
    override init() {
        super.init()
        
        backgroundColor = .systemBackground
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        // Attributes
        calendarSegmentControl.style.height = .init(unit: .points, value: 35)
        
        dayDatePicker.style.height = .init(unit: .points, value: 40)
        dayDatePicker.style.width = .init(unit: .fraction, value: 0.35)
        
        monthPicker.style.height = .init(unit: .points, value: 85)
        monthPicker.style.width = .init(unit: .fraction, value: 0.6)
//        monthPicker.
        
        weekPicker.style.height = .init(unit: .points, value: 40)
        weekPicker.backgroundColor = .systemGray6
        weekPicker.cornerRadius = 8
        weekPicker.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        if #available(iOS 15.0, *) {
            (weekPicker.view as? UIButton)?.configuration!.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 10)
        }
//        weekPicker.view.titleLabel.font = 22
        
        calendarImage.image = UIImage(systemName: "calendar")
        
        noEntryLabel.attributedText = NSAttributedString(string: "No entries found", attributes: AttributesFormat.recentLabelAttr)
        
        noEntryImage.image = UIImage(systemName: "rectangle.on.rectangle.slash")
        noEntryImage.style.width = .init(unit: .points, value: 30)
        noEntryImage.style.height = .init(unit: .points, value: 30)
        
        numEntriesLabel.attributedText = NSAttributedString(string: "_ Entries", attributes: AttributesFormat.numEntryAttr)
        
        entryTable.style.height = .init(unit: .fraction, value: 0.8)
        //        entryTable.style.flexBasis = ASDimensionMake("60%")
        
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        var dateStackChildren : [ASLayoutElement] = []
        
        if self.dateType == .dayControl {
            dateStackChildren += [calendarImage, dayDatePicker]
        } else if self.dateType == .weekControl {
            dateStackChildren += [calendarImage, weekPicker]
        } else if self.dateType == .monthControl {
            dateStackChildren += [calendarImage, monthPicker]
        }
        
        let dateStack = ASStackLayoutSpec(direction: .horizontal,
                                           spacing: 5,
                                           justifyContent: .center,
                                           alignItems: .center,
                                           children: dateStackChildren)
        
        let numEntryContainer = ASInsetLayoutSpec(insets: .init(top: 0, left: 15, bottom: 0, right: 15),
                                                  child: numEntriesLabel)
        
        let entryTableStack = ASStackLayoutSpec(direction: .vertical,
                                                spacing: 5,
                                                justifyContent: .start,
                                                alignItems: .start,
                                                children: [numEntryContainer, entryTable])
        
        let noEntryFoundStack = ASStackLayoutSpec(direction: .vertical,
                                                  spacing: 5,
                                                  justifyContent: .center,
                                                  alignItems: .center,
                                                  children: [noEntryImage, noEntryLabel])
        
        noEntryFoundStack.style.height = .init(unit: .fraction, value: 0.7)
        
        let verticalStack = ASStackLayoutSpec(direction: .vertical,
                                              spacing: 12,
                                              justifyContent: .start,
                                              alignItems: .stretch,
                                              children: [calendarSegmentControl, dateStack] + (moodStore.state.filterMoodList.count == 0 ? [noEntryFoundStack] : [numEntryContainer, entryTable]))
        
        return ASInsetLayoutSpec(insets: .init(top: 120, left: 10, bottom: 30, right: 10), child: verticalStack)
    }
}

