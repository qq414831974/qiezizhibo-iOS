//
//  ActivityModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2020/6/5.
//  Copyright © 2020 qiezizhibo. All rights reserved.
//

import ObjectMapper
class ActivityModel: NSObject, Mappable{
    var id: String?;
    var name: String?;
    var pushStreamUrl: String?;
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        pushStreamUrl <- map["pushStreamUrl"]
    }
}
