//
//  RegisterController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/29/22.
//

import Foundation
import AsyncDisplayKit
import RxSwift

class RegisterController : ASDKViewController<RegisterNode> {
    
    weak var pvc : UIViewController?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pvc = self.presentingViewController
        
        // Done with the registration
        self.node.registerBtn.rxTap
            .subscribe(
                onNext: {
                    var httpUser = HttpUser()
                    httpUser.delegate = self
                    
                    httpUser.registerUserHTTP(
                        UserJsonData(name: self.node.nameTF.customTF.textField.text ?? "",
                             email: self.node.emailTF.customTF.textField.text ?? "",
                             password: self.node.passwordTF.customTF.textField.text ?? "",
                             entries: [],
                             tags: [])
                    )
                }
            ).disposed(by: disposeBag)
        
        // Login (Switch Button)
        self.node.loginBtn.rxTap
            .subscribe(
                onNext: {
                    self.dismiss(animated: true)
                    self.pvc?.present(LoginController(node: LoginNode()), animated: true, completion: nil)
                }
            ).disposed(by: disposeBag)
    }
}

extension RegisterController : HttpUserDelegate {
    func didRegister(_ statusCode: Int, _ strData: String) {
        print(statusCode)
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
        } else if statusCode == 404 {
            print(strData)
            // FIXME: add error message display
        }
    }
}
