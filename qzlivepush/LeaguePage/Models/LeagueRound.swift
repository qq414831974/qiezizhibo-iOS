//
//  LeagueRound.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/11/14.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import ObjectMapper
class LeagueRound: Mappable{
    
    var rounds:[String]?;

    required init?(map: Map) {}

    func mapping(map: Map) {
        rounds <- map["rounds"]
    }
}

