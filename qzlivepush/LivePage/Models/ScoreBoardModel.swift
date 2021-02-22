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
    var detail: ScoreBoardDetailModel?;
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        detail <- map["detail"]
    }
}
