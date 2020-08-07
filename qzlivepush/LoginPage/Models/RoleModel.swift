//
//  RoleModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/5/22.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import ObjectMapper

class RoleModel: Mappable{
    var roleCode:String?;
    var roleName:String?;
    var menuList:[MenuModel]?;
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        roleCode <- map["roleCode"]
        roleName <- map["roleName"]
        menuList <- map["menuList"]
    }
}
