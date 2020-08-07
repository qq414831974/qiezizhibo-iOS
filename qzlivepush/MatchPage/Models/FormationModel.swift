//
//  FormationModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/11.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import ObjectMapper
class FormationModel: Mappable{
    var id: Int?;
    var type: String?;
    var position: [Int?:PlayerModel?]?;
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        type <- map["type"]
        position <- map["position"]
    }
}
