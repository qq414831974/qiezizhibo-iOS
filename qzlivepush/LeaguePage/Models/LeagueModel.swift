//
//  LeagueModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/5/27.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import ObjectMapper
class LeagueModel: Mappable{
    
    var id:Int?;
    var type:Int?;//1:杯赛，2:联赛
    var ruleType:Int?;//1:杯赛，2:联赛
    var round:LeagueRound?;//轮次
    var name:String?;//名字
    var shortName:String?;//缩写
    var city:String?;//城市
    var dateBegin:String?;//开始日期
    var dateEnd:String?;//结束日期
    var headImg:String?;//logo
    var currentRound:String?;//现在的轮次
    
    required init?(map: Map) {}

    func mapping(map: Map) {
        id <- map["id"]
        type <- map["type"]
        ruleType <- map["ruleType"]
        round <- map["round"]
        name <- map["name"]
        shortName <- map["shortName"]
        city <- map["city"]
        dateBegin <- map["dateBegin"]
        dateEnd <- map["dateEnd"]
        headImg <- map["headImg"]
        currentRound <- map["currentRound"]
    }
}
