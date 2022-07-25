//
//  EntryCell.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/21/22.
//

import Foundation
import AsyncDisplayKit
import RxSwift

protocol EntryCellDelegate {
    func didDisplayNote(index: IndexPath)
}

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
    var tagLabels: [ASTextNode] = []
    
    var showNoteBtn = ASCustomButton()
    var showNoteImage = ASImageNode()
    
    var indexPathInCell : IndexPath?
    var delegate: EntryCellDelegate?
    var disposeBag = DisposeBag()
    
    init(tagStrSet: Set<String>) {
        self.tagStrSet = tagStrSet
        
        for _ in self.tagStrSet {
            self.tagLabels.append(ASTextNode())
        }
        
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        self.showNoteBtn.rxTap
            .subscribe(
                onNext: { tap in
                    if let indexPath = self.indexPathInCell {
                        self.delegate?.didDisplayNote(index: indexPath)
                    }
                }
            ).disposed(by: disposeBag)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let timeSliderStack = ASStackLayoutSpec(direction: .horizontal,
                                                spacing: 10,
                                                justifyContent: .spaceBetween,
                                                alignItems: .start,
                                                children: [timeLabel, moodSlider])
        
        let tagLabelsStack = ASStackLayoutSpec(direction: .horizontal,
                                               spacing: 10,
                                               justifyContent: .start,
                                               alignItems: .start,
                                               flexWrap: .wrap,
                                               alignContent: .center,
                                               lineSpacing: 10,
                                               children: tagLabels)
        
        let showNoteStack = ASStackLayoutSpec(direction: .horizontal,
                                              spacing: 5,
                                              justifyContent: .start,
                                              alignItems: .start,
                                              children: [showNoteImage, showNoteBtn])
        
        let bigVerticalStack = ASStackLayoutSpec(direction: .vertical,
                                                 spacing: 20,
                                                 justifyContent: .spaceBetween,
                                                 alignItems: .stretch,
                                                 children: [timeSliderStack, tagLabelsStack, showNoteStack])
        
        let insetContent = ASInsetLayoutSpec(insets: .init(top: 15, left: 15, bottom: 15, right: 15), child: bigVerticalStack)
        
        let carded = ASBackgroundLayoutSpec(child: insetContent, background: card)
        
        return ASInsetLayoutSpec(insets: .init(top: 10, left: 10, bottom: 10, right: 10), child: carded)
    }
    
    func designCell () {
        showNoteImage.image = UIImage(systemName: "note")
        
        //        card.layer.shadowColor = UIColor.black.cgColor
        //        card.layer.shadowOffset = CGSize(width: 10, height: 10)
        //        card.layer.shadowOpacity = 0.75
        //        card.layer.shadowRadius = 13
        
        card.borderWidth = 1
        card.borderColor = UIColor.lightGray.cgColor
        
        card.style.flexGrow = 1
        
        moodSlider.style.height = .init(unit: .points, value: 20)
        moodSlider.style.width = .init(unit: .fraction, value: 0.7)
        
        for (idx, element) in tagLabels.enumerated() {
            element.attributedText = NSAttributedString(string: tagStrSet[tagStrSet.index(tagStrSet.startIndex, offsetBy: idx)], attributes: AttributesFormat.tagLabelAttr)
        }
        
        tagLabels.forEach { (tagLabel) in
            tagLabel.borderWidth = 1
            tagLabel.borderColor = UIColor.lightGray.cgColor
            tagLabel.cornerRadius = 15
            tagLabel.textContainerInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        }
        
        showNoteBtn.setAttributedTitle(NSAttributedString(string: "Added Note", attributes: EntriesNode.noEntryAttr), for: .normal)
        
        //FIXME: - fixed color para obvious na button sya
        //        showNoteBtn.borderWidth = 1
        //        showNoteBtn.borderColor = UIColor(named: "OrangeSecondary")?.cgColor
    }
}
