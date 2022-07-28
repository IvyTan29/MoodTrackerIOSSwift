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
                    moodStore.dispatch(GetInsightsAction.init(
                        insightDateType: (self.node.dateComponentSegmentControl.view as? UISegmentedControl)?.selectedSegmentIndex ?? 0,
                        moodLevel: levelValue
                    ))
                    
                    self.node.movedToggle = true
                    self.node.setNeedsLayout()
                }
            ).disposed(by: disposeBag)
    }
}

extension InsightsController : StoreSubscriber {
    override func viewWillAppear(_ animated: Bool) {
       moodStore.subscribe(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
       moodStore.unsubscribe(self)
    }

    func newState(state: MoodState) {
        print("NEW STATE IN INSIGHT CONTROLLER")
        self.node.setUpTagFrequency()
        self.node.setNeedsLayout()
    }
}
