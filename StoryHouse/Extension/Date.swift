//
//  Date.swift
//  Astronme
//
//  Created by KMSOFT on 12/11/20.
//  Copyright © 2020 Logileap. All rights reserved.
//

import Foundation
extension Date {
    
    func subtract(year: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: -1 * year, to: self) ?? Date()
    }
    
    func year() -> Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
    }
    
    func month() -> Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: self)
    }
    
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    func removeTimeStamp() -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
    
    func adding(_ component: Calendar.Component, value: Int, using calendar: Calendar = .current) -> Date {
        calendar.date(byAdding: component, value: value, to: self)!
    }
    
    var age: Int { Calendar.current.dateComponents([.year], from: self, to: Date()).year! }
    
    
    var toFullDateString: String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = appFullDateFormat
        return dateFormat.string(from: self)
    }
    
    var toStringYYYYMMDD: String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = YYYYMMDD
        return dateFormat.string(from: self)
    }
    
    var toDateString: String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = appDateFormat
        return dateFormat.string(from: self)
    }
    
    
    var toTimeString: String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = appTimeFormat
        return dateFormat.string(from: self)
    }
    
    var toTimeStamp: Double {
        return self.timeIntervalSince1970 * 1000.0
    }
    
    func convertDate(format: String!) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateObj = dateFormatter.string(from: self)
        return dateFormatter.date(from: dateObj)!
    }
    
    func convertDateString(format: String!) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func previousWeek() -> Date {
        return self.addingTimeInterval(-7*24*60*60)
    }
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
    static func today() -> Date {
        return Date()
    }
    
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Next,
                   weekday,
                   considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = DateComponents()
        nextDateComponent.weekday = searchWeekdayIndex
        
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
    
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case Next
        case Previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .Next:
                return .forward
            case .Previous:
                return .backward
            }
        }
    }
    
    func getISO8601Date() -> String {
        let isoDateFormatter = ISO8601DateFormatter()
        print("ISO8601 string: \(isoDateFormatter.string(from: self))")
        let iso8601String = isoDateFormatter.string(from: self)
        return iso8601String
    }
    
    func startOfDate() -> Date {
        let startOfDate = Calendar.current.startOfDay(for: self)
        return startOfDate
    }
    
    var yearsFromNow: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
    var monthsFromNow: Int {
        return Calendar.current.dateComponents([.month], from: self, to: Date()).month!
    }
    var weeksFromNow: Int {
        return Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear!
    }
    var daysFromNow: Int {
        return Calendar.current.dateComponents([.day], from: self, to: Date()).day!
    }
    
    var isInToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    var isInYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    var hoursFromNow: Int {
        return Calendar.current.dateComponents([.hour], from: self, to: Date()).hour!
    }
    var minutesFromNow: Int {
        return Calendar.current.dateComponents([.minute], from: self, to: Date()).minute!
    }
    var secondsFromNow: Int {
        return Calendar.current.dateComponents([.second], from: self, to: Date()).second!
    }
    var relativeTime: String {
        //if yearsFromNow > 0 { return "\(yearsFromNow) year" + (yearsFromNow > 1 ? "s" : "") + " ago" }
        //if monthsFromNow > 0 { return "\(monthsFromNow) month" + (monthsFromNow > 1 ? "s" : "") + " ago" }
        //if weeksFromNow > 0 { return "\(weeksFromNow) week" + (weeksFromNow > 1 ? "s" : "") + " ago" }
        if isInYesterday { return "Yesterday" }
        if daysFromNow > 0 { return "\(daysFromNow) day" + (daysFromNow > 1 ? "s" : "") + " ago" }
        if hoursFromNow > 0 { return "\(hoursFromNow) hour" + (hoursFromNow > 1 ? "s" : "") + " ago" }
        if minutesFromNow > 0 { return "\(minutesFromNow) min" + (minutesFromNow > 1 ? "s" : "") + " ago" }
        if secondsFromNow > 0 { return secondsFromNow < 15 ? "Just now"
            : "\(secondsFromNow) " + (secondsFromNow > 1 ? "s" : "") + " ago"}
        return ""
    }
    
    var timeString: String {
        if isInToday { return "Today"}
        if isInYesterday { return "Yesterday" }
        return self.convertDateString(format: "MMMM dd, yyyy")
    }
    
    var requestRelativeTime: String {
        //if yearsFromNow > 0 { return "\(yearsFromNow) year" + (yearsFromNow > 1 ? "s" : "") + " ago" }
        //if monthsFromNow > 0 { return "\(monthsFromNow) month" + (monthsFromNow > 1 ? "s" : "") + " ago" }
        if weeksFromNow > 2 { return toFullDateString }
        if weeksFromNow > 0 { return "\(weeksFromNow) week" + (weeksFromNow > 1 ? "s" : "") + " ago" }
        if isInYesterday { return "Yesterday" }
        if daysFromNow > 0 { return "\(daysFromNow) day" + (daysFromNow > 1 ? "s" : "") + " ago" }
        if hoursFromNow > 0 { return "\(hoursFromNow) hour" + (hoursFromNow > 1 ? "s" : "") + " ago" }
        if minutesFromNow > 0 { return "\(minutesFromNow) min" + (minutesFromNow > 1 ? "s" : "") + " ago" }
        if secondsFromNow > 0 { return secondsFromNow < 15 ? "Just now"
            : "\(secondsFromNow) " + (secondsFromNow > 1 ? "s" : "") + " ago"}
        return ""
    }
    
}
