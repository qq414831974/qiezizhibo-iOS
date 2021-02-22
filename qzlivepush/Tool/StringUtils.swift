//
//  StringUtil.swift
//  qzlivepush
//
//  Created by 吴帆 on 2021/2/22.
//  Copyright © 2021 qiezizhibo. All rights reserved.
//

import Foundation
struct StringUtils{
    static var CHN_NUMBER:[String] = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"];
    static var CHN_UNIT:[String] = ["", "十", "百", "千"];
    static var CHN_UNIT_SECTION:[String] = ["", "万", "亿", "万亿"];
    static func getChinesNum(number:Int) -> String {
        var num = number;
        var returnStr:String = "";
        var needZero:Bool = false;
        var pos = 0;
        if(num == 0){
            returnStr.insert(contentsOf: CHN_NUMBER[0],at: returnStr.startIndex);
        }
        while (num > 0) {
            let section:Int = num % 10000;
            if (needZero) {
                returnStr.insert(contentsOf: CHN_NUMBER[0],at: returnStr.startIndex);
            }
            var sectionToChn = sectionNumToChn(sec: section);
            //判断是否需要节权位
            sectionToChn += (section != 0) ? CHN_UNIT_SECTION[pos] : CHN_UNIT_SECTION[0];
            returnStr.insert(contentsOf: sectionToChn,at: returnStr.startIndex);
            needZero = ((section < 1000 && section > 0) ? true : false); //判断section中的千位上是不是为零，若为零应该添加一个零。
            pos += 1;
            num = num / 10000;
        }
        return returnStr;
    }
    static func sectionNumToChn(sec:Int) -> String{
        var section = sec;
        var returnStr:String = "";
        var unitPos:Int = 0;

        var zero:Bool = true;
        while (section > 0) {

            let v:Int = (section % 10);
            if (v == 0) {
                if ((section == 0) || !zero) {
                    zero = true; /*需要补0，zero的作用是确保对连续的多个0，只补一个中文零*/
                    //chnStr.insert(0, chnNumChar[v]);
                    returnStr.insert(contentsOf: CHN_NUMBER[v],at: returnStr.startIndex);
                }
            } else {
                zero = false; //至少有一个数字不是0
                var tempStr:String = "";
                if(v == 1 && unitPos == 1){
                    tempStr.append(CHN_UNIT[unitPos]);
                }else{
                    tempStr.append(CHN_NUMBER[v]);
                    tempStr.append(CHN_UNIT[unitPos]);
                }
                returnStr.insert(contentsOf: tempStr,at: returnStr.startIndex);
            }
            unitPos += 1; //移位
            section = section / 10;
        }
        return returnStr;
    }
}
