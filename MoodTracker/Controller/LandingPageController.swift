//
//  LandingPageController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/29/22.
//

import Foundation
import AsyncDisplayKit
import RxSwift

class LandingPageController : ASDKViewController<LandingPageNode> {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For Login Button
        self.node.loginBtn.rxTap
            .subscribe(
                onNext: {
                    self.present(LoginController(node: LoginNode()), animated: true, completion: nil)
                }
            ).disposed(by: disposeBag)
        
        // For Register Button
        self.node.registerBtn.rxTap
            .subscribe(
                onNext: {
                    self.present(RegisterController(node: RegisterNode()), animated: true, completion: nil)
                }
            ).disposed(by: disposeBag)
    }
    
    
}
