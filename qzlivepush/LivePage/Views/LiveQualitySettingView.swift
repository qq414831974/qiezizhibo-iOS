//
//  LiveQualitySettingView.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/7/2.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit
import SwiftEntryKit
class LiveQualitySettingView: UIView {
    @IBOutlet weak var slider_video: UISlider!
    
    @IBOutlet weak var swith_audio: UISwitch!
    
    @IBOutlet weak var slider_bright: UISlider!
    
    @IBOutlet weak var btn_confirm: UIButton!
    
    @IBOutlet weak var lb_videoQuality: UILabel!
    
    @IBOutlet weak var switch_beauty: UISwitch!
    
    var viewModel:LiveViewModel!;

    override func awakeFromNib() {
        btn_confirm.addTarget(self, action: #selector(onBtnConfirmClick), for: UIControl.Event.touchUpInside);
        slider_video.addTarget(self, action: #selector(onVideoValueChange), for: UIControl.Event.valueChanged);
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = true;
        viewModel = LiveViewModel.sharedInstance;
    }
    @objc func onVideoValueChange(){
        let step = slider_video.value.truncatingRemainder(dividingBy: 1);
        if(step >= 0.5){
            slider_video.value = ceil(slider_video.value)
        }else{
            slider_video.value = floor(slider_video.value)
        }
        let quailty:[Int:String] = [1:"低",2:"中",3:"高"];
        lb_videoQuality.text = quailty[Int(floor(slider_video.value))];
    }
    @objc func onBtnConfirmClick(){
        let quality:[Int:LFLiveVideoQuality] = [1:LFLiveVideoQuality.high6,2:LFLiveVideoQuality.high4,3:LFLiveVideoQuality.high5];
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: quality[Int(floor(slider_video.value))]!,outputImageOrientation:.landscapeLeft);
        
        if(quality[Int(floor(slider_video.value))] != viewModel.controller!.currentQuality){
            viewModel.controller!.videoConfiguration = videoConfiguration;
            viewModel.controller!.initSession();
            viewModel.controller!.currentQuality = quality[Int(floor(slider_video.value))]!;
        }
        viewModel.controller!.session.brightLevel = CGFloat(slider_bright.value);
        if(switch_beauty.isOn){
            viewModel.controller!.session.beautyFace = true;
        }else{
            viewModel.controller!.session.beautyFace = false;
        }
        if(swith_audio.isOn){
            viewModel.controller!.session.muted = false;
        }else{
            viewModel.controller!.session.muted = true;
        }
        SwiftEntryKit.dismiss();
    }
}
