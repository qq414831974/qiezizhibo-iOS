//
//  ScoreBoard2.swift
//  qzlivepush
//
//  Created by 吴帆 on 2020/12/10.
//  Copyright © 2020 qiezizhibo. All rights reserved.
//

import UIKit
import SDWebImage

class ScoreBoard: UIView {
    @IBOutlet weak var board: UIImageView!
    @IBOutlet weak var lb_hostscore: UILabel!
    @IBOutlet weak var lb_guestscore: UILabel!
    @IBOutlet weak var lb_time: UILabel!
    @IBOutlet weak var lb_hostName: UILabel!
    @IBOutlet weak var lb_guestName: UILabel!
    @IBOutlet weak var v_hostShirt: UIView!
    @IBOutlet weak var v_guestShirt: UIView!
    @IBOutlet weak var iv_boardLogoMask: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib();
    }
    
    func setTeamNameHost(teamName:String) {
        if (teamName != nil && getTextLength(str: teamName) > 7) {
            let textsize:CGFloat = 30 - (CGFloat(getTextLength(str: teamName)) - 7) * 2.5;
            lb_hostName.font = UIFont.boldSystemFont(ofSize: textsize);
        }
        lb_hostName.text = teamName;
    }

    func setTeamNameGuest(teamName:String) {
        if (teamName != nil && getTextLength(str: teamName) > 7) {
            let textsize:CGFloat = 30 - (CGFloat(getTextLength(str: teamName)) - 7) * 2.5;
            lb_guestName.font = UIFont.boldSystemFont(ofSize: textsize);
        }
        lb_guestName.text = teamName;
    }
    func showLogoMask(){
        iv_boardLogoMask.isHidden = false;
    }
    func hideLogoMask(){
        iv_boardLogoMask.isHidden = true;
    }
    func getTextLength(str:String) -> Double{
        var number = 0.0;
        for i in 0...str.count - 1 {
                let c: unichar = (str as NSString).character(at: i)
                if (c >= 0x4E00) {
                    number += 1
                }else {
                    number += 0.5
                }
            }
        return number;
    }
}
