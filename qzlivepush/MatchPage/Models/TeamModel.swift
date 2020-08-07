//
//  TeamModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/11.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import ObjectMapper
class TeamModel: Mappable{
    var id:Int?;
    var name:String?;
    var owner:String?;
    var coachId:Int?;
    var englishName:String?;
    var country:String?;
    var city:String?;
    var slogan:String?;
    var birthdate:String?;
    var population:Int?;
    var headImg:String?;
    var verify:Int?;
    var disband:Bool?;
    var remark:String?;
    var version:Int?;
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        owner <- map["owner"]
        coachId <- map["coachId"]
        englishName <- map["englishName"]
        country <- map["country"]
        city <- map["city"]
        slogan <- map["slogan"]
        birthdate <- map["birthdate"]
        population <- map["population"]
        headImg <- map["headImg"]
        verify <- map["verify"]
        disband <- map["disband"]
        remark <- map["remark"]
        version <- map["version"]
    }
}
