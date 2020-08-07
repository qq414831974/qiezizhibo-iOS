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
    var leaguematchId:Int?;//联赛id
    var league:LeagueModel?;//联赛信息
    var hostTeamId:Int?;//主队id
    var guestTeamId:Int?;//客队id
    var hostteam:TeamModel?;//主队信息
    var guestteam:TeamModel?;//客队信息
    var activityId:String?;//直播间id
    var hostnooice:Int?;//主队点赞数
    var guestnooice:Int?;//客队点赞数
    var round:String?;//轮次
    var place:String?;//地点
    var startTime:String?;//开始时间
    var endTime:String?;//结束时间
    var status:Int?;//状态
    var score:String?;//比分
    var penaltyscore:String?;//点球比分
    var playpath:String?;//直播播放地址
    var remark:String?;
    var type:[Int]?;
    var thumbnail:String?;
    var poster:String?;//封面图
    var online:Int?;//在线人数
    var onlineforreal:Int?;//真实在线人数
    var duration:Int?;//比赛总分钟数
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        leaguematchId <- map["leaguematchId"]
        league <- map["league"]
        hostTeamId <- map["hostTeamId"]
        guestTeamId <- map["guestTeamId"]
        hostteam <- map["hostteam"]
        guestteam <- map["guestteam"]
        activityId <- map["activityId"]
        hostnooice <- map["hostnooice"]
        guestnooice <- map["guestnooice"]
        round <- map["round"]
        place <- map["place"]
        startTime <- map["startTime"]
        endTime <- map["endTime"]
        status <- map["status"]
        score <- map["score"]
        penaltyscore <- map["penaltyscore"]
        playpath <- map["playpath"]
        remark <- map["remark"]
        type <- map["type"]
        thumbnail <- map["thumbnail"]
        poster <- map["poster"]
        online <- map["online"]
        onlineforreal <- map["onlineforreal"]
        duration <- map["duration"]
    }
}
