//
//  ScoreboardPositionModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/7/11.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import ObjectMapper
class ScoreboardPositionModel: Mappable{
    var x: Float?;
    var y: Float?;
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        x <- map["x"]
        y <- map["y"]
    }
}
