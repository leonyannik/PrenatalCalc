//
//  Date.swift
//
//  Created by León Yannik López Rojas on 4/18/16.
//  Copyright © 2016 liÖn. All rights reserved.
//

import Foundation
//MARK: Custom date formater
/**
 ## LYDate
 Is a class for creating dates from user input and managing readable string outputs from those dates.
 
 ### Function: Create an Date from user imput:
 - from
 ````
 Date.funcName(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date{
 }
 ````
 
  ### Functions: Types of string output dates:
 
 - toStringDate | "16/9/1986" |
 - toStringDateNormal  | "Sep 16, 1986" |
 - toStringTime  | "01:08 PM" |
 - toStringSimpleTime24 | "1:06 PM" |
 - toStringTime24 | "13:06" |
 - toStringWeekDay | "Fri" |
 - toStringNumberDate | "31" |
 - toStringDayMonthDay | "Wednesday, Sep. 31" |
 - toStringWhen  | "Today" |
 
 ````
 Date.funcName(Date) -> String{
 }
 ````
 ### Function: Int output dates:
 - toIntDay  | 31 |
 - toIntMonth  | 12 |
 - toIntYear  | 1986 |
 ````
 Date.funcName(Date) -> Int{
 }
 ````
 - Author: León Yannik López Rojas
 - Date: April 2016
 - Version: 2.0
 - Note: Clean revision woe
 */
class LYDate {
    //MARK:- Create a Date instance with input data
/**
     # from
     Receives the user inputs in type of Int to create an Date
     
     - parameter year: Int(): Is the year.
     - parameter month Int(): Is the month.
     - parameter day Int(): Is the day.
     - parameter hour Int(): Optional Is the hour, by default the value is 12.
     - parameter minute Int(): Optional Is the minute, by default the value is 00.
     - Requires: User input
     - returns: a String
*/
   class func from(year:Int, month: Int, day: Int, hour: Int = 12, minute: Int = 00) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    components.hour = hour
    components.minute = minute
    let calendar = Calendar(identifier: .gregorian)
    let date = calendar.date(from: components)!
        return date
    }
    
    /**
     # fromString
     Receives the user inputs in type of Int to create an Date
     
     - parameter string String(): Is the date.
     - Requires: User input
     - returns: a String
     */
    class func fromString(string: String) -> Date {
        let year = Int(string[0...3])
        let month = Int(string[5...6])
        let day = Int(string[8...9])
        let hour = Int(string[11...12])
        let minutes = Int(string[14...15])
        let seconds = Int(string[17...18])
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minutes
        components.second = seconds
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: components)!
        return date
    }
    /**
     # fromStringEficient
     Receives the user inputs in type of Int to create an Date
     
     - parameter string String(): Is the date.
     - Requires: User input
     - returns: a String
     */
    class func fromStringEficient(string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: string)!
        return date
    }
        //MARK:- Format the dates functions
    /**
     # toStringDate
     Receives an Date and gives you a text in the specified format
     
     - parameter date Date: a date
     - Requires: Date
     - returns: a String with the format   :    | "15/7/2016" |
     - Author: León Yannik López Rojas
     
     */
    class func toStringDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M/y"
        let dateString = formatter.string(from: date)
        return dateString
    }
    /**
     # toStringDateNormal
     Receives an Date and gives you a text in the specified format
     
     - parameter date Date: a date
     - Requires: Date
     - returns: a String with the format   :    | "Jul 15, 2016" |
     - Author: León Yannik López Rojas
     
     */
   class func toStringDateNormal(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, yyyy"
    let dateString = formatter.string(from: date)
        return dateString
    }
    /**
     # toStringDateForMSP
     Receives an Date and gives you a text in the specified format
     
     - parameter date Date: a date
     - Requires: Date
     - returns: a String with the format   :    | "Jul 15, 2016" |
     - Author: León Yannik López Rojas
     
     */
    class func toStringDateWithTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy HH:mm:ss"
        let dateString = formatter.string(from: date)
        return dateString
    }
    /**
     # toStringTime
     Receives an Date and gives you a text in the specified format
     
     - parameter date Date: a date
     - Requires: Date
     - returns: a String with the format   :     | "01:08 PM" |
     - Author: León Yannik López Rojas
     
     */
   class func toStringTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let dateString = formatter.string(from: date)
        return dateString
    }
    /**
     # toStringSimpleTime
     Receives an Date and gives you a text in the specified format
     
     - parameter date Date: a date
     - Requires: Date
     - returns: a String with the format   :    | "1:08 PM" |
     - Author: León Yannik López Rojas
     
     */
   class func toStringSimpleTime(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    let dateString = formatter.string(from: date)
        return dateString
    }
    /**
     # toStringTime24
     Receives an Date and gives you a text in the specified format
     
     - parameter date Date: a date
     - Requires: Date
     - returns: a String with the format   :   | "13:06" |
     - Author: León Yannik López Rojas
     
     */
   class func toStringTime24(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    let dateString = formatter.string(from: date)
        return dateString
    }
    /**
     # toStringWeekDay
     Receives an Date and gives you a text in the specified format
     
     - parameter date Date: a date
     - Requires: Date
     - returns: a String with the format   :    | "Fri" |
     - Author: León Yannik López Rojas
     
     */
   class func toStringWeekDay(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEE"
    let dateString = formatter.string(from: date)
        return dateString
    }

    /**
     # toStringNumberDate
     Receives an Date and gives you a text in the specified format
     
     - parameter date Date: a date
     - Requires: Date
     - returns: a String with the format   :    | "31" |
     - Author: León Yannik López Rojas
     
     */
   class func toStringNumberDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        let dateString = formatter.string(from: date)
        return dateString
    }
    /**
     # toIntMonth
     Receives an Date and gives you a text in the specified format
     
     - parameter date Date: a date
     - Requires: Date
     - returns: a String with the format   :    | 12 |
     - Author: León Yannik López Rojas
     
     */
   class func toIntMonth(date: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "M"
        let dateString = formatter.string(from: date)
        return Int(dateString)!
    }
    /**
     # toIntYear
     Receives an Date and gives you a text in the specified format
     
     - parameter date Date: a date
     - Requires: Date
     - returns: a String with the format   :    | 2016 |
     - Author: León Yannik López Rojas
     
     */
   class func toIntYear(date: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let dateString = formatter.string(from: date)
        return Int(dateString)!
    }
    
    /**
     # toIntDay
     Receives an Date and gives you a text in the specified format
     
     - parameter date Date: a date
     - Requires: Date
     - returns: a String with the format   :    | 31 |
     - Author: León Yannik López Rojas
     
     */
    class func toIntDay(date: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        let dateString = formatter.string(from: date)
        return Int(dateString)!
    }
    /**
     # toStringDayMonthDay
     Receives an Date and gives you a text in the specified format
     
     - parameter date Date: a date
     - Requires: Date
     - returns: a String with the format   :    | "Wednesday, Sep. 31" |
     - Author: León Yannik López Rojas
     
     */
   class func toStringDayMonthDay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM. d"
        let dateString = formatter.string(from: date)
        return dateString
    }
    /**
     # toStringDayMonthDay
     Receives an Date and gives you a text in the specified format
     
     - parameter date Date: a date
     - Requires: Date
     - returns: a String with the format   :    | "Wednesday, Sep." |
     - Author: León Yannik López Rojas
     
     */
    class func toStringDayMonth(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM."
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    /**
     # toStringWhen
     Receives an Date and gives you a text in the specified format
     
     - parameter date Date: a date
     - Requires: Date
     - returns: a String with the format   :   | "Today" |
     - Author: León Yannik López Rojas
     
     */
     class func toStringWhen(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter.string(from: date)
    }
}

public extension Date {
    public func isToday() -> Bool{
        let today = Date()
        return self.year == today.year && self.month == today.month && self.day == today.day
    }
}

public extension Date {
    
    var year: Int {
        let data = self.components.year!
        return data
    }
    var month: Int {
        let data = self.components.month!
        return data
    }
    var day: Int {
        let data = self.components.day!
        return data
    }
    var hour: Int {
        let data = self.components.hour!
        return data
    }
    var minute: Int {
        let data = self.components.minute!
        return data
    }
    var second: Int {
        let data = self.components.second!
        return data
    }
    var week: Int {
        let data = self.components.weekOfYear!
        return data
    }
    var weekday: Int {
        let data = self.components.weekday!
        return data
    }
    var weekdayMonday1: Int {
        let data = self.components.weekday!
        var dataMinusOne = data - 1
        if dataMinusOne == 0 {
            dataMinusOne = 7
        }
        return dataMinusOne
    }
}
extension Date {
    var components:DateComponents {
        let cal = Calendar.current
        return cal.dateComponents(Set([.year, .month, .day, .hour, .minute, .second, .weekday, .weekOfYear, .yearForWeekOfYear, .weekdayOrdinal]), from: self)
    }
}

//extension String {
//    
//    subscript (i: Int) -> String {
//        let elIndex = index(startIndex, offsetBy: i)
//        return String(self[elIndex])
//    }
//    subscript (r: CountableClosedRange<Int>) -> String {
//        let start = index(startIndex, offsetBy: r.lowerBound)
//        let end = index(startIndex, offsetBy: r.upperBound + 1)
//        return String(self[Range(start..<end)])
//    }
//}
