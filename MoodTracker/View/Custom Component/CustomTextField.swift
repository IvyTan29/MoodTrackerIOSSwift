//
//  CustomTextField.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/28/22.
//

import Foundation
import AsyncDisplayKit

class CustomTextField : ASDisplayNode {
    
    let textField = ASEditableTextNode()
    var placeHolderText = ""
    
    convenience init(text: String) {
        self.init()
        
        backgroundColor = .white
        automaticallyManagesSubnodes = true
        
        self.placeHolderText = text
    }

    override func didLoad() {
        super.didLoad()
        
        textField.borderColor = UIColor.lightGray.cgColor
        textField.borderWidth = 0.5
//        textField.cornerRadius =
        textField.attributedPlaceholderText = NSAttributedString(
            string: self.placeHolderText,
            attributes: AttributesFormat.addTagTFAttr
        )
        textField.textView.font = UIFont.init(name: "Avenir", size: 18.0)
        textField.textContainerInset = .init(top: 12.5, left: 10, bottom: 10, right: 10)
        
        textField.maximumLinesToDisplay = 1
        textField.enablesReturnKeyAutomatically = false
        textField.style.height = .init(unit: .points, value: 50)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(
            insets: .zero,
            child: textField
        )
    }
}
