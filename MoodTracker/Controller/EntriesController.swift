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
    var months: [String] = []
    
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
        
        // Calendar Segment Control
        (self.node.calendarSegmentControl.view as? UISegmentedControl)?.rx.selectedSegmentIndex
            .subscribe(
                onNext: { [unowned self] index in
                    switch index {
                    case 0:
                        self.node.dateType = .dayControl
                        moodStore.dispatch(FilterMoodAction.init(dateType: self.node.dateType,
                                                                 date: (self.node.dayDatePicker.view as? UIDatePicker)?.date))
                    case 1:
                        self.node.dateType = .weekControl
                        
                        
                    case 2:
                        self.node.dateType = .monthControl
                        
                        let index = (self.node.monthPicker.view as? UIPickerView)?.selectedRow(inComponent: 0) ?? 0
                        moodStore.dispatch(FilterMoodAction.init(dateType: self.node.dateType,
                                                                 string: months[index]))
                    default:
                        self.node.dateType = .allControl
                        moodStore.dispatch(FilterMoodAction.init(dateType: self.node.dateType))
                    }
                    
                    self.node.setNeedsLayout()
                }
            ).disposed(by: disposeBag)
        
        // Day Date Picker
        (self.node.dayDatePicker.view as? UIDatePicker)?.rx.date
            .distinctUntilChanged()
            .subscribe(
                onNext: { date in
                    moodStore.dispatch(FilterMoodAction.init(dateType: .dayControl,
                                                             date: date))
                }
            ).disposed(by: disposeBag)
        
        self.populateLast12Months()
        
        // select the latest month
        (self.node.monthPicker.view as? UIPickerView)?.selectRow(self.months.count - 1, inComponent: 0, animated: true)
        
        moodStore.dispatch(FilterMoodAction.init(dateType: .dayControl, date: Date()))
    }
}

// MARK: - ASTableDataSource
extension EntriesController : ASTableDataSource {
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return moodStore.state.filterMoodList.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = EntryCell(tagStrSet: moodStore.state.filterMoodList[indexPath.row].tags ?? [])
        
        cell.designCell()
        
        cell.timeLabel.attributedText = NSAttributedString(string: DateFormat.dateFormatToString(format: "h:mm a", date: moodStore.state.filterMoodList[indexPath.row].dateTime ?? Date()), attributes: AttributesFormat.timeLabelAttr)
        (cell.moodSlider.view as? UISlider)?.value = moodStore.state.filterMoodList[indexPath.row].moodValue ?? 0
        
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
        self.node.noEntriesLabel.attributedText = NSAttributedString(string: "\(moodStore.state.filterMoodList.count) Entries", attributes: AttributesFormat.numEntryAttr)
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate (For PickerView)
extension EntriesController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func populateLast12Months() {
        let firstDayComponent = DateComponents(day: 1) // first day ng month
        var last12Months: [Date] = []

        Calendar.current.enumerateDates(startingAfter: Date(),
                                        matching: firstDayComponent,
                                        matchingPolicy: .nextTime,
                                        direction: .backward,
                                        using: { (date, idx, stop) in
                                            if let date = date {
                                                last12Months.append(date)
                                            }
            
                                            if last12Months.count == 12 {
                                                stop = true
                                            }
        })

        self.months = last12Months.map({ DateFormat.dateFormatToString(format: "MMMM yyyy", date: $0)})
        self.months.reverse()
    }
    
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
