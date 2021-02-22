//
//  RoleModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/5/22.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import ObjectMapper

class RoleModel: Mappable{
    var id:Int?;
    var name:String?;
    var description:String?;
    var isAnchor:Bool?;
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        description <- map["description"]
        isAnchor <- map["isAnchor"]
    }
}
