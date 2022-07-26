//
//  CustomTabBar.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/24/22.
//

import UIKit

// reference: https://fabcoding.com/2019/03/14/curved-tabbar-with-a-round-middle-button/
class CustomTabBar : UITabBar {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        return nil
    }
}
