//
//  Event.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/17.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

class TimeLineEvent {
    var text:String;
    var icon:String;
    var type:Int;//1:重要球赛事件 2:非重要球赛事件 0:球赛时间事件
    var eventType:Int;
    var remarkName:String?;
    var remarkValue:[[String:String]]?;
    
    init(text:String,icon:String,eventType:Int,type:Int) {
        self.text = text;
        self.icon = icon;
        self.type = type;
        self.eventType = eventType;
    }
    
    init(text:String,icon:String,eventType:Int,type:Int,remarkName:String?,remarkValue:[[String:String]]?) {
        self.text = text;
        self.icon = icon;
        self.type = type;
        self.eventType = eventType;
        self.remarkName = remarkName;
        self.remarkValue = remarkValue;
    }
    
    static var important = 1;
    static var notImportant = 2;
    static var timeEvent = 0;
    static var none = -1;
}
