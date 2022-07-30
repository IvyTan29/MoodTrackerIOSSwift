//
//  RegisterNode.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/29/22.
//

import Foundation
import AsyncDisplayKit

class RegisterNode: ASDisplayNode {
    
    let registerTitle = ASTextNode()
    
    let nameTF = CustomTextField(text: "Name")
    let emailTF = CustomTextField(text: "Email Address")
    let passwordTF = CustomTextField(text: "Password")
    let confirmPassTF = CustomTextField(text: "Confirm Password")
    
    let registerBtn = ASCustomButton()
    
    let accountText = ASTextNode()
    let loginBtn = ASCustomButton()
    
    override init() {
        super.init()
        
        backgroundColor = .white
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        registerTitle.attributedText = NSAttributedString(
            string: "Create Account",
            attributes: AttributesFormat.titleLogRegAttr
        )
        
        registerBtn.setAttributedTitle(NSAttributedString(
            string: "REGISTER",
            attributes: AttributesFormat.loginBtnAttr),
                                   for: .normal
        )
        registerBtn.backgroundColor = UIColor(named: "BlueBase")
        registerBtn.cornerRadius = 10
        registerBtn.contentEdgeInsets = UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 30)
        
        accountText.attributedText = NSAttributedString(
            string: "Already have an account?",
            attributes: AttributesFormat.addTagTFAttr
        )
        
        loginBtn.setAttributedTitle(NSAttributedString(
            string: "Login",
            attributes: AttributesFormat.switchBtnAttr
        ), for: .normal)
        loginBtn.setAttributedTitle(NSAttributedString(
            string: "Login",
            attributes: AttributesFormat.moodLevelAttr
        ), for: .highlighted)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let title = ASRelativeLayoutSpec(
            horizontalPosition: .start,
            verticalPosition: .center,
            sizingOption: .minimumSize,
            child: registerTitle
        )
        
        let inputFields = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .stretch,
            children: [nameTF, emailTF, passwordTF, confirmPassTF]
        )

        let centerBtn = ASCenterLayoutSpec(
            centeringOptions: .X,
            sizingOptions: .minimumX,
            child: registerBtn
        )
        
        let switchRegStack = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 5,
            justifyContent: .center,
            alignItems: .end,
            children: [accountText, loginBtn]
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
