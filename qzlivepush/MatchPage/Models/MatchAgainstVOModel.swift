//
//  MatchAgainstVOModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2021/3/30.
//  Copyright © 2021 qiezizhibo. All rights reserved.
//

import ObjectMapper
class MatchAgainstVOModel: Mappable{
    
    var hostTeam:TeamModel?;
    var guestTeam:TeamModel?;

    required init?(map: Map) {}

    func mapping(map: Map) {
        hostTeam <- map["hostTeam"]
        guestTeam <- map["guestTeam"]
    }
}
