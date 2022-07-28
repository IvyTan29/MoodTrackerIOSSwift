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
    var addTagBtn = ASCustomButton()
    
    var chosenTagBtns: [ASCustomButton] = []
    var recentLabel = ASTextNode()
    var tagBtns: [ASCustomButton] = []
    var moreTagsBtn = ASCustomButton()
    
    var addNoteBtn = ASCustomButton()
    var doneBtn = ASCustomButton()
    var cancelBtn = ASCustomButton()
    
    var addNoteStr : String?
    var isHiddenAddTagBtn = true
    
    override init() {
        super.init()
        
        backgroundColor = .systemBackground
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        tagTextField.borderColor = UIColor.lightGray.cgColor
        tagTextField.borderWidth = 1
        //        tagTextField.typingAttributes = AttributesFormat.addTagTFAttr
        tagTextField.attributedPlaceholderText = NSAttributedString(string: "Type to add Tag", attributes: AttributesFormat.addTagTFAttr)
//        tagTextField.textView.contentInset = .init(top: 8, left: 10, bottom: 8, right: 10)
        tagTextField.textView.textContainerInset = .init(top: 8, left: 10, bottom: 8, right: 10)
        tagTextField.textView.font =  UIFont.init(name: "Avenir", size: 18.0)
        tagTextField.style.height = .init(unit: .points, value: 40)
        tagTextField.style.flexGrow = 1
        
        addTagBtn.setAttributedTitle(NSAttributedString(string: "Add Tag", attributes: AttributesFormat.addTagBtnAttr), for: .normal)
//        addTagBtn.style.width = .init(unit: .points, value: 60)
        addTagBtn.style.height = .init(unit: .points, value: 40)
        
        
        recentLabel.attributedText = NSAttributedString(string: "Recent", attributes: AttributesFormat.recentLabelAttr)
        
        doneBtn.setAttributedTitle(NSAttributedString(string: "Done", attributes: AttributesFormat.proceedBtnAttr), for: .normal)
        doneBtn.backgroundColor = UIColor(named: "BlueBase")
        doneBtn.style.width = .init(unit: .points, value: 100)
        doneBtn.style.height = .init(unit: .points, value: 50)
        doneBtn.cornerRadius = 10
        
        addNoteBtn.setAttributedTitle(NSAttributedString(string: addNoteStr ?? "", attributes: AttributesFormat.addNoteBtnAttr), for: .normal)
        
        cancelBtn.setAttributedTitle(NSAttributedString(string: "Cancel", attributes: AttributesFormat.cancelBtnAttr), for: .normal)
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let chosenTagsStack = ASStackLayoutSpec(direction: .horizontal,
                                                spacing: 10,
                                                justifyContent: .center,
                                                alignItems: .start,
                                                flexWrap: .wrap,
                                                alignContent: .center,
                                                lineSpacing: 10,
                                                children: chosenTagBtns)
        
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
        
        let typingWithBtn = ASStackLayoutSpec(direction: .horizontal,
                                              spacing: 5,
                                              justifyContent: .start,
                                              alignItems: .start,
                                              children: [tagTextField] + (self.isHiddenAddTagBtn ? [] : [addTagBtn]))
    
        let firstStack = ASStackLayoutSpec(direction: .vertical,
                                           spacing: 20,
                                           justifyContent: .start,
                                           alignItems: .stretch,
                                           children: [typingWithBtn, chosenTagsStack, recentLabelCenter, tagBtnStack])
        
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
        print("LOAD FIRST RECENT TAGS")
        
        
        setRecentTagBtn()
        setChosenTagButton()
    }
    
    func setMoreTagBtn() {
        self.moreTagsBtn.setAttributedTitle(NSAttributedString(string: "...", attributes: AttributesFormat.tagBtnAttr), for: .normal)
        self.moreTagsBtn.borderWidth = 1
        self.moreTagsBtn.borderColor = UIColor.black.cgColor
        self.moreTagsBtn.cornerRadius = 20
        self.moreTagsBtn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 30, bottom: 5, right: 30)
        
        self.tagBtns.append(self.moreTagsBtn)
    }
    
    func setRecentTagBtn() {
        print("SET RECENT TAG BUTTON")
        self.tagBtns = []
        
        for recentTag in moodStore.state.recentTags {
            self.tagBtns.append(createRecentTagBtn(recentTag))
        }
    }
    
    func createRecentTagBtn(_ string: String) -> ASCustomButton {
        let tempTagBtn = ASCustomButton()
        tempTagBtn.setAttributedTitle(NSAttributedString(string: string, attributes: AttributesFormat.tagBtnAttr), for: .normal)
        
        tempTagBtn.borderWidth = 1
        tempTagBtn.borderColor = UIColor.black.cgColor
        tempTagBtn.cornerRadius = 20
        tempTagBtn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 30, bottom: 5, right: 30)
        
        //        tempTagBtn.setAttributedTitle(NSAttributedString(string: string, attributes: AttributesFormat.tagPickBtnAttr), for: .selected)
        
        return tempTagBtn
    }
    
    func setChosenTagButton() {
        self.chosenTagBtns = []
        
        for chosenTag in moodStore.state.chosenTags {
            self.chosenTagBtns.append(createChosenTagBtn(chosenTag))
        }
    }
    
    func createChosenTagBtn(_ string: String) -> ASCustomButton {
        let tempTagBtn = ASCustomButton()
        tempTagBtn.setAttributedTitle(NSAttributedString(string: string, attributes: AttributesFormat.tagPickBtnAttr), for: .selected)
        tempTagBtn.setAttributedTitle(NSAttributedString(string: string, attributes: AttributesFormat.tagPickBtnAttr), for: .normal)
        
        tempTagBtn.borderWidth = 1
        tempTagBtn.borderColor = UIColor(named: "OrangeSecondary")?.cgColor
        tempTagBtn.cornerRadius = 20
        tempTagBtn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 30, bottom: 5, right: 30)
        //        tempTagBtn.isSelected = true
        
        return tempTagBtn
    }
}
