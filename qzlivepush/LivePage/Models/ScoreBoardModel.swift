//
//  ScoreBoardModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/7/11.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import ObjectMapper
class ScoreBoardModel: Mappable{
    var id: Int?;
    var title: ScoreboardPositionModel?;
    var hostname: ScoreboardPositionModel?;
    var guestname: ScoreboardPositionModel?;
    var hostscore: ScoreboardPositionModel?;
    var guestscore: ScoreboardPositionModel?;
    var hostshirt: ScoreboardPositionModel?;
    var guestshirt: ScoreboardPositionModel?;
    var time: ScoreboardPositionModel?;
    var scoreboardpic: String?;
    var hostshirtpic: String?;
    var guestshirtpic: String?;
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        hostname <- map["hostname"]
        guestname <- map["guestname"]
        hostscore <- map["hostscore"]
        guestscore <- map["guestscore"]
        hostshirt <- map["hostshirt"]
        guestshirt <- map["guestshirt"]
        time <- map["time"]
        scoreboardpic <- map["scoreboardpic"]
        hostshirtpic <- map["hostshirtpic"]
        guestshirtpic <- map["guestshirtpic"]
    }
}
