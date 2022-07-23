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
    
    var tagBtn1 = ASButtonNode()
    var tagBtn2 = ASButtonNode()
    var tagBtn3 = ASButtonNode()
    var tagBtn4 = ASButtonNode()
    var tagBtn5 = ASButtonNode()
    var tagBtn6 = ASButtonNode()
    var tagArray = ["Work", "Good Meal", "Presentation", "Swimming", "Difficult Conversation", "Energized"]
    var tagBtns: [ASButtonNode]
    
    var addNoteBtn = ASButtonNode()
    var doneBtn = ASButtonNode()
    var cancelBtn = ASButtonNode()

    var addNoteStr : String
    
    static let tagBtnNorAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 22)!,
                         NSAttributedString.Key.foregroundColor: UIColor.gray]
    static let tagBtnSelAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 22)!,
                         NSAttributedString.Key.foregroundColor: UIColor.black]
    
    override init() {
        self.tagBtns = [tagBtn1, tagBtn2, tagBtn3, tagBtn4, tagBtn5, tagBtn6]
        
        for (index, element) in tagBtns.enumerated() {
            element.setAttributedTitle(NSAttributedString(string: tagArray[index], attributes: AddTagNode.tagBtnNorAttr), for: .normal)
            element.setAttributedTitle(NSAttributedString(string: tagArray[index], attributes: AddTagNode.tagBtnSelAttr), for: .selected)
        }
        
        super.init()
        
        backgroundColor = .white
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        let tagTextFieldAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 18)!,
                                NSAttributedString.Key.foregroundColor: UIColor.gray]
        let recentLabelAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 22)!,
                               NSAttributedString.Key.foregroundColor: UIColor.black]
        let addNoteBtnAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 22)!,
                              NSAttributedString.Key.foregroundColor: UIColor.black,
                              NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
        
        tagTextField.borderColor = UIColor.lightGray.cgColor
        tagTextField.borderWidth = 1
        tagTextField.textView.textContainerInset = .init(top: 8, left: 10, bottom: 8, right: 10)
        tagTextField.attributedPlaceholderText = NSAttributedString(string: "Type to add Tag", attributes: tagTextFieldAttr)
        
        recentLabel.attributedText = NSAttributedString(string: "Recent", attributes: recentLabelAttr)
        
        tagBtns.forEach { (tagBtn) in
            tagBtn.borderWidth = 1
            tagBtn.borderColor = UIColor.lightGray.cgColor
            tagBtn.cornerRadius = 15
            tagBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        }
        
        
        doneBtn.setAttributedTitle(NSAttributedString(string: "Done", attributes: AddEditEntryNode.mainBtnAttr), for: .normal)
        doneBtn.backgroundColor = UIColor(named: "BlueBase")
        doneBtn.style.width = .init(unit: .points, value: 100)
        doneBtn.style.height = .init(unit: .points, value: 50)
        doneBtn.cornerRadius = 10
        
        addNoteBtn.setAttributedTitle(NSAttributedString(string: addNoteStr, attributes: addNoteBtnAttr), for: .normal)
        
        cancelBtn.setAttributedTitle(NSAttributedString(string: "Cancel", attributes: AddEditEntryNode.cancelBtnAttr), for: .normal)
        
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
}
