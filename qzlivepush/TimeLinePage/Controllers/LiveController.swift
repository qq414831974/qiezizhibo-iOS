//
//  LiveController.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/15.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit
import LFLiveKit
import MediaPlayer
import DropDown
import SwiftEntryKit
import Pikko
import RxSwift

class LiveController: UIViewController, LFLiveSessionDelegate{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{ return .landscapeLeft}
    
    /// 分辨率： 1080 *1920 帧数：30 码率：1400Kps
    //  音频：44.1 iphone6以上48  双声道  方向横屏
    var session: LFLiveSession!;
    var audioConfiguration = LFLiveAudioConfiguration.defaultConfiguration(for: LFLiveAudioQuality.high);
    var videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.high5,outputImageOrientation:.landscapeLeft);
    //水印
    var warterMarkView: UIView!;
    var scoreBoard:ScoreBoard!;
    var scoreBoardWarterMark:ScoreBoard!;
    var scoreBoard_basketBall:ScoreBoard2!;
    var scoreBoardWarterMark_basketBall:ScoreBoard2!;
    var logoWarterMark:UIView!;
    
    var viewModel:LiveViewModel?;
    
    var scoreBoardSettingVc:ScoreBoardSettingView!;
    var qualitySettingView:LiveQualitySettingView!;
    var warterMarkSettingView:WarterMarkSettingView!;
    var timeLineView:TimeLineController!;
    var statusVc: ChooseStatusController!
    var scoreAndStatusVc: ScoreAndStatusController!
    var basketballTimelineVc: BasketballTimelineController!
    
    var isBasketBall:Bool = false;
    
    var currentScoreBoard:ScoreBoardModel?;
    var currentQuality = LFLiveVideoQuality.high5;
    var currentMatchId:Int?;
    var currentMatch:MatchModel?;
    var matchStatusModel:MatchStatusModel?;
    var timer:Timer?;
    var timer_Time:Timer?;
    var timer_quality:Timer?;
    var oldVol:Float = 0.0;
    var pushUrl:String!;
    
    var pushRetryTimes:Int = 0;
    let MAX_RETRY_TIMES:Int = 3;
    var firstRetryTime:Int = -1;
    var retryOpen:Bool = true;
    var firstPush:Bool = true;
    
    let disposeBag = DisposeBag();
    
    // 视图
    lazy var containerView: UIView = {
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.height, height: self.view.bounds.width))
        containerView.backgroundColor = UIColor.clear
//        containerView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleHeight]
        return containerView
    }()
    
    // 状态Label
    lazy var stateLabel: UILabel = {
        let stateLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 80, height: 40))
        stateLabel.text = "未连接"
        stateLabel.textColor = UIColor.white
        stateLabel.font = UIFont.systemFont(ofSize: 14)
        stateLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        stateLabel.textAlignment = NSTextAlignment.center;
        stateLabel.layer.cornerRadius = 10;
        stateLabel.layer.masksToBounds = true;
        return stateLabel
    }()
    // 带宽Label
    lazy var bandWidthLabel: UILabel = {
        let bandWidthLabel = UILabel(frame: CGRect(x: 20 + 90, y: 20, width: 80, height: 40))
        bandWidthLabel.text = "0kb/s"
        bandWidthLabel.textColor = UIColor.white
        bandWidthLabel.font = UIFont.systemFont(ofSize: 14)
        bandWidthLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        bandWidthLabel.textAlignment = NSTextAlignment.center;
        bandWidthLabel.layer.cornerRadius = 10;
        bandWidthLabel.layer.masksToBounds = true;
        return bandWidthLabel
    }()
    // 关闭按钮
    lazy var closeButton: UIButton = {
        var x:CGFloat = 10;
        if(isBasketBall){
            x = self.view.bounds.height - 10 - 54;
        }
        let closeButton = UIButton(frame: CGRect(x: x, y: self.view.bounds.width - 60, width: 44, height: 44))
        closeButton.setImage(UIImage(named: "close_preview"), for: UIControl.State());
        closeButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        closeButton.layer.cornerRadius = 22
        closeButton.layer.masksToBounds = true
        return closeButton
    }()
    
    // 设置按钮
    lazy var settingsButton: UIButton = {
        var x:CGFloat = 10 + 54;
        if(isBasketBall){
            x = self.view.bounds.height - 10 - 54 * 2;
        }
        let settingsButton = UIButton(frame: CGRect(x: x, y: self.view.bounds.width - 60, width: 44, height: 44))
        settingsButton.setImage(UIImage(named: "settings"), for: UIControl.State())
        settingsButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        settingsButton.layer.cornerRadius = 22
        settingsButton.layer.masksToBounds = true
        return settingsButton
    }()
    
    // 开始直播按钮
    lazy var startLiveButton: UIButton = {
        var x:CGFloat = 10 + 54 * 2;
        if(isBasketBall){
            x = self.view.bounds.height - 10 - 54 * 3;
        }
        let startLiveButton = UIButton(frame: CGRect(x: x, y: self.view.bounds.width - 60, width: 44, height: 44))
        startLiveButton.setImage(UIImage(named: "play"), for: UIControl.State())
        startLiveButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        startLiveButton.layer.cornerRadius = 22
        startLiveButton.layer.masksToBounds = true
        return startLiveButton
    }()
    
    // 时间轴统计按钮
    lazy var timeLineButton: UIButton = {
        var x:CGFloat = 10 + 54 * 3;
        if(isBasketBall){
            x = self.view.bounds.height - 10 - 54 * 4;
        }
        let timeLineButton = UIButton(frame: CGRect(x: x, y: self.view.bounds.width - 60, width: 44, height: 44))
        timeLineButton.setImage(UIImage.svg(named: "offside.svg", size: CGSize.init(width: 40, height: 40)), for: UIControl.State())
        timeLineButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        timeLineButton.layer.cornerRadius = 22
        timeLineButton.layer.masksToBounds = true
        let y = self.view.bounds.width - 60
        return timeLineButton
    }()
    
    // 比赛状态统计按钮
    lazy var statusButton: UIButton = {
        var x:CGFloat = 10 + 54 * 4;
        if(isBasketBall){
            x = self.view.bounds.height - 10 - 54 * 5;
        }
        let statusButton = UIButton(frame: CGRect(x: x, y: self.view.bounds.width - 60, width: 44, height: 44))
        statusButton.setImage(UIImage.svg(named: "extra.svg", size: CGSize.init(width: 40, height: 40)), for: UIControl.State())
        statusButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        statusButton.layer.cornerRadius = 22
        statusButton.layer.masksToBounds = true
        return statusButton
    }()
    // 波动警告Label
    lazy var liveQualityLabel: UILabel = {
        let liveQualityLabel = UILabel(frame: CGRect(x: (view.bounds.height - 200)/2, y: (view.bounds.width - 40)/2, width: 200, height: 40))
        liveQualityLabel.text = "当前网络不佳，请检查网络"
        liveQualityLabel.textColor = UIColor.white
        liveQualityLabel.font = UIFont.systemFont(ofSize: 14)
        liveQualityLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        liveQualityLabel.textAlignment = NSTextAlignment.center;
        liveQualityLabel.layer.cornerRadius = 10;
        liveQualityLabel.layer.masksToBounds = true;
        return liveQualityLabel
    }()
    func setWarterMarkView(){
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: videoConfiguration!.videoSize.width, height: videoConfiguration!.videoSize.height));
        
        //logo
        let imageView_logo = UIImageView.init(frame: CGRect.init(x: view.bounds.width * 0.0214, y: view.bounds.height * 0.023, width: view.bounds.width / 6, height: view.bounds.width / 6 / 2.818))
//        let hConstraint_logo = NSLayoutConstraint.init(item: imageView_logo, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: view.bounds.width / 6 / 2.818)
//        let wConstraint_logo = NSLayoutConstraint.init(item: imageView_logo, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: view.bounds.width / 6)
//        let topConstraint_logo = NSLayoutConstraint.init(item: imageView_logo, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: view.bounds.height * 0.023)
//        let leadingConstraint_logo = NSLayoutConstraint.init(item: imageView_logo, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: view.bounds.width * 0.0214)
//        imageView_logo.addConstraint(hConstraint_logo)
//        imageView_logo.addConstraint(wConstraint_logo)
//        imageView_logo.addConstraint(topConstraint_logo)
//        imageView_logo.addConstraint(leadingConstraint_logo)
        imageView_logo.image = UIImage.init(named: "logo-t.png");
        imageView_logo.tag = 201;
        view.addSubview(imageView_logo);
        
        //比分牌
        if(isBasketBall){
            scoreBoard_basketBall = Bundle.main.loadNibNamed("ScoreBoard2", owner: self, options: nil)!.first as! ScoreBoard2;
            scoreBoard_basketBall.frame = CGRect.init(x: view.bounds.width * 0.0214, y:  1080 - 200 - view.bounds.width * 0.0214, width: 600, height: 200);
            if(currentMatch != nil && currentMatch!.hostTeam != nil){
                scoreBoard_basketBall.lb_hostName.text = currentMatch!.hostTeam!.name;
            }
            if(currentMatch != nil && currentMatch!.guestTeam != nil){
                scoreBoard_basketBall.lb_guestName.text = currentMatch!.guestTeam!.name;
            }
            if(currentMatch != nil && currentMatch!.score != nil){
                let score = currentMatch!.score!.split(separator: "-");
                scoreBoard_basketBall.lb_hostscore.text = String(score[0]);
                scoreBoard_basketBall.lb_guestscore.text = String(score[1]);
            }
            scoreBoard_basketBall.lb_time.text = "1";
            self.scoreBoard_basketBall.tag = 101;
            view.addSubview(scoreBoard_basketBall);
            self.warterMarkView = view;
            self.session!.warterMarkView = self.warterMarkView;
            self.scoreBoardWarterMark_basketBall = self.session!.warterMarkView?.viewWithTag(101) as! ScoreBoard2;
            self.logoWarterMark = self.session!.warterMarkView?.viewWithTag(201);
        }else{
            scoreBoard = Bundle.main.loadNibNamed("ScoreBoard", owner: self, options: nil)!.first as! ScoreBoard;
            scoreBoard.frame = CGRect.init(x: view.bounds.width - 900 - view.bounds.width * 0.0214, y: view.bounds.height * 0.023, width: 900, height: 180);
            if(currentMatch != nil && currentMatch!.league != nil){
                var text = currentMatch!.league!.name;
                if(currentMatch!.league!.shortName != nil){
                    text = currentMatch!.league!.shortName;
                }
                if(text!.count > 11){
                    let letterfontIncrease = (text!.count - 11 ) / 2;
                    let letterSpacingIncrease = (text!.count - 11 ) / 4;
                    scoreBoard.lb_leagueName!.attributedText = text!.attributedString(font: UIFont.boldSystemFont(ofSize: CGFloat(30 - letterfontIncrease)), textColor: UIColor.white, lineSpaceing: 0, wordSpaceing: CGFloat(-0.5 * Double(letterSpacingIncrease)),expansion: CGFloat(-0.1 * Double(letterSpacingIncrease)))
                }else{
                    scoreBoard.lb_leagueName!.text = text;
                    scoreBoard.lb_leagueName!.font = UIFont.boldSystemFont(ofSize: 35)
                }
            }
            if(currentMatch != nil && currentMatch!.hostTeam != nil){
                scoreBoard.lb_hostName.text = currentMatch!.hostTeam!.name;
            }
            if(currentMatch != nil && currentMatch!.guestTeam != nil){
                scoreBoard.lb_guestName.text = currentMatch!.guestTeam!.name;
            }
            if(currentMatch != nil && currentMatch!.score != nil){
                let score = currentMatch!.score!.split(separator: "-");
                scoreBoard.lb_hostscore.text = String(score[0]);
                scoreBoard.lb_guestscore.text = String(score[1]);
            }
            viewModel!.scoreboard(callback: { (scoreBoardModels) in
                if(scoreBoardModels.count > 0){
                    self.scoreBoard.tag = 101;
                    self.currentScoreBoard = scoreBoardModels[0];
                    self.scoreBoard.updateConstraint(scoreboard: scoreBoardModels[0]);
                    view.addSubview(self.scoreBoard);
                    //添加水印
                    self.warterMarkView = view;
                    self.session!.warterMarkView = self.warterMarkView;
                    self.scoreBoardWarterMark = self.session!.warterMarkView?.viewWithTag(101) as! ScoreBoard;
                    self.logoWarterMark = self.session!.warterMarkView?.viewWithTag(201);
                    
                    self.viewModel!.getMatchStatus(matchId: self.currentMatchId!, type: nil, callback: { (matchStatusModel) in
                        var minute = matchStatusModel.minute;
                        var minuteString = "00";
                        if(minute != nil){
                            if(minute! < 10){
                                minuteString = "0" + String(minute!)
                            }else{
                                minuteString = String(minute!)
                            }}
                        self.scoreBoardWarterMark.lb_time.text = minuteString + ":" + "00";
                        self.session!.warterMarkView = self.session!.warterMarkView;
                    }, disposeBag: self.disposeBag)
                }
            }, disposeBag: disposeBag);
        }
    }
    
    func initSession(){
        session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration);
        session!.captureDevicePosition = .back;
        session!.delegate = self
        session!.preView = self.view
        session!.showDebugInfo = true;
        session!.beautyFace = false;
        session!.beautyLevel = 0;
//        session!.brightLevel = 0;
        setWarterMarkView();
        self.requestAccessForVideo()
        self.requestAccessForAudio()
    }

    override func viewDidLoad() {
        super.viewDidLoad();
        appDelegate.interfaceOrientations = [.landscapeLeft]

        //注入
        viewModel = LiveViewModel.sharedInstance;
        viewModel!.initWith(self);
        
        TimeLineViewModel.sharedInstance.addLiveController(self);

        initSession();
        
        self.view.backgroundColor = UIColor.clear
        self.view.addSubview(containerView)
        containerView.addSubview(stateLabel)
        containerView.addSubview(closeButton)
        containerView.addSubview(settingsButton)
        containerView.addSubview(startLiveButton)
        containerView.addSubview(bandWidthLabel)
        containerView.addSubview(liveQualityLabel)
        if(currentMatch!.type!.contains(1)){
            containerView.addSubview(timeLineButton)
            containerView.addSubview(statusButton)
        }
        bandWidthLabel.isHidden = true;
        liveQualityLabel.isHidden = true;
        
        closeButton.addTarget(self, action: #selector(didTappedCloseButton), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(didTappedSettingsButton), for: .touchUpInside)
        startLiveButton.addTarget(self, action: #selector(didTappedStartLiveButton), for: .touchUpInside)
        timeLineButton.addTarget(self, action: #selector(didTappedTimeLineButton), for: .touchUpInside)
        statusButton.addTarget(self, action: #selector(didTappedStatusButton), for: .touchUpInside)
        
        let volumeView = MPVolumeView() //} 为了隐藏声音弹框
        let volumeViewSlider = UISlider() //} 为了隐藏声音弹框
        for var view in volumeView.subviews{
            if view.classForCoder.description() == "MPVolumeSlider"{
                view = volumeViewSlider
                break
            }
        }
        volumeView.frame = CGRect(x: -100,y: -100,width: 40,height: 40)
        containerView.addSubview(volumeView)
        
        //音量键监听
        NotificationCenter.default.addObserver(self,selector: #selector(voiceChange),name:NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"),object:nil)
        UIApplication.shared.beginReceivingRemoteControlEvents()
        oldVol = AVAudioSession.sharedInstance().outputVolume;
        
        //scoreBoardSettingVc
        scoreBoardSettingVc = Bundle.main.loadNibNamed("ScoreBoardSettingView", owner: self, options: nil)!.first as! ScoreBoardSettingView;
        
        qualitySettingView = Bundle.main.loadNibNamed("LiveQualitySettingView", owner: self, options: nil)!.first as! LiveQualitySettingView;
        
        warterMarkSettingView = Bundle.main.loadNibNamed("WarterMarkSettingView", owner: self, options: nil)!.first as! WarterMarkSettingView;
            
        timeLineView = storyboard?.instantiateViewController(withIdentifier: "TimeLinePage") as? TimeLineController;
        
        statusVc = storyboard?.instantiateViewController(withIdentifier: "chooseStatusVC") as? ChooseStatusController;
        
        scoreAndStatusVc = storyboard?.instantiateViewController(withIdentifier: "scoreAndStatusVc") as? ScoreAndStatusController;

        basketballTimelineVc = storyboard?.instantiateViewController(withIdentifier: "basketballTimelineVC") as? BasketballTimelineController;
        
        viewModel?.activity(activityId: currentMatch!.activityId!, callback: { (res) in
            if(res.pushStreamUrl != nil){
                self.pushUrl = res.pushStreamUrl;
            }else{
                self.view.makeToast("获取直播信息失败，请联系管理员",position: .center);
            }
        }, disposeBag: disposeBag)
        //开始定时
        startTimer()
        
    }
    @objc func refreshTime(){
        if(isBasketBall){
        }else{
            let time = addTime(time: scoreBoardWarterMark.lb_time.text!);
            scoreBoardWarterMark.lb_time.text = time;
        }
        self.session!.warterMarkView = self.session!.warterMarkView;
    }
    func stopTimeToHalf(){
        let halfTime = currentMatch!.duration! / 2;
        scoreBoardWarterMark.lb_time.text = String(halfTime) + ":00"
        self.session!.warterMarkView = self.session!.warterMarkView;
    }
    func startTimer_time(){
        if(timer_Time != nil){
            timer_Time!.invalidate()
        }
        timer_Time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(refreshTime), userInfo: nil, repeats: true)
        timer_Time!.fire()
    }
    func stopTimer_time(){
        if(timer_Time != nil){
            timer_Time!.invalidate()
        }
    }
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(refreshData), userInfo: nil, repeats: true)
        //开始计时器
        timer!.fire()
    }
    func startTimer_quality(){
        if(timer_quality != nil){
            timer_quality!.invalidate()
        }
        self.pushRetryTimes = 0;
        timer_quality = Timer.scheduledTimer(timeInterval: 70, target: self, selector: #selector(refreshQuality), userInfo: nil, repeats: true)
        timer_quality!.fire()
    }
    func stopTimer_quality(){
        if(timer_quality != nil){
            timer_quality!.invalidate()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let value = CGFloat(oldVol) * 5 + 1;
        if(value >= session.maxZoomScale){
            session.zoomScale = session.maxZoomScale;
        }else if(value <= 1){
            session.zoomScale = 1;
        }else{
            session.zoomScale = value;
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        if(timer != nil){
            timer!.invalidate();
        }
        stopTimer_time();
        stopTimer_quality();
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //页面退出时还原强制竖屏状态
        appDelegate.interfaceOrientations = .portrait
    }
    @objc func voiceChange(notification:NSNotification){
        let volume = notification.userInfo!["AVSystemController_AudioVolumeNotificationParameter"] as! CGFloat
        let value = volume * 5 + 1;
        if(value >= session.maxZoomScale){
            session.zoomScale = session.maxZoomScale;
        }else if(value <= 1){
            session.zoomScale = 1;
        }else{
            session.zoomScale = value;
        }
    }
    func addTime(time:String) -> String{
        let timeArray = time.split(separator: ":");
        var minite = Int(timeArray[0]);
        var second = Int(timeArray[1]);
        var minteString = "0";
        var secondString = "0";
        second = second! + 1;
        if(second! >= 60){
            minite = minite! + 1;
            second = 0;
        }
        if(minite! < 10){
            minteString = "0" + String(minite!)
        }else{
            minteString = String(minite!)
        }
        if(second! < 10){
            secondString = "0" + String(second!)
        }else{
            secondString = String(second!)
        }
        return minteString + ":" + secondString
    }
    // 回调
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        print("debugInfo: \(debugInfo?.currentBandwidth)")
        bandWidthLabel.text = String.init(format:"%.2f", debugInfo!.currentBandwidth / 1024) + "kb/s";
    }
    
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        print("errorCode: \(errorCode.rawValue)")
    }
    
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        print("liveStateDidChange: \(state.rawValue)")
        switch state {
        case LFLiveState.ready:
            stateLabel.text = "未连接"
            break;
        case LFLiveState.pending:
            stateLabel.text = "连接中"
            break;
        case LFLiveState.start:
            stateLabel.text = "已连接"
            break;
        case LFLiveState.error:
            stateLabel.text = "连接错误"
            showAlert(title: "推流失败，是否电话联系直播管理员？", message: "") { (action) in
                let phone = "telprompt://17750235615"
                 if UIApplication.shared.canOpenURL(URL(string: phone)!) {
                      UIApplication.shared.openURL(URL(string: phone)!)
                  }
            }
            break;
        case LFLiveState.stop:
            stateLabel.text = "未连接"
            break;
        default:
            break;
        }
    }
    
    //MARK: - Events
    
    // 开始直播
    @objc func didTappedStartLiveButton(_ button: UIButton) -> Void {
        if (!startLiveButton.isSelected) {
            showSheet(title: "是否开始直播？", message: "") { (action) in
                self.startLiveButton.isSelected = !self.startLiveButton.isSelected;
                self.startLiveButton.setImage(UIImage(named: "stop"), for: UIControl.State())
                let stream = LFLiveStreamInfo()
                stream.url = self.pushUrl;
                self.session.startLive(stream)
                self.bandWidthLabel.isHidden = false;
                self.qualitySettingView.slider_video.isEnabled = false;
                if((self.matchStatusModel != nil && self.matchStatusModel!.minute != nil) || self.isBasketBall){
                    self.startTimer_time();
                }
                self.firstPush = true;
                self.startTimer_quality();
            }
        } else {
            showSheet(title: "是否结束直播？", message: "") { (action) in
                self.startLiveButton.isSelected = !self.startLiveButton.isSelected;
                self.startLiveButton.setImage(UIImage(named: "play"), for: UIControl.State())
                self.session.stopLive()
                self.bandWidthLabel.isHidden = true;
                self.qualitySettingView.slider_video.isEnabled = true;
            }
        }
    }
    
    // 设置
    @objc func didTappedSettingsButton(_ button: UIButton) -> Void {
        let dropDown:DropDown = DropDown();
        dropDown.anchorView = settingsButton;
        dropDown.dataSource = ["直播设置","比分牌设置","画面设置"];
        dropDown.direction = .top;
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            if(index == 0){
                self.showEntry(name: "qualitySettingView");
            }else if(index == 1){
                if(self.isBasketBall){
                    self.view.makeToast("暂不支持修改比分牌",position: .center);
                }else{
                    let scoreBoard = self.warterMarkView!.viewWithTag(101) as! ScoreBoard;
                    self.scoreBoardSettingVc.scoreBoardModel = self.currentScoreBoard!;
                    self.scoreBoardSettingVc.scoreBoard = scoreBoard;
                    self.scoreBoardSettingVc.setUp();
                    self.showEntry(name: "scoreBoardSettingVc")
                }
            }else if(index == 2){
                self.showEntry(name: "warterMarkSettingView");
            }
        }
        dropDown.show();
    }
    func showSheet(title:String,message:String,callBack:((UIAlertAction) -> Void)?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet);
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil);
        let confirmAction = UIAlertAction(title: "确定", style: .destructive, handler: callBack);
        alertController.addAction(cancelAction);
        alertController.addAction(confirmAction);
        self.present(alertController, animated: true, completion: nil);
    }
    func showAlert(title:String,message:String,callBack:((UIAlertAction) -> Void)?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil);
        let confirmAction = UIAlertAction(title: "确定", style: .destructive, handler: callBack);
        alertController.addAction(cancelAction);
        alertController.addAction(confirmAction);
        self.present(alertController, animated: true, completion: nil);
    }
    func showEntry(name:String){
        var attributes = EKAttributes.centerFloat;
        attributes.entryBackground = .color(color: .white);
        attributes.screenBackground = .color(color: UIColor(white: 50.0/255.0, alpha: 0.3));
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero));
        attributes.scroll = .disabled
        attributes.entranceAnimation = .translation;
        attributes.exitAnimation = .translation;
        attributes.displayDuration = .infinity;
        attributes.entryInteraction = .absorbTouches;
        attributes.screenInteraction = .dismiss;
//        attributes.roundCorners = .all(radius: 10);
        if(name == "scoreBoardSettingVc"){
            let widthConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 600);
            let heightConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 300);
            attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint);
            attributes.positionConstraints.rotation.isEnabled = false;
            attributes.lifecycleEvents.didDisappear = {
                self.scoreBoardSettingVc.stopTimer();
            }
            attributes.lifecycleEvents.didAppear = {
                self.scoreBoardSettingVc.updateConstraint(scoreboard: self.scoreBoardSettingVc.scoreBoardModel);
                if(self.startLiveButton.isSelected && self.matchStatusModel != nil && self.matchStatusModel!.status! != -1 && self.matchStatusModel!.status != 21 && self.matchStatusModel!.status != 14){
                    self.scoreBoardSettingVc.startTimer();
                }
            }
            attributes.name = "scoreBoardSettingVc";
            SwiftEntryKit.display(entry: self.scoreBoardSettingVc, using: attributes);
        }else if(name == "qualitySettingView"){
            let widthConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 500);
            let heightConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 250);
            attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint);
            attributes.positionConstraints.rotation.isEnabled = false;
            attributes.name = "qualitySettingView";
            
            qualitySettingView.slider_bright.value = Float(self.session!.brightLevel)
            qualitySettingView.slider_video.value = Float(viewModel!.getQuailtyIndex(quality: self.currentQuality)!);
            qualitySettingView.lb_videoQuality.text = viewModel!.getQualityName(quality:  self.currentQuality);
            qualitySettingView.swith_audio.isOn = self.session!.muted == true ? false : true;
            qualitySettingView.switch_retry.isOn = self.retryOpen;
            SwiftEntryKit.display(entry: self.qualitySettingView, using: attributes);
        }else if(name == "timeLineView"){
            let widthConstraint = EKAttributes.PositionConstraints.Edge.constant(value: self.view.frame.width);
            let heightConstraint = EKAttributes.PositionConstraints.Edge.constant(value: self.view.frame.height);
            attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint);
            attributes.positionConstraints.rotation.isEnabled = false;
            attributes.name = "timeLineView";
            
            timeLineView.currentMatchId = currentMatch!.id!;
            timeLineView.currentMatch = currentMatch!;
            timeLineView.isEntry = true;
            SwiftEntryKit.display(entry: self.timeLineView, using: attributes);
        }else if(name == "statusView"){
            let heightConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 180);
            let widthConstraint = EKAttributes.PositionConstraints.Edge.constant(value: self.view.frame.width);
            attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint);
            attributes.positionConstraints.rotation.isEnabled = false;
            attributes.name = "statusVc";
            
            
            timeLineView.currentMatchId = currentMatch!.id!;
            timeLineView.currentMatch = currentMatch!;
            timeLineView.matchStatus = matchStatusModel!;
            timeLineView.isEntry = true;
            TimeLineViewModel.sharedInstance.initWith(timeLineView);
            timeLineView.viewModel = TimeLineViewModel.sharedInstance;
            SwiftEntryKit.display(entry: statusVc, using: attributes);
        }else if(name == "warterMarkSettingView"){
            let widthConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 500);
            let heightConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 250);
            attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint);
            attributes.positionConstraints.rotation.isEnabled = false;
            attributes.name = "warterMarkSettingView";
            
            SwiftEntryKit.display(entry: self.warterMarkSettingView, using: attributes);
        }else if(name == "scoreAndStatusVc"){
            let widthConstraint = EKAttributes.PositionConstraints.Edge.fill;
            let heightConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 190);
            attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint);
            let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: 20);
            let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset);
            attributes.positionConstraints.keyboardRelation = keyboardRelation;
            attributes.entryBackground = .color(color: .white);
            attributes.screenBackground = .color(color: UIColor(white: 50.0/255.0, alpha: 0.3));
            attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero));
//            attributes.roundCorners = .all(radius: 10)
            attributes.entranceAnimation = .translation;
            attributes.exitAnimation = .translation;
            attributes.displayDuration = .infinity;
            attributes.entryInteraction = .absorbTouches;
            attributes.screenInteraction = .dismiss;
            attributes.name = "scoreAndStatusVc";
            
            viewModel!.getMatchStatus(matchId: currentMatchId!, type: nil, callback: { (matchStatusModel) in
                self.matchStatusModel = matchStatusModel;
                self.timeLineView.currentMatchId = self.currentMatch!.id!;
                self.timeLineView.currentMatch = self.currentMatch!;
                self.timeLineView.matchStatus = self.matchStatusModel!;
                self.timeLineView.isEntry = true;
                TimeLineViewModel.sharedInstance.initWith(self.timeLineView);
                self.timeLineView.viewModel = TimeLineViewModel.sharedInstance;
                attributes.lifecycleEvents.didAppear = {
                    self.scoreAndStatusVc.refreshData()
                }
                SwiftEntryKit.display(entry: self.scoreAndStatusVc, using: attributes);
            }, disposeBag: disposeBag);
        }else if(name == "basketballTimelineVC"){
            let widthConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 375);
            let heightConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 260);
            attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint);
            let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: 20);
            let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset);
            attributes.positionConstraints.keyboardRelation = keyboardRelation;
            attributes.entryBackground = .color(color: .white);
            attributes.screenBackground = .color(color: UIColor(white: 50.0/255.0, alpha: 0.3));
            attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero));
//            attributes.roundCorners = .all(radius: 10)
            attributes.entranceAnimation = .translation;
            attributes.exitAnimation = .translation;
            attributes.displayDuration = .infinity;
            attributes.entryInteraction = .absorbTouches;
            attributes.screenInteraction = .dismiss;
            attributes.name = "basketballTimelineVC";
            
            basketballTimelineVc.match = currentMatch!;
            basketballTimelineVc.onSectionChangeClick = { (section) in
                let currentSection = Int(self.scoreBoardWarterMark_basketBall.lb_time.text!);
                if(currentSection! + section <= 0){
                    self.view.makeToast("请选择正确的节数",position: .center);
                    return;
                }
                self.scoreBoardWarterMark_basketBall.lb_time.text =  String(currentSection! + section);
                self.session!.warterMarkView = self.session!.warterMarkView;
            }
            SwiftEntryKit.display(entry: basketballTimelineVc, using: attributes);
        }
    }
    // 关闭
    @objc func didTappedCloseButton(_ button: UIButton) -> Void  {
        showSheet(title: "是否退出直播？", message: "") { (action) in
            self.session.stopLive();
            self.dismiss(animated: true);
        }
    }
    // 时间轴统计
    @objc func didTappedTimeLineButton(_ button: UIButton) -> Void  {
        if(self.isBasketBall){
            showEntry(name: "basketballTimelineVC")
        }else{
            showEntry(name: "timeLineView")
        }
    }
    // 比赛状态统计
    @objc func didTappedStatusButton(_ button: UIButton) -> Void  {
        if(self.isBasketBall){
            showEntry(name: "scoreAndStatusVc")
        }else{
            showEntry(name: "statusView")
        }
    }
    @objc func refreshData(){
        viewModel!.getMatchStatus(matchId: currentMatchId!, type: (isBasketBall ? ["score"] : nil), callback: { (matchStatusModel) in
            self.matchStatusModel = matchStatusModel;
            if(matchStatusModel != nil && matchStatusModel.score != nil){
                if(self.isBasketBall){
                    let scoreBoard = self.session!.warterMarkView?.viewWithTag(101) as! ScoreBoard2;
                    let score = matchStatusModel.score!.split(separator: "-");
                    scoreBoard.lb_hostscore.text = String(score[0]);
                    scoreBoard.lb_guestscore.text = String(score[1]);
                }else{
                    let scoreBoard = self.session!.warterMarkView?.viewWithTag(101) as! ScoreBoard;
                    let score = matchStatusModel.score!.split(separator: "-");
                    scoreBoard.lb_hostscore.text = String(score[0]);
                    scoreBoard.lb_guestscore.text = String(score[1]);
                }
            }
        }, disposeBag: disposeBag);
    }
    @objc func refreshQuality(){
        if(firstPush){
            firstPush = false;
            return;
        }
        if(!retryOpen){
            self.liveQualityLabel.isHidden = true;
            self.pushRetryTimes = 0;
            return;
        }
        viewModel?.activityQuality(activityId: currentMatch!.activityId!, callback: { (res) in
            switch (res.data) {
                case -1:
                    break;
                case 1:
                    let now = Int(Date().timeIntervalSince1970)
                    if (self.pushRetryTimes < self.MAX_RETRY_TIMES) {
                        self.session.stopLive();
                        let stream = LFLiveStreamInfo();
                        stream.url = self.pushUrl;
                        self.session.startLive(stream);
                        if (now - self.firstRetryTime <= 5 * 60) {
                            self.pushRetryTimes = self.pushRetryTimes + 1;
                        } else {
                            self.firstRetryTime = now;
                            self.pushRetryTimes = 1;
                        }
                        self.view.makeToast("网络不佳，推流重试:"+String(self.pushRetryTimes)+"次",position: .center);
                    } else {
                        self.liveQualityLabel.isHidden = false;
                    }
                    break;
                case 0:
                    if (self.pushRetryTimes >= self.MAX_RETRY_TIMES) {
                        self.liveQualityLabel.isHidden = true;
                        self.pushRetryTimes = 0;
                    }
                    break;
                case 2:
                    if (self.pushRetryTimes >= self.MAX_RETRY_TIMES) {
                        self.liveQualityLabel.isHidden = true;
                        self.pushRetryTimes = 0;
                    }
                    break;
                default:
                    break;
            }
            
        }, disposeBag: disposeBag);
    }
    //MARK: AccessAuth
    func requestAccessForVideo() -> Void {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video);
        switch status  {
        // 许可对话没有出现，发起授权许可
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if(granted){
                    DispatchQueue.main.async {
                        self.session.running = true
                    }
                }
            })
            break;
        // 已经开启授权，可继续
        case AVAuthorizationStatus.authorized:
            session.running = true;
            break;
        // 用户明确地拒绝授权，或者相机设备无法访问
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    
    func requestAccessForAudio() -> Void {
        let status = AVCaptureDevice.authorizationStatus(for:AVMediaType.audio)
        switch status  {
        // 许可对话没有出现，发起授权许可
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (granted) in
                
            })
            break;
        // 已经开启授权，可继续
        case AVAuthorizationStatus.authorized:
            break;
        // 用户明确地拒绝授权，或者相机设备无法访问
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    
    
}
