//
//  AddTagNode.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/20/22.
//

import Foundation
import AsyncDisplayKit

class AddTagNode : ASDisplayNode {
    
    var tagTextField = ASEditableTextNode()
    var recentLabel = ASTextNode()
    
    var tagBtns: [ASCustomButton] = []
    var moreTagsBtn = ASCustomButton()
    
    var addNoteBtn = ASCustomButton()
    var doneBtn = ASCustomButton()
    var cancelBtn = ASCustomButton()

    var addNoteStr : String?
    
    override init() {
        super.init()
        
        backgroundColor = .systemBackground
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        loadFirstRecentTags()
        
        tagTextField.borderColor = UIColor.lightGray.cgColor
        tagTextField.borderWidth = 1
        tagTextField.textView.textContainerInset = .init(top: 8, left: 10, bottom: 8, right: 10)
        tagTextField.attributedPlaceholderText = NSAttributedString(string: "Type to add Tag", attributes: AttributesFormat.addTagTFAttr)
        
        recentLabel.attributedText = NSAttributedString(string: "Recent", attributes: AttributesFormat.recentLabelAttr)
        
        
        tagBtns.forEach { (tagBtn) in
            tagBtn.borderWidth = 1
            tagBtn.borderColor = UIColor.black.cgColor
            tagBtn.cornerRadius = 20
            tagBtn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 30, bottom: 5, right: 30)
        }
        
        
        doneBtn.setAttributedTitle(NSAttributedString(string: "Done", attributes: AttributesFormat.proceedBtnAttr), for: .normal)
        doneBtn.backgroundColor = UIColor(named: "BlueBase")
        doneBtn.style.width = .init(unit: .points, value: 100)
        doneBtn.style.height = .init(unit: .points, value: 50)
        doneBtn.cornerRadius = 10
        
        addNoteBtn.setAttributedTitle(NSAttributedString(string: addNoteStr ?? "", attributes: AttributesFormat.addNoteBtnAttr), for: .normal)
        
        cancelBtn.setAttributedTitle(NSAttributedString(string: "Cancel", attributes: AttributesFormat.cancelBtnAttr), for: .normal)
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let tagBtnStack = ASStackLayoutSpec(direction: .horizontal,
                                            spacing: 10,
                                            justifyContent: .center,
                                            alignItems: .start,
                                            flexWrap: .wrap,
                                            alignContent: .center,
                                            lineSpacing: 10,
                                            children: tagBtns)
        
        let recentLabelCenter = ASCenterLayoutSpec(centeringOptions: .X,
                                                   sizingOptions: .minimumY,
                                                   child: recentLabel)
        
        let firstStack = ASStackLayoutSpec(direction: .vertical,
                                           spacing: 20,
                                           justifyContent: .start,
                                           alignItems: .stretch,
                                           children: [tagTextField, recentLabelCenter, tagBtnStack])
        
        let navigationStack = ASStackLayoutSpec(direction: .vertical,
                                                spacing: 10,
                                                justifyContent: .start,
                                                alignItems: .center,
                                                children: [doneBtn, cancelBtn])
        
        let relative = ASRelativeLayoutSpec(horizontalPosition: .center,
                                            verticalPosition: .end,
                                            sizingOption: .minimumHeight,
                                            child: navigationStack)
        
        let bigStack = ASStackLayoutSpec(direction: .vertical,
                                         spacing: 10,
                                         justifyContent: .spaceBetween,
                                         alignItems: .center,
                                         children: [firstStack, addNoteBtn, relative])
        
        return ASInsetLayoutSpec(insets: .init(top: 100, left: 10, bottom: 20, right: 10), child: bigStack)
    }
    
    func setAddNoteBtnText(string: String) {
        self.addNoteStr = string
    }
    
    func loadFirstRecentTags() {
        moodStore.dispatch(GetRecentTagAction.init())
        
        setRecentTagButton()
    }
    
    func setRecentTagButton() {
        for recentTag in moodStore.state.recentTags {
            let tempTagBtn = ASCustomButton()
            tempTagBtn.setAttributedTitle(NSAttributedString(string: recentTag, attributes: AttributesFormat.tagBtnAttr), for: .normal)
            
            self.tagBtns.append(tempTagBtn)
        }
        
        self.moreTagsBtn.setAttributedTitle(NSAttributedString(string: "...", attributes: AttributesFormat.tagBtnAttr), for: .normal)
        self.tagBtns.append(moreTagsBtn)
    }
}
