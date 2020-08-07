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
    var country: String?;
    var city: String?;
    var birthdate: String?;
    var sex: Int?;
    var height: Int?;
    var weight: Int?;
    var headImg: String?;//头像
    var careerTime: String?;
    var isRetire: Bool?;
    var retireTime: String?;
    var remark: String?;
    
    required init(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        position <- map["position"]
        shirtNum <- map["shirtNum"]
        status <- map["status"]
        englishName <- map["englishName"]
        country <- map["country"]
        city <- map["city"]
        birthdate <- map["birthdate"]
        sex <- map["sex"]
        height <- map["height"]
        weight <- map["weight"]
        headImg <- map["headImg"]
        careerTime <- map["careerTime"]
        isRetire <- map["isRetire"]
        retireTime <- map["retireTime"]
        remark <- map["remark"]
    }
}
