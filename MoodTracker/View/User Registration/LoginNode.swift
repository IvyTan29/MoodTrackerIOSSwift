//
//  LoginNode.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/29/22.
//

import Foundation
import AsyncDisplayKit

class LoginNode: ASDisplayNode {
    
    let loginTitle = ASTextNode()
    
    let emailTF = CustomTextField(text: "Email Address")
    let passwordTF = CustomTextField(text: "Password")
    
    let loginBtn = ASCustomButton()
    
    let accountText = ASTextNode()
    let registerBtn = ASCustomButton()
    
    override init() {
        super.init()
        
        backgroundColor = .white
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        loginTitle.attributedText = NSAttributedString(
            string: "Welcome!",
            attributes: AttributesFormat.titleLogRegAttr
        )
        
        loginBtn.setAttributedTitle(NSAttributedString(
            string: "LOGIN",
            attributes: AttributesFormat.loginBtnAttr),
                                   for: .normal
        )
        loginBtn.backgroundColor = UIColor(named: "BlueBase")
        loginBtn.cornerRadius = 10
        loginBtn.contentEdgeInsets = UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 30)
        
        accountText.attributedText = NSAttributedString(
            string: "Don't have an account?",
            attributes: AttributesFormat.addTagTFAttr
        )
        
        registerBtn.setAttributedTitle(NSAttributedString(
            string: "Register",
            attributes: AttributesFormat.switchBtnAttr
        ), for: .normal)
        registerBtn.setAttributedTitle(NSAttributedString(
            string: "Register",
            attributes: AttributesFormat.moodLevelAttr
        ), for: .highlighted)
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let title = ASRelativeLayoutSpec(
            horizontalPosition: .start,
            verticalPosition: .center,
            sizingOption: .minimumSize,
            child: loginTitle
        )
        
        let inputFields = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .stretch,
            children: [emailTF, passwordTF]
        )

        let centerBtn = ASCenterLayoutSpec(
            centeringOptions: .X,
            sizingOptions: .minimumX,
            child: loginBtn
        )
        
        let switchRegStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 5,
            justifyContent: .center,
            alignItems: .end,
            children: [accountText, registerBtn]
        )
        
        let stack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 50,
            justifyContent: .center,
            alignItems: .stretch,
            children: [title, inputFields, centerBtn, switchRegStack]
        )
        
        return ASInsetLayoutSpec(insets: .init(top: -10, left: 20, bottom: 10, right: 20), child: stack)
    }
}
