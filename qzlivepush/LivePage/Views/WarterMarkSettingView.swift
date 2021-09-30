//
//  WarterMarkSettingView.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/7/6.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit
import SwiftEntryKit

class WarterMarkSettingView: UIView {
    
    @IBOutlet weak var switch_logo: UISwitch!
    
    @IBOutlet weak var switch_scoreBoard: UISwitch!
    
    @IBOutlet weak var btn_confirm: UIButton!
    
    @IBOutlet weak var iv_hostShirt: UIImageView!
    
    @IBOutlet weak var iv_guestShirt: UIImageView!
    
    @IBOutlet weak var lb_hostShirt: UILabel!
    
    @IBOutlet weak var lb_guestShirt: UILabel!
    
    var currentShirt:[UIImageView] = [UIImageView]();

    var viewModel:LiveViewModel!;
    
    var scoreBoard:ScoreBoard!;

    override func awakeFromNib() {
        btn_confirm.addTarget(self, action: #selector(onBtnConfirmClick), for: UIControl.Event.touchUpInside);
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = true;
        
        iv_hostShirt.tag = 1001;
        iv_guestShirt.tag = 1002;
        lb_hostShirt.tag = 2001;
        lb_guestShirt.tag = 2002;
        addColorPicker(target: iv_hostShirt);
        addColorPicker(target: iv_guestShirt);
        addColorPicker(target: lb_hostShirt);
        addColorPicker(target: lb_guestShirt);
        
    }
    func setUp(){
        viewModel = LiveViewModel.sharedInstance;
        iv_hostShirt.tintColor = scoreBoard.v_hostShirt.backgroundColor;
        iv_guestShirt.tintColor = scoreBoard.v_guestShirt.backgroundColor;
    }
    func addColorPicker(target:UIView){
        let tap = UITapGestureRecognizer(target:self, action:#selector(showColorPicker));
        target.isUserInteractionEnabled = true;
        target.addGestureRecognizer(tap);
    }
    @objc func showColorPicker(target:UITapGestureRecognizer){
        if(target.view!.tag == 1001 || target.view!.tag == 2001){
            currentShirt = [iv_hostShirt];
        }else if(target.view!.tag == 1002 || target.view!.tag == 2002){
            currentShirt = [iv_guestShirt];
        }
        var attributes = EKAttributes.centerFloat;
        let widthConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 300);
        let heightConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 300);
        attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint);
        attributes.positionConstraints.rotation.isEnabled = false;
        attributes.entryBackground = .color(color: .white);
        attributes.screenBackground = .color(color: UIColor(white: 50.0/255.0, alpha: 0.3));
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero));
        attributes.scroll = .disabled
        attributes.entranceAnimation = .translation;
        attributes.exitAnimation = .translation;
        attributes.displayDuration = .infinity;
        attributes.entryInteraction = .absorbTouches;
        attributes.screenInteraction = .dismiss;
        attributes.name = "colorPicker";
//        attributes.roundCorners = .all(radius: 10);
        attributes.lifecycleEvents.didDisappear = {
//            self.viewModel!.controller!.currentScoreBoard = self.scoreBoardModel;
            self.viewModel!.controller!.showEntry(name: "warterMarkSettingView");
        }
        let colorPicker: ColorPicker = Bundle.main.loadNibNamed("ColorPicker", owner: self, options: nil)!.first as! ColorPicker;
        colorPicker.delegate = self;
        SwiftEntryKit.display(entry: colorPicker, using: attributes);
    }
    @objc func onBtnConfirmClick(){
        if(switch_logo.isOn){
            viewModel.controller!.logoWarterMark.isHidden = false;
        }else{
            viewModel.controller!.logoWarterMark.isHidden = true;
        }
        if(switch_scoreBoard.isOn){
            viewModel.controller!.scoreBoardWarterMark.isHidden = false;
        }else{
            viewModel.controller!.scoreBoardWarterMark.isHidden = true;
        }
        let scoreBoard = viewModel.controller!.session!.warterMarkView!.viewWithTag(101) as! ScoreBoard;
        scoreBoard.v_guestShirt!.backgroundColor = iv_guestShirt.tintColor;
        scoreBoard.v_hostShirt!.backgroundColor = iv_hostShirt.tintColor;
        if(iv_guestShirt.tintColor.y() > 0.75){
            scoreBoard.lb_guestName!.textColor = UIColor.black;
        }else{
            scoreBoard.lb_guestName!.textColor = UIColor.white;
        }
        if(iv_hostShirt.tintColor.y() > 0.75){
            scoreBoard.lb_hostName!.textColor = UIColor.black;
        }else{
            scoreBoard.lb_hostName!.textColor = UIColor.white;
        }
        viewModel.controller!.session!.warterMarkView = viewModel.controller!.session!.warterMarkView;
        SwiftEntryKit.dismiss();
    }
}
extension WarterMarkSettingView: ColorPickerDelegate {
    
    /// This method gets called whenever the pikko color was updated.
    func onColorChange(color: UIColor) {
        for shirt in currentShirt {
            shirt.tintColor = color;
        }
        SwiftEntryKit.dismiss();
    }
}
