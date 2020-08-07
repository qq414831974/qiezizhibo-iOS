//
//  ResponseModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/5/22.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//
import ObjectMapper
fileprivate let defualtCode = "200"
struct ResponseModel<T: Mappable>:Mappable{
    
    var code: String = defualtCode         //状态码
    var message: String = ""       //消息
    var data: T?                     //数据
    
    init?(map: Map) {}
    
    init(code:String = defualtCode,message:String,data:T?) {
        self.code = code
        self.message = message
        self.data = data
    }
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        data <- map["data"]
    }
}
