//
//  MenuModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/5/22.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import ObjectMapper

class MenuModel: Mappable{
    var menuId:Int?;
    var parentId:Int?;
    var menuCode:String?;
    var code:String?;
    var name:String?;
    var menuType:Int?;
    var num:Int?;
    var url:String?;
    var childMenu:[MenuModel]?;

    
    required init?(map: Map) {}

    func mapping(map: Map) {
        menuId <- map["menuId"]
        parentId <- map["parentId"]
        menuCode <- map["menuCode"]
        code <- map["code"]
        name <- map["name"]
        menuType <- map["menuType"]
        num <- map["num"]
        url <- map["url"]
        childMenu <- map["childMenu"]
    }
    
}

