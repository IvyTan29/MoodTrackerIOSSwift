//
//  EntriesController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/21/22.
//

import Foundation
import AsyncDisplayKit
import ReSwift
import RxSwift
import RxCocoa

class EntriesController : ASDKViewController<EntriesNode> {
    
    private var disposeBag = DisposeBag()
    var months = ["January",
                  "February",
                  "March",
                  "April",
                  "May",
                  "June",
                  "July",
                  "August",
                  "September",
                  "October",
                  "November",
                  "December"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Entries"
        self.navigationItem.backBarButtonItem = NavController.backBarButton
        
        self.tabBarController?.tabBar.isHidden = false
        
        self.node.entryTable.delegate = self
        self.node.entryTable.dataSource = self
        self.node.entryTable.view.separatorStyle = .none
        
        (self.node.monthPicker.view as? UIPickerView)?.delegate = self
        (self.node.monthPicker.view as? UIPickerView)?.dataSource = self
        
        self.node.noEntriesLabel.attributedText = NSAttributedString(string: "\(moodStore.state.moodList.count) Entries", attributes: AttributesFormat.numEntryAttr)
        
        (self.node.calendarSegmentControl.view as? UISegmentedControl)?.rx.selectedSegmentIndex
            .subscribe(
                onNext: { [unowned self] index in
                    switch index {
                    case 0:
                        self.node.dateType = .day
                    case 1:
                        self.node.dateType = .week
                    case 2:
                        self.node.dateType = .month
                    default:
                        self.node.dateType = .all
                    }
                    
                    self.node.setNeedsLayout()
                }
            ).disposed(by: disposeBag)
    }
}

// MARK: - ASTableDataSource
extension EntriesController : ASTableDataSource {
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return moodStore.state.moodList.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = EntryCell(tagStrSet: moodStore.state.moodList[indexPath.row].tags ?? [])
        
        cell.designCell()
        
        cell.timeLabel.attributedText = NSAttributedString(string: DateFormat.dateFormatToString(format: "h:mm a", date: moodStore.state.moodList[indexPath.row].dateTime ?? Date()), attributes: AttributesFormat.timeLabelAttr)
        (cell.moodSlider.view as? UISlider)?.value = moodStore.state.moodList[indexPath.row].moodValue ?? 0
        
        cell.indexPathInCell = indexPath
        cell.delegate = self

        return cell
    }
}

// MARK: - ASTableDelegate
extension EntriesController : ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        
        let editor = AddEditEntryController(node: AddEditEntryNode())
        editor.load(indexPath)
        
//        editor.delegate = self
        self.navigationController?.pushViewController(editor, animated: true)
    }
}

// MARK: - EntryCellDelegate
extension EntriesController : EntryCellDelegate {
    func didDisplayNote(index: IndexPath) {
        let noteEditor = AddNoteController(node: AddNoteNode())
        noteEditor.load(index, .display)
        
        self.navigationController?.pushViewController(noteEditor, animated: true)
    }
}

// MARK: - StoreSubscriber
extension EntriesController : StoreSubscriber {
    override func viewWillAppear(_ animated: Bool) {
       moodStore.subscribe(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
       moodStore.unsubscribe(self)
    }

    func newState(state: MoodState) {
        self.node.entryTable.reloadData()
        self.node.noEntriesLabel.attributedText = NSAttributedString(string: "\(moodStore.state.moodList.count) Entries", attributes: AttributesFormat.numEntryAttr)
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate (For PickerView)
extension EntriesController : UIPickerViewDataSource, UIPickerViewDelegate {
    // Sets number of columns in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    // Sets the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.months.count
    }
    
    // This function sets the text of the picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.months[row]
    }
    
    // when a row in the picker is selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // TODO: -
    }

}
