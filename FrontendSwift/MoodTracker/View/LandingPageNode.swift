//
//  LandingPageNode.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/29/22.
//

import Foundation
import AsyncDisplayKit

class LandingPageNode: ASDisplayNode {
    
    let logoImg = ASImageNode()
    
    let loginBtn = ASCustomButton()
    let registerBtn = ASCustomButton()
    
    override init() {
        super.init()
        
        backgroundColor = UIColor(named: "BlueBase")
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        logoImg.image = UIImage(named: "LandingIcon")
        logoImg.style.height = .init(unit: .points, value: 300)
        logoImg.style.width = .init(unit: .points, value: 300)
        
        loginBtn.backgroundColor = UIColor(named: "OrangeSecondary")
        loginBtn.contentEdgeInsets = .init(top: 5, left: 10, bottom: 5, right: 20)
        loginBtn.cornerRadius = 10
        loginBtn.setAttributedTitle(NSAttributedString(
            string: "Login",
            attributes: AttributesFormat.loginBtnAttr),
                                    for: .normal)
        
        registerBtn.backgroundColor = .systemBackground
        registerBtn.contentEdgeInsets = .init(top: 5, left: 10, bottom: 5, right: 20)
        registerBtn.cornerRadius = 10
        registerBtn.setAttributedTitle(NSAttributedString(
            string: "Register",
            attributes: AttributesFormat.titleInsightsAttr),
                                    for: .normal)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let logoCenter = ASCenterLayoutSpec(
            centeringOptions: .XY,
            sizingOptions: .minimumX,
            child: logoImg
        )
        
        logoCenter.style.flexBasis = ASDimensionMake("60%")
        
        let buttonStack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 5,
            justifyContent: .spaceAround,
            alignItems: .stretch,
            children: [loginBtn, registerBtn]
        )
        
        let stack = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 0,
            justifyContent: .spaceBetween,
            alignItems: .stretch,
            children: [logoCenter, buttonStack]
        )
        
        return ASInsetLayoutSpec(insets: .init(top: 30, left: 10, bottom: 30, right: 10), child: stack)
    }
}
