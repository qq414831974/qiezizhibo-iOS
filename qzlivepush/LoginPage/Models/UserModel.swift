//
//  UserModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/5/22.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import ObjectMapper

class UserModel: Mappable{
    var userNo:String?;
    var userName:String?;
    var name:String?;
    var password:String?;
    var avatar:String?;
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        userNo <- map["userNo"]
        userName <- map["userName"]
        name <- map["name"]
        password <- map["password"]
        avatar <- map["avatar"]
    }
}
