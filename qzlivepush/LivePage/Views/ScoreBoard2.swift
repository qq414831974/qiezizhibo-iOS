//
//  ScoreBoard2.swift
//  qzlivepush
//
//  Created by 吴帆 on 2020/12/10.
//  Copyright © 2020 qiezizhibo. All rights reserved.
//

import UIKit
import SDWebImage

class ScoreBoard2: UIView {
    @IBOutlet weak var board: UIImageView!
    @IBOutlet weak var lb_hostscore: UILabel!
    @IBOutlet weak var lb_guestscore: UILabel!
    @IBOutlet weak var lb_time: UILabel!
    @IBOutlet weak var lb_hostName: UILabel!
    @IBOutlet weak var lb_guestName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib();
    }
}
