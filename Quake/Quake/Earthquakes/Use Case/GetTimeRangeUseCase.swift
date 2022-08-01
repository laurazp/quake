//
//  GetTimeRangeUseCase.swift
//  Quake
//
//  Created by Laura Zafra Prat on 1/8/22.
//

import Foundation

struct GetTimeRangeUseCase {
    private let dateFormatterGet = DateFormatter()
    private let endTime = Date.now

    func getTimeRange(days: Int) -> (start: String, end: String) {
        return (getStartTimeString(days: days), getEndTimeString())
    }
    
    private func getStartTimeString(days: Int) -> String {
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let startTime = Calendar.current.date(byAdding: .day, value: -days, to: endTime) ?? Date.distantPast
        let startTimeString = dateFormatterGet.string(from: startTime)
        return startTimeString
    }
    
    private func getEndTimeString() -> String {
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let endTimeString = dateFormatterGet.string(from: endTime)
        return endTimeString
    }
}
