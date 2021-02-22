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
    var matchId: Int?;
    var teamId: Int?;//队伍id
    var playerId: Int?;
    var player: PlayerModel?;//队员信息
    var secondPlayer: PlayerModel?;
    var eventType: Int?;//时间轴类型
    var minute: Int?;//比赛时间
    var remark: String?;//remark
    var text: String?;//文字
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        matchId <- map["matchId"]
        teamId <- map["teamId"]
        playerId <- map["playerId"]
        player <- map["player"]
        secondPlayer <- map["secondPlayer"]
        eventType <- map["eventType"]
        minute <- map["minute"]
        remark <- map["remark"]
        text <- map["text"]
    }
}
