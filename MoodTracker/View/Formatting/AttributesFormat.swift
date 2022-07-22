//
//  AttributesMaker.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/22/22.
//

import Foundation

struct AttributesFormat {
    
//    let tagTextFieldAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 18)!,
//                            NSAttributedString.Key.foregroundColor: UIColor.gray]
//    let recentLabelAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 22)!,
//                           NSAttributedString.Key.foregroundColor: UIColor.black]
//    let addNoteBtnAttr = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 22)!,
//                          NSAttributedString.Key.foregroundColor: UIColor.black,
//                          NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
    
    static func attributeConvert(string: String) -> NSAttributedString {
        return NSAttributedString(string: string)
    }
    
    static func attributeConvert(string: String, font: String, size: Int) {
        
    }
}
