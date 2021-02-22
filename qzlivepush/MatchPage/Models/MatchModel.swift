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
    var league:LeagueModel?;//联赛信息
    var hostTeamId:Int?;//主队id
    var guestTeamId:Int?;//客队id
    var hostTeam:TeamModel?;//主队信息
    var guestTeam:TeamModel?;//客队信息
    var activityId:String?;//直播间id
    var hostNooice:Int?;//主队点赞数
    var guestNooice:Int?;//客队点赞数
    var round:String?;//轮次
    var place:String?;//地点
    var startTime:String?;//开始时间
    var status:Int?;//状态
    var score:String?;//比分
    var penaltyScore:String?;//点球比分
    var playPath:String?;//直播播放地址
    var remark:String?;
    var type:[Int]?;
    var poster:String?;//封面图
    var online:Int?;//在线人数
    var onlineReal:Int?;//真实在线人数
    var duration:Int?;//比赛总分钟数
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        leagueId <- map["leagueId"]
        league <- map["league"]
        hostTeamId <- map["hostTeamId"]
        guestTeamId <- map["guestTeamId"]
        hostTeam <- map["hostTeam"]
        guestTeam <- map["guestTeam"]
        activityId <- map["activityId"]
        hostNooice <- map["hostNooice"]
        guestNooice <- map["guestNooice"]
        round <- map["round"]
        place <- map["place"]
        startTime <- map["startTime"]
        status <- map["status"]
        score <- map["score"]
        penaltyScore <- map["penaltyScore"]
        playPath <- map["playPath"]
        remark <- map["remark"]
        type <- map["type"]
        poster <- map["poster"]
        online <- map["online"]
        onlineReal <- map["onlineReal"]
        duration <- map["duration"]
    }
}
