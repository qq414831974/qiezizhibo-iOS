//
//  MatchModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/11.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import ObjectMapper
class MatchModel: Mappable{
    var id:Int?;
    var name:String?;//名字
    var leagueId:Int?;//联赛id
    var activityId:String?;//直播间id
    var available:Bool?//直播间是否可用
    var againsts:Dictionary<String,MatchAgainstModel>?;
    var startTime:String?;//开始时间
    var section:Int?;//小节数
    var minutePerSection:Int?;//每小节几分钟
    var place:String?;//地点
    var playPath:String?;//直播播放地址
    var poster:String?;//封面图
    var type:[Int]?;
    var round:String?;//轮次
    var subgroup:String?;//分组
    var remark:String?;
    var league:LeagueModel?;//联赛信息
    var againstTeams:Dictionary<String,MatchAgainstVOModel>?;
    var status:MatchStatusModel?;//状态
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        leagueId <- map["leagueId"]
        activityId <- map["activityId"]
        available <- map["available"]
        againsts <- map["againsts"]
        startTime <- map["startTime"]
        section <- map["section"]
        minutePerSection <- map["minutePerSection"]
        place <- map["place"]
        playPath <- map["playPath"]
        poster <- map["poster"]
        type <- map["type"]
        round <- map["round"]
        subgroup <- map["subgroup"]
        remark <- map["remark"]
        league <- map["league"]
        againstTeams <- map["againstTeams"]
        status <- map["status"]
    }
}
