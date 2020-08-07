//
//  DateUtils.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/5/30.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import Foundation
struct DateUtils{
    static func stringConvertDate(string:String, dateFormat:String="yyyy/MM/dd HH:mm:ss") -> Date {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let date = dateFormatter.date(from: string)
        return date!
    }
    static func dateConvertString(date:Date, dateFormat:String="yyyy/MM/dd") -> String {
        let timeZone = TimeZone.init(identifier: "GMT+8")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        return formatter.string(from: date)
    }
}
