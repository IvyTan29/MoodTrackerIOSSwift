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
                    var httpUser = HttpUser()
                    httpUser.delegate = self
                    
                    httpUser.loginUserHTTP(
                        LoginJsonData(email: self.node.emailTF.customTF.textField.text ?? "",
                             password: self.node.passwordTF.customTF.textField.text ?? "")
                    )
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

extension LoginController : HttpUserDelegate {
    func didLogin(_ statusCode: Int, _ strData: String) {
        if NetworkHelper.goodStatusResponseCode.contains(statusCode) {
            DispatchQueue.main.async {
                let mainVC = TabBarController()
                mainVC.modalPresentationStyle = .fullScreen
                
//                let transition = CATransition()
//                transition.duration = 0.5
//                transition.type = CATransitionType.push
//                transition.subtype = CATransitionSubtype.fromRight
//                transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//
//                self.view.window!.layer.add(transition, forKey: kCATransition)
                self.present(mainVC, animated: true, completion: nil)
            }
            
        } else {
            // FIXME: add error message display
            print(strData)
        }
    }
}
