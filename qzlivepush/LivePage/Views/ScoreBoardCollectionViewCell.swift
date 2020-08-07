//
//  ScoreBoardCollectionViewCell.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/7/1.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit

class ScoreBoardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var check: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white.withAlphaComponent(0.8);
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = true;
    }
    func selectItem(isSelect:Bool){
        if(isSelect){
            self.layer.borderColor = UIColor.blue.withAlphaComponent(0.2).cgColor;
            self.layer.borderWidth = 1;
            check.isHidden = false;
        }else{
            self.layer.borderWidth = 0;
            check.isHidden = true;
        }
    }
}
