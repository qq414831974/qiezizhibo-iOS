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
    
    var viewModel:LiveViewModel!;
    
    override func awakeFromNib() {
        btn_confirm.addTarget(self, action: #selector(onBtnConfirmClick), for: UIControl.Event.touchUpInside);
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = true;
        viewModel = LiveViewModel.sharedInstance;
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
        viewModel.controller!.session!.warterMarkView = viewModel.controller!.session!.warterMarkView;
        SwiftEntryKit.dismiss();
    }
}
