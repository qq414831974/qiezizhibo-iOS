//
//  TimeLineCell.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/15.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit

class TimeLineCellLeft: UITableViewCell,TimeLineCell{
    @IBOutlet weak var divide: UIView!
    @IBOutlet weak var divideTop: NSLayoutConstraint!
    @IBOutlet weak var devideBottom: NSLayoutConstraint!
    
    @IBOutlet weak var lb_eventName: UILabel!
    @IBOutlet weak var iv_eventImg: UIImageView!
    @IBOutlet weak var lb_minute: UILabel!
    @IBOutlet weak var lb_playerName: UILabel!
    @IBOutlet weak var iv_playerImg: UIImageView!
    @IBOutlet weak var v_secondPlayer: UIView!
    @IBOutlet weak var iv_secondEventImg: UIImageView!
    @IBOutlet weak var lb_secondPlayerName: UILabel!
    @IBOutlet weak var iv_secondPlayerImg: UIImageView!
    
    func setEventName(eventName: String) {
        lb_eventName.text = eventName;
    }
    
    func setEventImg(img: UIImage) {
        iv_eventImg.image = img;
        iv_eventImg.layer.borderWidth = 5;
        iv_eventImg.layer.cornerRadius = 22.5
        iv_eventImg.layer.borderColor = UIColor.white.cgColor;
        iv_eventImg.contentMode = UIView.ContentMode.center;
    }
    
    func setEventImg(url: String) {
        iv_eventImg.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "logo.png"));
    }
    
    func setMinute(minute: Int?) {
        if(minute == nil){
            lb_minute.text = "";
        }else{
            lb_minute.text = String(minute!) + "'";
        }
    }
    
    func setPlayerName(name: String) {
        lb_playerName.text = name;
    }
    
    func setPlayerImg(img: UIImage) {
        iv_playerImg.image = img;
    }
    
    func setPlayerImg(url: String?) {
        if(url == nil){
            iv_playerImg.image = UIImage.init(named: "defaultAvatar.jpg")
        }else{
            iv_playerImg.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "defaultAvatar.jpg"));
        }
    }
    
    func showPlayer(){
        lb_playerName.isHidden = false;
        iv_playerImg.isHidden = false;
    }
    
    func hidePlayer(){
        lb_playerName.isHidden = true;
        iv_playerImg.isHidden = true;
    }
    
    func showSecondPlayer() {
        v_secondPlayer.isHidden = false;
    }
    
    func hideSecondPlayer() {
        v_secondPlayer.isHidden = true;
    }
    
    func setSecondEventImg(img: UIImage) {
        iv_secondEventImg.image = img;
    }
    
    func setSecondEventImg(url: String) {
        iv_secondEventImg.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "logo.png"));
    }
    
    func setSecondPlayerName(name: String) {
        lb_secondPlayerName.text = name;
    }
    
    func setSecondPlayerImg(img: UIImage) {
        iv_secondPlayerImg.image = img;
    }
    
    func setSecondPlayerImg(url: String?) {
        if(url == nil){
            iv_secondPlayerImg.image = UIImage.init(named: "defaultAvatar.jpg")
        }else{
            iv_secondPlayerImg.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "defaultAvatar.jpg"));
        }
    }
    
    func divideInTop(){
        divideTop.constant = 50;
    }
    func divideInBottom(){
        devideBottom.constant = 50;
    }
    func divideNormal(){
        divideTop.constant = 0;
        devideBottom.constant = 0;
    }
}
