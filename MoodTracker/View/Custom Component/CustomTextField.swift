//
//  CustomTextField.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/28/22.
//

import Foundation
import AsyncDisplayKit
import ASTextFieldNode

class CustomTextField : ASDisplayNode {
    
    let customTF = ASTextFieldNode()
    var placeHolderText = ""
    
    convenience init(text: String) {
        self.init()
        
        backgroundColor = .white
        automaticallyManagesSubnodes = true
        
        self.placeHolderText = text
    }

    override func didLoad() {
        super.didLoad()
        
        customTF.borderColor = UIColor.lightGray.cgColor
        customTF.borderWidth = 0.5
//        customTF.cornerRadius =
        customTF.textField.attributedPlaceholder = NSAttributedString(
            string: self.placeHolderText,
            attributes: AttributesFormat.addTagTFAttr
        )
        customTF.font = UIFont.init(name: "Avenir", size: 18.0)
        customTF.textContainerInset = .init(top: 12.5, left: 10, bottom: 10, right: 10)
        
//        customTF.maximumLinesToDisplay = 1
        customTF.enablesReturnKeyAutomatically = false
        customTF.style.height = .init(unit: .points, value: 50)
        customTF.autocorrectionType = .no
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(
            insets: .zero,
            child: customTF
        )
    }
}
