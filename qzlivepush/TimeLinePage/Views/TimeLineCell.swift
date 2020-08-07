//
//  TimeLineCell.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/15.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit

protocol TimeLineCell: UITableViewCell{
    
    func setEventName(eventName:String);
    func setEventImg(img:UIImage);
    func setEventImg(url:String);
    func setMinute(minute:Int?);
    func setPlayerName(name:String);
    func setPlayerImg(img:UIImage);
    func setPlayerImg(url:String?);
    func showPlayer();
    func hidePlayer();
    func showSecondPlayer();
    func hideSecondPlayer();
    func setSecondEventImg(img:UIImage);
    func setSecondEventImg(url:String);
    func setSecondPlayerName(name:String);
    func setSecondPlayerImg(img:UIImage);
    func setSecondPlayerImg(url:String?);
    
    func divideInTop();
    func divideInBottom();
    func divideNormal();
}
