//
//  ASButton.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/25/22.
//

import AsyncDisplayKit
import RxSwift

class ASCustomButton : ASButtonNode {
    // sya yung subject so they are the one emitting stuff
    // you can just listen in on publish subject
    fileprivate var emitTap = PublishSubject<Void>() // the subject can emit events on it such as next, complete and on error
    
    public var rxTap : Observable<Void> {
        return emitTap.asObservable() // turn this subject into an observable para whoever listens to this ASButton, can just listen to the rxTap
    }
    
    override func didLoad() {
        super.didLoad()
        self.addTarget(self, action: #selector(tapped), forControlEvents: .touchUpInside)
    }
    
    @objc func tapped() {
        emitTap.onNext(())
    }
}
