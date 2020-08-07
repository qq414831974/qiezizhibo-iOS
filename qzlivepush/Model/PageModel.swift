//
//  PageModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/5/27.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import ObjectMapper
class PageModel<T:Mappable>:Mappable{
    var total:Int?;
    var records:[T]?;
    var current:Int?;
    var size:Int?;
    var pages:Int?;
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        total <- map["total"]
        records <- map["records"]
        current <- map["current"]
        size <- map["size"]
        pages <- map["pages"]
    }
}
