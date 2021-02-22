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
    var unit:String?;
    var createTime:String?;
    var avatar:String?;
    var status:Int?;
    var remark:String?;
    var wechatOpenid:String?;
    var gender:Int?;
    var loginTime:Int?;
    var email:String?;
    var phone:Int?;
    var roles:[RoleModel]?;
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        userNo <- map["userNo"]
        userName <- map["userName"]
        name <- map["name"]
        password <- map["password"]
        unit <- map["unit"]
        createTime <- map["createTime"]
        avatar <- map["avatar"]
        status <- map["status"]
        remark <- map["remark"]
        wechatOpenid <- map["wechatOpenid"]
        gender <- map["gender"]
        loginTime <- map["loginTime"]
        email <- map["email"]
        phone <- map["phone"]
        roles <- map["role"]
    }
}
