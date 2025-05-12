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
}
