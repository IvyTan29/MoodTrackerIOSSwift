//
//  LoginController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/29/22.
//

import Foundation
import AsyncDisplayKit
import RxSwift

class LoginController : ASDKViewController<LoginNode> {
    
    weak var pvc : UIViewController?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pvc = self.presentingViewController
        
        // Login Button
        self.node.loginBtn.rxTap
            .subscribe(
                onNext: {
                    let mainVC = TabBarController()
                    mainVC.modalPresentationStyle = .fullScreen
                    
                    let transition = CATransition()
                    transition.duration = 0.5
                    transition.type = CATransitionType.push
                    transition.subtype = CATransitionSubtype.fromRight
                    transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
                    
                    self.view.window!.layer.add(transition, forKey: kCATransition)
                    self.present(mainVC, animated: false, completion: nil)
                }
            ).disposed(by: disposeBag)
        
        // Register (Switch Button)
        self.node.registerBtn.rxTap
            .subscribe(
                onNext: {
                    self.dismiss(animated: true)
                    self.pvc?.present(RegisterController(node: RegisterNode()), animated: true, completion: nil)
                }
            ).disposed(by: disposeBag)
    }
}
