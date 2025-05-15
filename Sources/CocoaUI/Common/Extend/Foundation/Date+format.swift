//
//  Date+format.swift
//  CocoaUI
//
//  Created by simy on 2025/5/12.
//

import Foundation

public extension String {
    func convertToChinaTime() -> String {
        // 创建日期格式化器
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // 将字符串转换为Date对象
        guard let date = dateFormatter.date(from: self) else {
            return self
        }
        
        // 转换为中国时区
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }
    
    /// utc 时间转换为当前地区的时间
    /// 假设有一个 UTC 时间字符串: "2025-05-10T01:22:20Z"
    func utcConvertToLocalTime() -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // 支持毫秒

        guard let utcDate = isoFormatter.date(from: self) else {
            return self
        }

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let localDateString = dateFormatter.string(from: utcDate)
        return localDateString
    }
}
