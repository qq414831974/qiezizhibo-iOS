//
//  MatchStatusModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/15.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import ObjectMapper
class MatchStatusModel: Mappable{
    var time: Int?;
    var status: Int?;
    var score: String?;
    var halfScore: String?;
    var penaltyscore: String?;
    var timeLines: [TimeLineModel]?;
    var statistics: [Int:MatchStatisticsModel?]?;
    var hostnooice: Int?;
    var guestnooice: Int?;
    var online: Int?;
    var onlineforreal: Int?;
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        time <- map["time"]
        status <- map["status"]
        score <- map["score"]
        halfScore <- map["halfScore"]
        penaltyscore <- map["penaltyscore"]
        timeLines <- map["timeLines"]
        statistics <- map["statistics"]
        hostnooice <- map["hostnooice"]
        guestnooice <- map["guestnooice"]
        online <- map["online"]
        onlineforreal <- map["onlineforreal"]
    }
}
