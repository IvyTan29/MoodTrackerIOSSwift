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
    var httpTag = HttpTag()
    
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
                            moodStore.dispatch(AddTagAction.init(tag:
                                Tag(
                                    name: string,
                                    recent: 1)
                                )
                            )
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
        
        self.displayLoadingScreen()
        httpTag.delegate = self
        httpTag.getRecentTagsHttp()
    }
    
    func displayLoadingScreen() {
        // LOADING SCREEN
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        self.present(alert, animated: true, completion: nil)
    }
    
    func donePressed() {
        self.displayLoadingScreen()
        
        var httpEntry = HttpEntry()
        httpEntry.delegate = self
        
        print(moodStore.state.editorMood)
        if let indexPath = self.indexPath {
            httpEntry.putEntryHTTP(indexPath, moodStore.state.editorMood ?? MoodLog())
        } else {
            httpEntry.postEntryHTTP(moodStore.state.editorMood ?? MoodLog())
        }
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
            button.view.tag = 1
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
                    moodStore.dispatch(AddTagAction.init(
                        tag: Tag(name: button.attributedTitle(for: .normal)?.string ?? "",
                                 recent: 1)
                    ))
                }
            ).disposed(by: disposeBag)
    }
    
    func assignActionForChosenTag(_ button : ASCustomButton) {
        button.rxTap
            .subscribe(
                onNext: { [unowned self] tap in
                    print(button.view.tag)
                    
                    self.removeChosenTagButton(asButton: button)
                    
                    
                    moodStore.dispatch(DeleteTagAction.init(
                        tag: Tag(name: button.attributedTitle(for: .normal)?.string ?? "",
                                 recent: button.view.tag)
                    ))
                }
            ).disposed(by: disposeBag)
    }
    
    func addChosenFromTableAndTF(string: String) {
//        if !(moodStore.state?.chosenTags.contains(string.capitalized) ?? false) {
        let chosenBtn = self.node.createChosenTagBtn(string)
        chosenBtn.view.tag = 0
        assignActionForChosenTag(chosenBtn)
        self.node.chosenTagBtns.append(chosenBtn)
            
            // FIXME: - remove button from tag
//            self.node.tagBtns.remove(c)
//        }
    }
    
    func removeChosenTagButton(asButton: ASCustomButton) {
        if let idx = self.node.chosenTagBtns.firstIndex(where: { $0 === asButton }) {
            self.node.chosenTagBtns.remove(at: idx)
            
            if let string = asButton.attributedTitle(for: .normal)?.string {
                if asButton.view.tag == 1 {
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
//                if !(moodStore.state?.chosenTags.contains(string.capitalized) ?? false) {
                let chosenBtn = self.node.createChosenTagBtn(string)
                chosenBtn.view.tag = 1
                assignActionForChosenTag(chosenBtn)
                self.node.chosenTagBtns.append(chosenBtn)
//                }
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
    func didAddEntry(_ statusCode: Int, _ entryJsonData: EntryJsonData) {
        if NetworkHelper.goodStatusResponseCode.contains(statusCode) {
            var newChosen = [TagJsonData]()
            
            moodStore.state.chosenTags.forEach({tag in
                newChosen.append(TagJsonData(_id: nil,
                                             name: tag.name,
                                             dateTime: entryJsonData.dateTime,
                                             moodValue: entryJsonData.moodValue,
                                             recent: tag.recent))
            })
            
            var httpTag = HttpTag()
            httpTag.delegate = self
            httpTag.postTagsToUserAndEntryHttp(entryJsonData._id ?? "", newChosen)
        }
    }
    
    func didEditEntry(_ statusCode: Int, _ entryJsonData: EntryJsonData, _ indexPath: IndexPath) {
        if NetworkHelper.goodStatusResponseCode.contains(statusCode) {
            var newChosen = [TagJsonData]()
            
            print("HERE IN ADD TAGS \(moodStore.state.chosenTags)")
            
            moodStore.state.chosenTags.forEach({tag in
                newChosen.append(TagJsonData(_id: nil,
                                             name: tag.name,
                                             dateTime: entryJsonData.dateTime,
                                             moodValue: entryJsonData.moodValue,
                                             recent: tag.recent))
            })
            
            var httpTag = HttpTag()
            httpTag.delegate = self
            httpTag.putTagsToUserAndEntryHttp(entryJsonData._id ?? "", newChosen, indexPath)
        } else {
            DispatchQueue.main.async {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}

// MARK: - HttpTagDelegate
extension AddTagsController : HttpTagDelegate {
    func didGetRecentTags(_ statusCode: Int, _ tags: Set<Tag>) {
        if NetworkHelper.goodStatusResponseCode.contains(statusCode) {
            DispatchQueue.main.async {
                moodStore.dispatch(InitializeRecentTagAction.init(recentTags: tags))
                
                self.httpTag.getTableTagsHttp()
            }
        }
    }
    
    func didGetTableTags(_ statusCode: Int, _ tags: Set<Tag>) {
        if NetworkHelper.goodStatusResponseCode.contains(statusCode) {
            DispatchQueue.main.async {
                moodStore.dispatch(InitializeTableTagAction.init(tableTags: tags))
                
                // for editing purposes
                if let indexPath = self.indexPath {
                    moodStore.dispatch(InitializeTagsEditAction(index: indexPath))
                    print(moodStore.state.chosenTags)
                    self.node.setChosenTagButton()
                    self.assignActionForChosenTags()
                }
                
                self.node.setRecentTagBtn()
                self.assignActionForRecentTags()
                self.node.setMoreTagBtn()
                
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    func didAddTags(_ statusCode: Int, _ strData: String) {
        if NetworkHelper.goodStatusResponseCode.contains(statusCode) {
            DispatchQueue.main.async {
                moodStore.dispatch(EditorTagsAction.init())
                moodStore.dispatch(AddMoodAction.init())
                
                moodStore.dispatch(FilterMoodAction.init(
                    dateType: moodStore.state.dateTypeFilter,
                    date: moodStore.state.dateFilter)
                )
                
                self.dismiss(animated: false, completion: nil)
                self.navigationController?.popToRootViewController(animated: true)
                self.tabBarController?.tabBar.isHidden = false
            }
        } else {
            DispatchQueue.main.async {
                print(strData)
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    func didEditTags(_ statusCode: Int, _ strData: String, _ indexPath: IndexPath) {
        if NetworkHelper.goodStatusResponseCode.contains(statusCode) {
            DispatchQueue.main.async {
                print("EDIT TAGS")
                moodStore.dispatch(EditorTagsAction.init())
                moodStore.dispatch(EditMoodAction.init(index: indexPath))
                
                moodStore.dispatch(FilterMoodAction.init(
                    dateType: moodStore.state.dateTypeFilter,
                    date: moodStore.state.dateFilter)
                )
                
                self.dismiss(animated: false, completion: nil)
                self.navigationController?.popToRootViewController(animated: true)
                self.tabBarController?.tabBar.isHidden = false
            }
        } else {
            DispatchQueue.main.async {
                print(strData)
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}


