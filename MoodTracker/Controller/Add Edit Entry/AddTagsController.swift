//
//  AddTagsController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/20/22.
//

import Foundation
import AsyncDisplayKit
import RxSwift
import ReSwift
import RxCocoa

class AddTagsController : ASDKViewController<AddTagNode> {
    
    var indexPath: IndexPath?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let index = self.indexPath {
            self.navigationItem.title = "Edit Tags"
            moodStore.dispatch(EditorNoteAction.init(note: moodStore.state.allMoodList[index.row].note ?? "",
                                                     index: index))
        } else {
            self.navigationItem.title = "Add Tags"
        }
        
        self.navigationItem.backBarButtonItem = NavController.backBarButton
        
        self.tabBarController?.tabBar.isHidden = true
        
        // for done button on the upper right
        self.node.doneBtn.rxTap
            .subscribe(
                onNext: { [unowned self] tap in
                    self.donePressed()
                }
            ).disposed(by: disposeBag)
        
        // for the cancel button
        self.node.cancelBtn.rxTap
            .subscribe(
                onNext: { [unowned self] tap in
                    self.navigationController?.popToRootViewController(animated: true)
                    self.tabBarController?.tabBar.isHidden = false
                }
            ).disposed(by: disposeBag)

        // for the add note button
        self.node.addNoteBtn.rxTap
            .subscribe(
                onNext: { [unowned self] tap in
                    self.addNotePressed()
                }
            ).disposed(by: disposeBag)
        
        // for the add tag button from text field
        self.node.addTagBtn.rxTap
            .subscribe(
                onNext: { [unowned self] tap in
                    let string = self.node.tagTextField.textView.text
                    self.node.tagTextField.textView.text = ""
                    self.node.tagTextField.style.height = .init(unit: .points, value: 40)
                    
                    if let string = string {
                        if string != "" {
                            self.addChosenFromTableAndTF(string: string)
                            moodStore.dispatch(AddTagAction.init(tagStr: string))
                        }
                    }
                }
            ).disposed(by: disposeBag)
        
        // for the adding custom tag text field
        self.node.tagTextField.textView.rx.text
            .map { $0 ?? "" }
            .map { $0.isEmpty }
            .distinctUntilChanged() // para if false, and then you type, and then false parin, it won't keep listening (it will only listen if may change sa value (false to true for example)
            .subscribe(
                onNext: { [unowned self] isEmpty in
                    self.node.isHiddenAddTagBtn = isEmpty
                    self.node.setNeedsLayout()
                }
            ).disposed(by: disposeBag)
        
        // for the more tags ("...") button
        self.node.moreTagsBtn.rxTap
            .subscribe(
                onNext: { [unowned self] tap in
                    let vc = TagTableController(node: TagTableNode())
                    vc.delegate = self
                    self.present(vc, animated: true)
                }
            ).disposed(by: disposeBag)
        
        moodStore.dispatch(InitializeTagAction.init())
        
        // for editing purposes
        if let indexPath = self.indexPath {
            moodStore.dispatch(InitializeTagsEditAction(index: indexPath))
        }
        
        self.node.loadFirstRecentTags()
        
        self.assignActionForRecentTags()
        self.assignActionForChosenTags()
        self.node.setMoreTagBtn()
    }
    
    func donePressed() {
        moodStore.dispatch(EditorTagsAction.init())
        
        var httpEntry = HttpEntry()
        httpEntry.delegate = self
        
        if let indexPath = self.indexPath {
            moodStore.dispatch(EditMoodAction.init(index: indexPath))
        } else {
            httpEntry.postEntryHTTP(moodStore.state.editorMood ?? MoodLog())
            moodStore.dispatch(AddMoodAction.init())
        }
        
        moodStore.dispatch(FilterMoodAction.init(
            dateType: moodStore.state.dateTypeFilter,
            date: moodStore.state.dateFilter)
        )
        
        self.navigationController?.popToRootViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func addNotePressed() {
        let editorNote = AddNoteController(node: AddNoteNode())
        
        // for editing purposes
        if let safeIndexPath = self.indexPath {
            editorNote.load(safeIndexPath, Note.edit)
        } else {
            editorNote.load(nil, Note.add)
        }

        self.navigationController?.pushViewController(editorNote, animated: true)
    }
    
    func load(_ indexPath: IndexPath) {
        self.indexPath = indexPath
    }
    
    func assignActionForRecentTags() {
        self.node.tagBtns.forEach({ button in
            assignActionForRecentTag(button)
        })
    }
    
    func assignActionForChosenTags() {
        self.node.chosenTagBtns.forEach({ button in
            assignActionForChosenTag(button)
        })
    }
    
    func assignActionForRecentTag(_ button : ASCustomButton) {
        button.rxTap
            .subscribe(
                onNext: { [unowned self] tap in
                    self.removeRecentTagButton(asButton: button)
                    moodStore.dispatch(AddTagAction.init(tagStr:  button.attributedTitle(for: .normal)?.string ?? ""))
                }
            ).disposed(by: disposeBag)
    }
    
    func assignActionForChosenTag(_ button : ASCustomButton) {
        button.rxTap
            .subscribe(
                onNext: { [unowned self] tap in
                    self.removeChosenTagButton(asButton: button)
                    moodStore.dispatch(DeleteTagAction.init(tagStr: button.attributedTitle(for: .normal)?.string ?? ""))
                }
            ).disposed(by: disposeBag)
    }
    
    func addChosenFromTableAndTF(string: String) {
        if !(moodStore.state?.chosenTags.contains(string.capitalized) ?? false) {
            let chosenBtn = self.node.createChosenTagBtn(string)
            assignActionForChosenTag(chosenBtn)
            self.node.chosenTagBtns.append(chosenBtn)
            
            // FIXME: - remove button from tag
//            self.node.tagBtns.remove(c)
        }
    }
    
    func removeChosenTagButton(asButton: ASCustomButton) {
        if let idx = self.node.chosenTagBtns.firstIndex(where: { $0 === asButton }) {
            self.node.chosenTagBtns.remove(at: idx)
            
            if let string = asButton.attributedTitle(for: .normal)?.string {
                let isRecent = moodStore.state.tagsDict[string] ?? false
                    
                if isRecent {
                    let recentBtn = self.node.createRecentTagBtn(string)
                    assignActionForRecentTag(recentBtn)
                    self.node.tagBtns.insert(recentBtn, at: self.node.tagBtns.count - 1)
                }
            }
        }
    }
    
    func removeRecentTagButton(asButton: ASCustomButton) {
        if let idx = self.node.tagBtns.firstIndex(where: { $0 === asButton }) {
            self.node.tagBtns.remove(at: idx)
            
            if let string = asButton.attributedTitle(for: .normal)?.string {
                if !(moodStore.state?.chosenTags.contains(string.capitalized) ?? false) {
                    let chosenBtn = self.node.createChosenTagBtn(string)
                    assignActionForChosenTag(chosenBtn)
                    self.node.chosenTagBtns.append(chosenBtn)
                }
            }
        }
    }
}

// MARK: - StoreSubscriber
extension AddTagsController : StoreSubscriber {
    override func viewWillAppear(_ animated: Bool) {
       moodStore.subscribe(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
       moodStore.unsubscribe(self)
    }

    func newState(state: MoodState) {
        print("NEW STATE IN ADD TAGS CONTROLLER")
        
        self.node.setNeedsLayout()
    }
}

// MARK: - TagTableDelegate
extension AddTagsController : TagTableDelegate {
    func didClickTagInTable(tagStr: String) {
        self.addChosenFromTableAndTF(string: tagStr)
    }
}

// MARK: - HttpEntryDelegate
extension AddTagsController : HttpEntryDelegate {
    func didAddEntry(_ statusCode: Int, _ entryId: String) {
        if statusCode == 201 {
            // FIXME: add tag?
            var httpTag = HttpTag()
//            httpTag.delegate = self
//            httpTag.addTagsToUserAndEntryHttp(<#T##String#>, <#T##[Tag]#>)
            print(entryId)
        }
    }
}

// MARK: - HttpTagDelegate
extension AddTagsController : HttpTagDelegate {
    func didGetRecentTags(_ statusCode: Int, _ tags: Set<String>) {
        if statusCode == 201 {
            // FIXME: add tag?
            var httpTag = HttpTag()
//            httpTag.delegate = self
//            httpTag.addTagsToUserAndEntryHttp(<#T##String#>, <#T##[Tag]#>)
        }
    }
}


