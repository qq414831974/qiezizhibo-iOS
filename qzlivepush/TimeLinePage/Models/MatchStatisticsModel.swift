//
//  MatchStatisticsModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/15.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import ObjectMapper
class MatchStatisticsModel: Mappable{
    var pass: Int?;
    var possession: Int?;
    var shoot: Int?;
    var shoot_ontarget: Int?;
    var shoot_bar: Int?;
    var shoot_blocked: Int?;
    var shoot_outside: Int?;
    var offside: Int?;
    var tackle: Int?;
    var tackle_success: Int?;
    var free_kick: Int?;
    var foul: Int?;
    var save: Int?;
    var corner: Int?;
    var cross: Int?;
    var cross_success: Int?;
    var long_pass: Int?;
    var clearance: Int?;
    var yellow: Int?;
    var red: Int?;
    var goal: Int?;
    var penalty_kick: Int?;
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        pass <- map["pass"]
        possession <- map["possession"]
        shoot <- map["shoot"]
        shoot_ontarget <- map["shoot_ontarget"]
        shoot_bar <- map["shoot_bar"]
        shoot_blocked <- map["shoot_blocked"]
        shoot_outside <- map["shoot_outside"]
        offside <- map["offside"]
        tackle <- map["tackle"]
        tackle_success <- map["tackle_success"]
        free_kick <- map["free_kick"]
        foul <- map["foul"]
        save <- map["save"]
        corner <- map["corner"]
        cross <- map["cross"]
        cross_success <- map["cross_success"]
        long_pass <- map["long_pass"]
        clearance <- map["clearance"]
        yellow <- map["yellow"]
        red <- map["red"]
        goal <- map["goal"]
        penalty_kick <- map["penalty_kick"]
    }
}
