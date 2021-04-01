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
    var englishName:String?;
    var shortName:String?;
    var headImg:String?;
    var remark:String?;
    var province:String?;
    var city:String?;
    var population:Int?;
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        englishName <- map["englishName"]
        shortName <- map["shortName"]
        headImg <- map["headImg"]
        remark <- map["remark"]
        province <- map["province"]
        city <- map["city"]
        population <- map["population"]
    }
}
