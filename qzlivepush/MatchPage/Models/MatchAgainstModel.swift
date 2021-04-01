//
//  MatchAgainstModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2021/3/30.
//  Copyright © 2021 qiezizhibo. All rights reserved.
//

import ObjectMapper
class MatchAgainstModel: Mappable{
    
    var hostTeamId:Int?;
    var guestTeamId:Int?;

    required init?(map: Map) {}

    func mapping(map: Map) {
        hostTeamId <- map["hostTeamId"]
        guestTeamId <- map["guestTeamId"]
    }
}
