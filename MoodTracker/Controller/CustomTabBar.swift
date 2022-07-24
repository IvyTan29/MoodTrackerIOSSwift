//
//  CustomTabBar.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/23/22.
//

import UIKit

// reference: https://keyhan-kam.medium.com/tabbar-with-raised-middle-button-swift-132ab62c7911
class CustomTabBar : UITabBar {
    var didTapButton: (() -> ())?
    
    public lazy var middleButton: UIButton! = {
        let middleButton = UIButton()
        
        middleButton.frame.size = CGSize(width: 48, height: 48)
        print("DID THIS")
        
        let image = UIImage(systemName: "plus")!
        middleButton.setImage(image, for: .normal)
        middleButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        middleButton.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.4117647059, blue: 0.3803921569, alpha: 1)
//            .systemBackground
        middleButton.tintColor = .white
//        UIColor(named: "BlueBase")
        middleButton.layer.cornerRadius = 8
        
        middleButton.addTarget(self, action: #selector(middleButtonAction), for: .touchUpInside)
        
        self.addSubview(middleButton)
        
        return middleButton
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.4
        self.layer.masksToBounds = false
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // place the button in the middle of the tab bar
        middleButton.center = CGPoint(x: frame.width / 2, y: -5)
    }
    
    @objc func middleButtonAction(sender: UIButton) {
        didTapButton?()
        print("pressed")
    }
    
    // for the middle button to be able to tap outside the bounds since it's raised a little higher
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }

        return self.middleButton.frame.contains(point) ? self.middleButton : super.hitTest(point, with: event)
    }
    
}
