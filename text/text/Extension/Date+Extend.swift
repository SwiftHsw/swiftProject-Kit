//
//  Date+Extend.swift
//  Gregarious
//
//  Created by csp on 2021/3/31.
//

import Foundation

//MARK: - Shortcut
public extension Date {
    
    /// 年份
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    /// 月份(1~12)
    var month: Int {
        return Calendar.current.component(.month, from:self)
    }
    
    /// 天数(1~31)
    var day: Int {
        return Calendar.current.component(.day, from:self)
    }
    
    /// 小时数(0~23)
    var hour: Int {
        return Calendar.current.component(.hour, from:self)
    }
    
    /// 分钟数(0~59)
    var minute: Int {
        return Calendar.current.component(.minute, from:self)
    }
    
    /// 秒数(0~59)
    var second: Int {
        return Calendar.current.component(.second, from:self)
    }
    
    /// 纳秒数
    var nanosecond: Int {
        return Calendar.current.component(.nanosecond, from:self)
    }
    
    /// 周数(1~7，周日为1)
    var weekday: Int {
        return Calendar.current.component(.weekday, from:self)
    }
    
    private static let weeks: [String] = { ["星期日", "星期一", "星期二", "星期三","星期四", "星期五", "星期六"] }()
    /// 返回星期几的字符串
    var weekdayString: String {
        let day = self.weekday - 1
        return Date.weeks[day]
    }
    
    /// 以7天为单位(1~5)
    var weekdayOrdinal: Int {
        return Calendar.current.component(.weekdayOrdinal, from:self)
    }
    
    /// 月包含的周数(1~5)
    var weekOfMonth: Int {
        return Calendar.current.component(.weekOfMonth, from:self)
    }
    
    /// 年包含的周数(1~53)
    var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from:self)
    }
    
    /// YearForWeekOfYear component
    var yearForWeekOfYear: Int {
        return Calendar.current.component(.yearForWeekOfYear, from:self)
    }

    /// 返回是否是季度
    var quarter: Int {
    return Calendar.current.component(.quarter, from:self)
    }
    
    /// 返回是否是闰月
    var isLeapMonth: Bool {
        return Calendar.current.dateComponents([.year, .month], from: self).isLeapMonth!
    }

    /// 返回是否是闰年
    var isLeapYear: Bool {
        let year = self.year
        return ((year % 400 == 0) || (year % 100 == 0) || (year % 4 == 0))
    }
    
    /// 返回当前月的总天数
    var monthTotalDays: Int {
        switch self.month {
        case 1, 3, 5, 7, 8, 10, 12: return 31
        case 2: return self.isLeapYear ? 29 : 28
        default: return 30
        }
    }
    
    /// 返回是否是今天
    var isToday: Bool {
        let time = fabs(self.timeIntervalSinceNow)
        if time >= 86400 { return false }
        return Date().day == self.day
    }
    
    var isThisYaer: Bool {
        if Date().year == self.year {
            return true
        }
        return false
    }
    
    /// 返回是否是昨天
    var isYesterday: Bool {
        return false
    }
    
    private var _chineseCalendar: DateComponents {
        let calendar = Calendar(identifier: .chinese)
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return components
    }
    
    /// 返回农历年份
    var lunarYear: Int {
        return self._chineseCalendar.year!
    }
    
    /// 返回农历月份
    var lunarMonth: Int {
        return self._chineseCalendar.month!
    }
    
    /// 返回农历日期
    var lunarDay: Int {
        return self._chineseCalendar.day!
    }
    
    private static let lunarYears: [String] = { ["甲子", "乙丑", "丙寅", "丁卯", "戊辰", "己巳", "庚午", "辛未", "壬申", "癸酉", "甲戌", "乙亥", "丙子", "丁丑", "戊寅", "己卯", "庚辰", "辛己", "壬午", "癸未", "甲申", "乙酉", "丙戌", "丁亥", "戊子", "己丑", "庚寅", "辛卯", "壬辰", "癸巳", "甲午", "乙未", "丙申", "丁酉", "戊戌", "己亥", "庚子", "辛丑", "壬寅", "癸丑", "甲辰", "乙巳", "丙午", "丁未", "戊申", "己酉", "庚戌", "辛亥", "壬子", "癸丑", "甲寅", "乙卯", "丙辰", "丁巳", "戊午", "己未", "庚申", "辛酉", "壬戌", "癸亥"] }()
    /// 返回农历年份字符串
    var lunarYearString: String {
        let year = self.lunarYear - 1;
        return Date.lunarYears[year]
    }
    
    private static let lunarMonths: [String] = { ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "冬月", "腊月"]}()
    /// 返回农历月份字符串
    var lunarMonthString: String {
        let month = self.lunarMonth - 1;
        return Date.lunarMonths[month]
    }
    
    private static let lunarDays: [String] = { ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十","十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十","廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"] }()
    /// 返回农历日期字符串
    var lunarDayString: String {
        let day = self.lunarDay - 1;
        return Date.lunarDays[day]
    }
}

//MARK: - Date Format
extension Date {
    
    private static let formatter = DateFormatter()
    
    static func stringFromTimeInterval(_ timeInterval: TimeInterval, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        return date.string(with: format)
    }
    
    /// 返回格式化的日期字符串
    func string(with format: String = "yyyy-MM-dd HH:mm:ss", locale: Locale = .current, timeZone: TimeZone = .current) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.timeZone = timeZone
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    /// 根据日期字符串及格式返回新的Date
    init?(string: String, format: String = "yyyy-MM-dd HH:mm:ss", locale: Locale = .current, timeZone: TimeZone = .current) {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.timeZone = timeZone
        formatter.dateFormat = format
        if let date = formatter.date(from: string) {
            self = date
        } else {
            return nil
        }
    }
    
    /// 将时间显示为（几分钟前，几小时前，几天前）
    static func compareCurrentTime(str: String) -> String {
        
        guard let timeDate = Date(string: str) else {
            return ""
        }
        
        return Date.compareCurrentTime(timeDate: timeDate)
    }
    
    /// 将时间显示为（几分钟前，几小时前，几天前）
    static func compareCurrentTime(timeDate: Date) -> String {
        
        let currentDate = Date()
        let timeInterval = currentDate.timeIntervalSince(timeDate)
        var temp: Double = 0
        var result : String = ""
        if timeInterval / 60 < 1 {
            result = "刚刚"
        }
        else if (timeInterval / 60) < 60 {
            temp = timeInterval / 60
            result = "\(Int(temp))分钟前"
        }
        else if timeInterval / 60 / 60 < 24 {
            temp = timeInterval / 60 / 60
            result = "\(Int(temp))小时前"
        }
        else if timeInterval / (24 * 60 * 60) < 30 {
            temp = timeInterval / (24 * 60 * 60)
            result = "\(Int(temp))天前"
        }
        else if timeInterval / (30 * 24 * 60 * 60) < 12 {
            temp = timeInterval / (30 * 24 * 60 * 60)
            result = "\(Int(temp))个月前"
        }
        else {
            temp = timeInterval / (12 * 30 * 24 * 60 * 60)
            result = "\(Int(temp))年前"
        }
        
        return result
    }
    
    /// 显示视频播放时间 00:00:00
    static func videoShowStr(secounds: TimeInterval) -> String {
        
        if secounds.isNaN {
            return "00:00"
        }
        
        var Min = Int(secounds / 60)
        let Sec = Int(secounds.truncatingRemainder(dividingBy: 60))
        var Hour = 0
        if Min >= 60 {
            Hour = Int(Min / 60)
            Min = Min - Hour*60
            return String(format: "%02d:%02d:%02d", Hour, Min, Sec)
        }
        
        return String(format: "00:%02d:%02d", Min, Sec)
    }
    
}

//MARK: - Modify
public extension Date {

    /// 返回当前日期月份的第一天日期，也就是1号日期
    var monthFirstDay: Date {
        var components = Calendar.current.dateComponents([.era, .year, .month, .day, .hour, .minute, .second], from: self)
        components.day = 1
        return Calendar.current.date(from: components)!
    }

    /// 返回当前日期月份的最后一天日期，可能是31号、30号、28号
    var monthLastDay: Date {
        var components = Calendar.current.dateComponents([.era, .year, .month, .day, .hour, .minute, .second], from: self)
        components.day = monthTotalDays
        return Calendar.current.date(from: components)!
    }

    /// 返回该日期的第一个时刻，作为Date
    var startDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    ///  返回该日期的最后一刻(23时59分59秒)
    var endDay: Date {
        return Date(timeIntervalSince1970: startDay.timeIntervalSince1970 + 86399)
    }
    
    /// 返回年份增加/减少的新的Date
    func adding(year: Int) -> Date? {
        var components = DateComponents()
        components.year = year
        return Calendar.current.date(byAdding: components, to: self)
    }

    /// 返回月份增加/减少的新的Date
    func adding(month: Int) -> Date? {
        var components = DateComponents()
        components.month = month
        return Calendar.current.date(byAdding: components, to: self)
    }

    /// 返回周数增加/减少的新的Date
    func adding(week: Int) -> Date? {
        var components = DateComponents()
        components.weekOfYear = week
        return Calendar.current.date(byAdding: components, to: self)
    }

    /// 返回天数增加/减少的新的Date
    func adding(day: Int) -> Date? {
        var components = DateComponents()
        components.day = day
        return Calendar.current.date(byAdding: components, to: self)
    }

    /// 返回小时增加/减少的新的Date
    func adding(hour: Int) -> Date? {
        var components = DateComponents()
        components.hour = hour
        return Calendar.current.date(byAdding: components, to: self)
    }

    /// 返回分钟增加/减少的新的Date
    func adding(minute: Int) -> Date? {
        var components = DateComponents()
        components.minute = minute
        return Calendar.current.date(byAdding: components, to: self)
    }

    /// 返回秒数增加/减少的新的Date
    func adding(secode: Int) -> Date? {
        var components = DateComponents()
        components.second = secode
        return Calendar.current.date(byAdding: components, to: self)
    }
    
    /// 早于date则返回true，否则返回false
    func isEarlier(than date: Date) -> Bool {
        return self.compare(date) == ComparisonResult.orderedAscending
    }
    
    /// 晚于date则返回true，否则返回false
    func isLater(than date: Date) -> Bool {
        return self.compare(date) == ComparisonResult.orderedDescending
    }
    
    /// 比较两个Date的相差天数
    /// - Parameter date: 要比较的Date
    /// - Returns: 相差的天数
    func numberOfDays(_ date: Date) -> Int {
        let fromDate = startDay
        let toDate = date.startDay
        return Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day!
    }
}
