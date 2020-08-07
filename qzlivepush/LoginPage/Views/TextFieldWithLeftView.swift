//
//  TextFieldWithLeftView.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/5/28.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit
@IBDesignable class TextFieldWithLeftView: UITextField {
    var leftImageView: UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20));
    @IBInspectable var leftWidth: CGFloat = 20;
    @IBInspectable var leftHeight: CGFloat = 20;
    @IBInspectable var leftImage: UIImage?{
        didSet{
            if(leftImage != nil){
                leftImageView.image = leftImage!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate);
                leftImageView.contentMode = UIView.ContentMode.scaleAspectFit;
//                leftImageView.tintColor = leftTintColor;
                self.leftView = leftImageView;
                self.leftView!.tintColor = leftTintColor;
                self.leftViewMode = UITextField.ViewMode.always;
            }
        }
    };
    @IBInspectable var leftTintColor: UIColor?{
        didSet{
            leftImageView.tintColor = leftTintColor;
        }
    };
    override func layoutSubviews() {
        super.layoutSubviews();
        leftImageView.frame.size.width = leftWidth;
        leftImageView.frame.size.height = leftHeight;
        leftImageView.image = leftImage!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate);
        leftImageView.contentMode = UIView.ContentMode.scaleAspectFit;
        self.leftView = leftImageView;
//        self.leftView!.tintColor = leftTintColor;
        self.leftViewMode = UITextField.ViewMode.always;
    }
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var iconRect:CGRect = super.leftViewRect(forBounds: bounds);
        iconRect.origin.x += 15;
        return iconRect;
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 45, dy: 0);
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 45, dy: 0);
    }

    open func setHighlighted(highlighted: Bool){
        UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            if(highlighted){
                let tintColor:UIColor = UIColor.init(red: 0, green: 0.57, blue: 1, alpha: 0.9);
                self.leftView!.tintColor = tintColor;
                self.layer.borderWidth = 0.6;
                self.layer.borderColor = tintColor.cgColor;
            }else{
                self.layer.borderWidth = 0.3;
                self.layer.borderColor = UIColor.lightGray.cgColor;
                self.leftView!.tintColor = self.leftTintColor;
            }
        }) { (completed) in

        }
    }
}
