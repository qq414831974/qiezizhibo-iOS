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
    var passWord:String?;
    var unit:String?;
    var createTime:String?;
    var avatar:String?;
    var status:Int?;
    var remark:String?;
    var wechatOpenid:String?;
    var gender:Int?;
    var lastLoginTime:Int?;
    var email:String?;
    var phone:Int?;
    var role:RoleModel?;
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        userNo <- map["userNo"]
        userName <- map["userName"]
        name <- map["name"]
        passWord <- map["passWord"]
        unit <- map["unit"]
        createTime <- map["createTime"]
        avatar <- map["avatar"]
        status <- map["status"]
        remark <- map["remark"]
        wechatOpenid <- map["wechatOpenid"]
        gender <- map["gender"]
        lastLoginTime <- map["lastLoginTime"]
        email <- map["email"]
        phone <- map["phone"]
        role <- map["role"]
    }
}
