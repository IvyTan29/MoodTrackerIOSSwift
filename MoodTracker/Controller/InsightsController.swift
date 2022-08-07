//
//  SettingsController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/25/22.
//

import Foundation
import AsyncDisplayKit
import RxSwift
import ReSwift


class InsightsController : ASDKViewController<InsightsNode> {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Insights"
        self.navigationItem.backBarButtonItem = NavController.backBarButton
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: nil
        )
        self.navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(
                onNext: { tap in
                    var httpUser = HttpUser()
                    httpUser.delegate = self
                    httpUser.logOutUserHttp()
                }
            ).disposed(by: disposeBag)
        
        self.tabBarController?.tabBar.isHidden = false
        
        // Segment Control
        (self.node.dateComponentSegmentControl.view as? UISegmentedControl)?.rx.selectedSegmentIndex
            .skip(1)
            .subscribe(
                onNext: { index in
                    (self.node.moodSlider.view as? UISlider)?.value = 0
                    self.node.movedToggle = false
                    self.node.setNeedsLayout()
                }
            ).disposed(by: disposeBag)
        
        // Mood Level Slider
        (self.node.moodSlider.view as? UISlider)?.rx.value
            .skip(1)
            .subscribe(
                onNext: { [unowned self] levelValue in
                    print(levelValue)
                    let selectedIndex = (self.node.dateComponentSegmentControl.view as? UISegmentedControl)?.selectedSegmentIndex ?? 0
                    
                    self.displayLoadingScreen()
                    
                    var httpTag = HttpTag()
                    httpTag.delegate = self
                    
                    if selectedIndex == 3 {
                        httpTag.getAllInsightsTagHttp(moodValue: levelValue)
                    } else {
                        httpTag.getInsightsTagWithDateRangeHttp(
                            insightDateType: selectedIndex,
                            moodValue: levelValue
                        )
                    }
                    
                    self.node.movedToggle = true
                    self.node.setNeedsLayout()
                }
            ).disposed(by: disposeBag)
    }
    
    func displayLoadingScreen() {
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - HttpTagDelegate
extension InsightsController : HttpTagDelegate {
    func didGetInsightTags(_ statusCode: Int, _ insightTags: [TagCountJsonData]) {
        DispatchQueue.main.async {
            self.node.setUpTagFrequency(insightTags)
            self.node.setNeedsLayout()
            
            self.dismiss(animated: true)
        }
    }
}

// MARK: - HttpUserDelegate
extension InsightsController : HttpUserDelegate {
    func didLogout(_ statusCode: Int, _ strData: String) {
        DispatchQueue.main.async {
            moodStore.dispatch(StoreJWTAction.init(jwt: "")) // remove jwt token from the client side
            
            let landingVC = LandingPageController(node: LandingPageNode())
            landingVC.modalPresentationStyle = .overFullScreen
            self.present(landingVC, animated: true, completion: nil)
        }
    }
}
