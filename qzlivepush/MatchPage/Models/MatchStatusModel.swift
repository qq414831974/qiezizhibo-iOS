//
//  MatchStatusModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2021/3/30.
//  Copyright © 2021 qiezizhibo. All rights reserved.
//

import ObjectMapper
class MatchStatusModel: Mappable{
    
    var id:Int?;
    var matchId:Int?;
    var status:Int?;
    var section:Int?;
    var againstIndex:Int?;
    var score:Dictionary<String,String>?;

    required init?(map: Map) {}

    func mapping(map: Map) {
        id <- map["id"]
        matchId <- map["matchId"]
        status <- map["status"]
        section <- map["section"]
        againstIndex <- map["againstIndex"]
        score <- map["score"]
    }
}
