//
//  MatchAgainstView.swift
//  qzlivepush
//
//  Created by 吴帆 on 2021/3/31.
//  Copyright © 2021 qiezizhibo. All rights reserved.
//

import UIKit

class MatchAgainstView: UIView{
    var lb_hostName: UILabel?
    var iv_hostHeadImg: UIImageView?
    var lb_vs: UILabel?
    var iv_guestHeadImg: UIImageView?
    var lb_guestName: UILabel?
    
    override init(frame:CGRect){
            super.init(frame: frame)
            setupSubViews()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setupSubViews() {
            lb_hostName = UILabel(frame: CGRect(x:0,y:20,width:95,height:20));
            iv_hostHeadImg = UIImageView(frame: CGRect(x:95,y:15,width:30,height:30));
            lb_guestName = UILabel(frame: CGRect(x:205,y:20,width:95,height:20));
            iv_guestHeadImg = UIImageView(frame: CGRect(x:175,y:15,width:30,height:30));
            lb_vs = UILabel(frame: CGRect(x:125,y:20,width:50,height:20));
            lb_hostName!.textAlignment = NSTextAlignment.center;
            lb_guestName!.textAlignment = NSTextAlignment.center;
            lb_vs!.textAlignment = NSTextAlignment.center;
            lb_hostName!.font = UIFont.systemFont(ofSize: 15);
            lb_guestName!.font = UIFont.systemFont(ofSize: 15);
            lb_vs!.font = UIFont.systemFont(ofSize: 13);

            self.addSubview(lb_hostName!)
            self.addSubview(iv_hostHeadImg!)
            self.addSubview(lb_vs!)
            self.addSubview(lb_guestName!)
            self.addSubview(iv_guestHeadImg!)
            
            self.backgroundColor = UIColor.white;
            self.layer.cornerRadius = 5;
            self.layer.shadowRadius = 5;
            self.layer.shadowOpacity = 0.15;
            self.layer.shadowOffset = CGSize(width: 0, height: 0.3);
            self.layer.shadowColor = UIColor.black.cgColor;
            self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath;
        }
        
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            lb_hostName?.frame = CGRect(x:0,y:20,width:95,height:21);
            iv_hostHeadImg?.frame = CGRect(x:95,y:15,width:30,height:30);
            lb_guestName?.frame = CGRect(x:205,y:20,width:95,height:21);
            iv_guestHeadImg?.frame = CGRect(x:175,y:15,width:30,height:30);
            lb_vs?.frame = CGRect(x:125,y:20,width:50,height:21);
        }
}
