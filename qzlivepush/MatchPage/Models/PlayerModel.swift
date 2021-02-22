//
//  PlayerModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/11.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import ObjectMapper
class PlayerModel: Mappable,ImmutableMappable{
    var id: Int?;//id
    var name: String?;//名字
    var position: String?;
    var shirtNum: Int?;//球衣号
    var status: Int?;
    var englishName: String?;
    var province: String?;
    var city: String?;
    var sex: Int?;
    var height: Int?;
    var weight: Int?;
    var headImg: String?;//头像
    var remark: String?;
    
    required init(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        position <- map["position"]
        shirtNum <- map["shirtNum"]
        status <- map["status"]
        englishName <- map["englishName"]
        province <- map["province"]
        city <- map["city"]
        sex <- map["sex"]
        height <- map["height"]
        weight <- map["weight"]
        headImg <- map["headImg"]
        remark <- map["remark"]
    }
}
