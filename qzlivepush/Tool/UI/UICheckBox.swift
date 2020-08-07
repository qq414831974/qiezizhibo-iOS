//
//  UICheckBox.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/5/29.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit

@IBDesignable class UICheckBox: UIButton{
    
    override func layoutSubviews() {
        self.setImage(UIImage.init(named: "check.png"), for: UIControl.State.selected)
        self.backgroundColor = UIColor.white;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = true;
        self.layer.borderColor = UIColor.lightGray.cgColor;
        self.layer.borderWidth = 0.3;
        super.layoutSubviews();
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event);
        self.isSelected = !self.isSelected;
    }
}
