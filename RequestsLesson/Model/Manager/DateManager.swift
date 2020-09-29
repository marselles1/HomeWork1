//
//  DateManager.swift
//  RequestsLesson
//
//  Created by marsel on 28.08.2020.
//

import Foundation

//Main idea taken from Internet
class DateManager {
    
    var dateFormatter: DateFormatter!
    var relativeDateFormatter: RelativeDateTimeFormatter!
    
    private init() {
        
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        relativeDateFormatter = RelativeDateTimeFormatter()
        relativeDateFormatter.locale = Locale(identifier: "ru_RU")
    }
    
    //Date Manager singleton
    public static let singleton = DateManager()
    
    /// Function for reformating date of post to VK like style
    /// - Parameter date: Date of post
    func reformDate(_ date: Date) -> String {
        
        let calendar = Calendar.current
        let currentDate = Date()
        
        if calendar.compare(date, to: Date(), toGranularity: .hour) == .orderedSame {
            return relativeDateFormatter.localizedString(for: date, relativeTo: currentDate)
        } else if calendar.isDateInToday(date) {
            
            dateFormatter.dateFormat = "Сегодня в HH:mm"
            return dateFormatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            
            dateFormatter.dateFormat = "Вчера в HH:mm"
            return dateFormatter.string(from: date)
        } else {
            
            dateFormatter.dateFormat = "dd.MM.yyyy в HH:mm"
            return dateFormatter.string(from: date)
        }
    }
}
