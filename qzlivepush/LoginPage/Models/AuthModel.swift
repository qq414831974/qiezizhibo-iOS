//
//  AuthModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2020/4/20.
//  Copyright © 2020 qiezizhibo. All rights reserved.
//

import ObjectMapper

class AuthModel: Mappable{
    var accessToken:String?;
    var refreshToken:String?;

    required init?(map: Map) {}
    
    func mapping(map: Map) {
        accessToken <- map["accessToken"]
        refreshToken <- map["refreshToken"]
    }
}
