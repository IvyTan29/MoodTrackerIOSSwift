//
//  AttributesMaker.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/22/22.
//

import Foundation
import UIKit

struct AttributesFormat {
    
    //    let addNoteBtnAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 22)!,
    //                          NSAttributedString.Key.foregroundColor: UIColor.black,
    //                          NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
    
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
