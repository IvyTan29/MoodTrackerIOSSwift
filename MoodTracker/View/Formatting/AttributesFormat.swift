//
//  AttributesMaker.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/22/22.
//

import Foundation
import UIKit

struct AttributesFormat {
    
    static let todayBtnAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 22)!,
                        NSAttributedString.Key.foregroundColor: UIColor(named: "BlueBase") as Any,
                        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                        NSAttributedString.Key.underlineColor: UIColor.lightGray] as [NSAttributedString.Key : Any]
    
    static let myMoodAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 30)!,
                     NSAttributedString.Key.foregroundColor: UIColor.label]
    
    static let moodLevelAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 12)!,
                                NSAttributedString.Key.foregroundColor: UIColor.black]
    
    static let tagLabelAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 20)!,
                         NSAttributedString.Key.foregroundColor: UIColor.gray]
    
    static let tagPickBtnAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 20)!,
                                NSAttributedString.Key.foregroundColor: UIColor(named: "OrangeSecondary")]
    
    static let tagBtnAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 20)!,
                         NSAttributedString.Key.foregroundColor: UIColor.black]
    
    static let addTagTFAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 18)!,
                            NSAttributedString.Key.foregroundColor: UIColor.gray]
    
    static let addTagBtnAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 18)!,
                        NSAttributedString.Key.foregroundColor: UIColor(named: "BlueBase") as Any] as [NSAttributedString.Key : Any]
    
    static let recentLabelAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 22)!,
                           NSAttributedString.Key.foregroundColor: UIColor.black]
    
    static let addNoteBtnAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 22)!,
                          NSAttributedString.Key.foregroundColor: UIColor.black,
                          NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
    
    static let proceedBtnAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 22)!,
                              NSAttributedString.Key.foregroundColor: UIColor.white]
    
    static let cancelBtnAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 18)!,
                                NSAttributedString.Key.foregroundColor: UIColor.gray,
                                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
    
    static let numEntryAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 18)!,
                       NSAttributedString.Key.foregroundColor: UIColor.lightGray as Any] as [NSAttributedString.Key : Any]
    
    static let timeLabelAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir-Black", size: 22)!,
                        NSAttributedString.Key.foregroundColor: UIColor(named: "BlueBase") as Any] as [NSAttributedString.Key : Any]
    
    
    
    
    static func attributeConvert(string: String) -> NSAttributedString {
        return NSAttributedString(string: string)
    }
    
    static func attributeFontSizeColor(string: String,
                                       font: String,
                                       size: CGFloat,
                                       fontColor: UIColor,
                                       isUnderline: Bool,
                                       underlineColor: UIColor?) -> NSAttributedString {
        
        var attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: "\(font)", size: size) as Any,
                          NSAttributedString.Key.foregroundColor: fontColor]
        
        if isUnderline {
            attributes[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        
        if let underlineColor = underlineColor {
            attributes[NSAttributedString.Key.underlineColor] = underlineColor
        }
        
        return NSAttributedString(string: string, attributes: attributes as [NSAttributedString.Key : Any])
    }
}
