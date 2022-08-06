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
    func didSelectWeek(from: Date, to: Date, weekIndex: Int)
}

class WeekTableController : ASDKViewController<WeekTableNode> {
    
    var weeks: [WeekRange] = []
    weak var delegate: WeekTableControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.node.weeksTable.delegate = self
        self.node.weeksTable.dataSource = self
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
        self.delegate?.didSelectWeek(from: self.weeks[indexPath.row].from, to: self.weeks[indexPath.row].to, weekIndex: indexPath.row)
        self.dismiss(animated: true)
        
        self.displayLoadingScreen()
        
        var httpEntry = HttpEntry()
        httpEntry.delegate = self
        httpEntry.getEntriesWithDateRangeHTTP(
            dateType: .weekControl,
            fromDate: Calendar.current.startOfDay(for: self.weeks[indexPath.row].from)
        )
    }
}

// MARK: - HttpEntryDelegate
extension WeekTableController : HttpEntryDelegate {
    func didGetEntries(_ statusCode: Int, _ entries: [MoodLog], _ dateType: DateType, _ fromDate: Date) {
        if NetworkHelper.goodStatusResponseCode.contains(statusCode) {
            DispatchQueue.main.async {
                moodStore.dispatch(UpdateEntriesAction.init(
                    entriesArray: entries,
                    dateType: dateType,
                    date: fromDate
                ))
                
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}
