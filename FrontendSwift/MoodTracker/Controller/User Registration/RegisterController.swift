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
                    
                    httpUser.registerUserHttp(
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
        if NetworkHelper.goodStatusResponseCode.contains(statusCode) {
            DispatchQueue.main.async {
                moodStore.dispatch(StoreJWTAction.init(jwt: strData))
                
                let mainVC = TabBarController()
                mainVC.modalPresentationStyle = .fullScreen
                self.present(mainVC, animated: true, completion: nil)
            }
        }
    }
    
    func didHaveError(strData: String) {
        DispatchQueue.main.async {
            let errorAlert = UIAlertController(
                title: "Error",
                message: strData,
                preferredStyle: UIAlertController.Style.alert
            )

            errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                errorAlert.dismiss(animated: true)
            }))

            self.present(errorAlert, animated: true, completion: nil)
        }
    }
}
