//
//  TimeLineModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/15.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import ObjectMapper
class TimeLineModel: NSObject, Mappable{
    var id: Int?;//id
    var teamId: Int?;//队伍id
    var player: PlayerModel?;//队员信息
    var eventType: Int?;//时间轴类型
    var time: Int?;//比赛时间
    var remark: String?;//remark
    var text: String?;//文字
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        teamId <- map["teamId"]
        player <- map["player"]
        eventType <- map["eventType"]
        time <- map["time"]
        remark <- map["remark"]
        text <- map["text"]
    }
}
