//
//  MatchStatusModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/15.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import ObjectMapper
class MatchStatusModel: Mappable{
    var minute: Int?;
    var status: Int?;
    var score: String?;
    var penaltyScore: String?;
    var timeLines: [TimeLineModel]?;
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        minute <- map["minute"]
        status <- map["status"]
        score <- map["score"]
        penaltyScore <- map["penaltyScore"]
        timeLines <- map["timeLines"]
    }
}
