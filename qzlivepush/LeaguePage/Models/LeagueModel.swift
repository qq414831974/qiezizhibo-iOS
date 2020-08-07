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
    var round:LeagueRound?;//轮次
    var name:String?;//名字
    var shortname:String?;//缩写
    var englishName:String?;
    var majorSponsor:String?;//主办方
    var sponsor:String?;//赞助商
    var place:String?;//比赛地点list
    var city:String?;//城市
    var country:String?;//国家
    var dateBegin:String?;//开始日期
    var dateEnd:String?;//结束日期
    var phoneNumber:Int?;//电话
    var wechat:String?;//微信号
    var headImg:String?;//logo
    var remark:String?;
    var currentRound:String?;//现在的轮次
    
    required init?(map: Map) {}

    func mapping(map: Map) {
        id <- map["id"]
        type <- map["type"]
        round <- map["round"]
        name <- map["name"]
        shortname <- map["shortname"]
        englishName <- map["englishName"]
        majorSponsor <- map["majorSponsor"]
        sponsor <- map["sponsor"]
        place <- map["place"]
        city <- map["city"]
        country <- map["country"]
        dateBegin <- map["dateBegin"]
        dateEnd <- map["dateEnd"]
        phoneNumber <- map["phoneNumber"]
        wechat <- map["wechat"]
        headImg <- map["headImg"]
        remark <- map["remark"]
        currentRound <- map["currentRound"]
    }
}
