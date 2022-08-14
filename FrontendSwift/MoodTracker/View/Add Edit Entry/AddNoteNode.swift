//
//  AddNoteNode.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/21/22.
//

import Foundation
import AsyncDisplayKit

class AddNoteNode : ASDisplayNode {
    
    let noteTextView = ASEditableTextNode()
    
    override init() {
        super.init()
        
        backgroundColor = .systemBackground
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        noteTextView.textContainerInset = .init(top: 8, left: 10, bottom: 8, right: 10)
        noteTextView.textView.font =  UIFont.init(name: "Avenir-Medium", size: 22.0)
        noteTextView.textView.textColor = .gray
        noteTextView.autocorrectionType = .no
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .init(top: 100, left: 20, bottom: 20, right: 20), child: self.noteTextView)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        noteTextView.textView.textContainerInset = .init(top: 8, left: 10, bottom: keyboardHeight, right: 10)
        noteTextView.setNeedsLayout()
    }
}
