//
//  ScoreBoard.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/28.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit
import SDWebImage
class ScoreBoard:UIView{
    @IBOutlet weak var board: UIImageView!
    @IBOutlet weak var lb_hostscore: UILabel!
    @IBOutlet weak var lb_guestscore: UILabel!
    @IBOutlet weak var lb_leagueName: UILabel!
    @IBOutlet weak var lb_time: UILabel!
    @IBOutlet weak var lb_hostName: UILabel!
    @IBOutlet weak var lb_guestName: UILabel!
    @IBOutlet weak var iv_hostShirt: UIImageView!
    @IBOutlet weak var iv_guestShirt: UIImageView!
    
    //Constraint
    @IBOutlet weak var leagueName_x: NSLayoutConstraint!
    @IBOutlet weak var leagueName_y: NSLayoutConstraint!
    @IBOutlet weak var hostShirt_x: NSLayoutConstraint!
    @IBOutlet weak var hostShirt_y: NSLayoutConstraint!
    @IBOutlet weak var hostName_x: NSLayoutConstraint!
    @IBOutlet weak var hostName_y: NSLayoutConstraint!
    @IBOutlet weak var hostScore_x: NSLayoutConstraint!
    @IBOutlet weak var hostScore_y: NSLayoutConstraint!
    @IBOutlet weak var gusetShirt_x: NSLayoutConstraint!
    @IBOutlet weak var guestShirt_y: NSLayoutConstraint!
    @IBOutlet weak var guestName_x: NSLayoutConstraint!
    @IBOutlet weak var guestName_y: NSLayoutConstraint!
    @IBOutlet weak var gusetScore_x: NSLayoutConstraint!
    @IBOutlet weak var guestScore_y: NSLayoutConstraint!
    @IBOutlet weak var time_x: NSLayoutConstraint!
    @IBOutlet weak var time_y: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib();
    }
    func updateConstraint(scoreBoard:ScoreBoardModel){
        leagueName_x.constant = CGFloat(scoreBoard.title!.x! * 900);
        leagueName_y.constant = CGFloat(scoreBoard.title!.y! * 180);
        hostShirt_x.constant = CGFloat(scoreBoard.hostshirt!.x! * 900);
        hostShirt_y.constant = CGFloat(scoreBoard.hostshirt!.y! * 180);
        hostName_x.constant = CGFloat(scoreBoard.hostname!.x! * 900);
        hostName_y.constant = CGFloat(scoreBoard.hostname!.y! * 180);
        hostScore_x.constant = CGFloat(scoreBoard.hostscore!.x! * 900);
        hostScore_y.constant = CGFloat(scoreBoard.hostscore!.y! * 180);
        gusetShirt_x.constant = CGFloat(scoreBoard.guestshirt!.x! * 900);
        guestShirt_y.constant = CGFloat(scoreBoard.guestshirt!.y! * 180);
        guestName_x.constant = CGFloat(scoreBoard.guestname!.x! * 900);
        guestName_y.constant = CGFloat(scoreBoard.guestname!.y! * 180);
        gusetScore_x.constant = CGFloat(scoreBoard.guestscore!.x! * 900);
        guestScore_y.constant = CGFloat(scoreBoard.guestscore!.y! * 180);
        time_x.constant = CGFloat(scoreBoard.time!.x! * 900);
        time_y.constant = CGFloat(scoreBoard.time!.y! * 180);
        board.sd_setImage(with: URL(string: scoreBoard.scoreboardpic!), placeholderImage: UIImage(named: "score-board-default.png"))
        SDWebImageManager.shared.loadImage(with: URL(string: scoreBoard.hostshirtpic!), progress: nil) { (image, data, error, cacheType, finished, imageURL) in
            if(image != nil){
                self.iv_hostShirt.image = image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate);
            }else{
                self.iv_hostShirt.image = UIImage(named: "shirt2")
            }
        }
        SDWebImageManager.shared.loadImage(with: URL(string: scoreBoard.guestshirtpic!), progress: nil) { (image, data, error, cacheType, finished, imageURL) in
            if(image != nil){
                self.iv_guestShirt.image = image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate);
            }else{
                self.iv_guestShirt.image = UIImage(named: "shirt2")
            }
        }
        layoutIfNeeded();
    }
}
