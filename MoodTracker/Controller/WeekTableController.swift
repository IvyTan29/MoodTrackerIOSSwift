//
//  WeekTableController.swift
//  MoodTracker
//
//  Created by Ivy Tan on 7/27/22.
//

import Foundation
import AsyncDisplayKit
import CoreImage

protocol WeekTableControllerDelegate : AnyObject {
    func didSelectWeek(from: Date, to: Date)
}

class WeekTableController : ASDKViewController<WeekTableNode> {
    
    var weeks: [WeekRange] = []
    weak var delegate: WeekTableControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.node.weeksTable.delegate = self
        self.node.weeksTable.dataSource = self
    }
}

// MARK: - ASTableDataSource
extension WeekTableController : ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return weeks.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = WeekCell()
        let dateIntervalStr = DateFormat.dateIntervalToString(from: weeks[indexPath.row].from, to: weeks[indexPath.row].to)
        
        cell.weekRange.attributedText = NSAttributedString(
            string: dateIntervalStr,
            attributes: AttributesFormat.weekPickerAttr
        )
        
        return cell
    }
}

// MARK: - ASTableDelegate
extension WeekTableController : ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        moodStore.dispatch(FilterMoodAction.init(dateType: .weekControl,
                                                 date: self.weeks[indexPath.row].from,
                                                 toDate: self.weeks[indexPath.row].to))
        self.delegate?.didSelectWeek(from: self.weeks[indexPath.row].from, to: self.weeks[indexPath.row].to)
        self.dismiss(animated: true)
    }
}
