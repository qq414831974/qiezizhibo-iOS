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
//    var scoreBoard:ScoreBoard!;
//    var scoreBoardWarterMark:ScoreBoard!;
    var scoreBoard:ScoreBoard!;
    var scoreBoardWarterMark:ScoreBoard!;
    var logoWarterMark:UIView!;
    
    var viewModel:LiveViewModel?;
    
    var qualitySettingView:LiveQualitySettingView!;
    var warterMarkSettingView:WarterMarkSettingView!;
    var statusVc: ChooseStatusController!
    var basketballTimelineVc: BasketballTimelineController!
        
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
    
    var hostTeamName:String = "", guestTeamName:String = "", hostTeamHeadImg:String?, guestTeamHeadImg:String?;
    var hostTeamId:Int?, guestTeamId:Int?;
    var section:Int = 1, againstIndex:Int = 1, hostScore:Int = 0, guestScore:Int = 0;
    
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
        x = self.view.bounds.height - 10 - 54;
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
        x = self.view.bounds.height - 10 - 54 * 2;
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
        x = self.view.bounds.height - 10 - 54 * 3;
        let startLiveButton = UIButton(frame: CGRect(x: x, y: self.view.bounds.width - 60, width: 44, height: 44))
        startLiveButton.setImage(UIImage(named: "play"), for: UIControl.State())
        startLiveButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        startLiveButton.layer.cornerRadius = 22
        startLiveButton.layer.masksToBounds = true
        return startLiveButton
    }()
    
    // 时间轴统计按钮
    lazy var timeLineButton: UIButton = {
        var x:CGFloat = 10 + 54 * 4;
        x = self.view.bounds.height - 10 - 54 * 5;
        let timeLineButton = UIButton(frame: CGRect(x: x, y: self.view.bounds.width - 60, width: 44, height: 44))
        timeLineButton.setImage(UIImage.svg(named: "flag.svg", size: CGSize.init(width: 30, height: 30)), for: UIControl.State())
        timeLineButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        timeLineButton.layer.cornerRadius = 22
        timeLineButton.layer.masksToBounds = true
        let y = self.view.bounds.width - 60
        return timeLineButton
    }()
    
    // 比赛状态统计按钮
    lazy var statusButton: UIButton = {
        var x:CGFloat = 10 + 54 * 3;
        x = self.view.bounds.height - 10 - 54 * 4;
        let statusButton = UIButton(frame: CGRect(x: x, y: self.view.bounds.width - 60, width: 44, height: 44))
        statusButton.setImage(UIImage.svg(named: "ball.svg", size: CGSize.init(width: 30, height: 30)), for: UIControl.State())
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
    func initWarterMarkView(){
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: videoConfiguration!.videoSize.width, height: videoConfiguration!.videoSize.height));
        
        //logo
        let imageView_logo = UIImageView.init(frame: CGRect.init(x: videoConfiguration!.videoSize.width * 0.0214, y: videoConfiguration!.videoSize.height * 0.023, width: videoConfiguration!.videoSize.width / 6, height: videoConfiguration!.videoSize.width / 6 / 2.818))
        imageView_logo.image = UIImage.init(named: "logo-t.png");
        imageView_logo.tag = 201;
        view.addSubview(imageView_logo);
        
        //比分牌
        scoreBoard = Bundle.main.loadNibNamed("ScoreBoard", owner: self, options: nil)!.first as! ScoreBoard;
        scoreBoard.frame = CGRect.init(x: view.bounds.width * 0.0214, y:  1080 - 232 - view.bounds.width * 0.0214, width: 600, height: 232);
        
        self.refreshAgainstTeamInfo(againstTeams: self.currentMatch!.againstTeams,matchStatus: self.currentMatch!.status);

        scoreBoard.setTeamNameHost(teamName: hostTeamName);
        scoreBoard.setTeamNameGuest(teamName: guestTeamName);
        scoreBoard.lb_hostscore.text = String(hostScore);
        scoreBoard.lb_guestscore.text = String(guestScore);
        scoreBoard.lb_time.text = String(section);
        if(currentMatch!.league != nil && (currentMatch!.league!.ruleType == 2 || currentMatch!.league!.ruleType == 3)){
            scoreBoard.showLogoMask();
        }else{
            scoreBoard.hideLogoMask();
        }
        
        self.scoreBoard.tag = 101;
        view.addSubview(scoreBoard);
        self.warterMarkView = view;
        self.session!.warterMarkView = self.warterMarkView;
        self.scoreBoardWarterMark = self.session!.warterMarkView?.viewWithTag(101) as! ScoreBoard;
        self.logoWarterMark = self.session!.warterMarkView?.viewWithTag(201);
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
        initWarterMarkView();
        self.requestAccessForVideo()
        self.requestAccessForAudio()
    }

    override func viewDidLoad() {
        super.viewDidLoad();
        appDelegate.interfaceOrientations = [.landscapeLeft]

        //注入
        viewModel = LiveViewModel.sharedInstance;
        viewModel!.initWith(self);
        
        TimeLineViewModel.sharedInstance.initWith(self);

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
                
        qualitySettingView = Bundle.main.loadNibNamed("LiveQualitySettingView", owner: self, options: nil)!.first as! LiveQualitySettingView;
        
        warterMarkSettingView = Bundle.main.loadNibNamed("WarterMarkSettingView", owner: self, options: nil)!.first as! WarterMarkSettingView;
                    
        statusVc = storyboard?.instantiateViewController(withIdentifier: "chooseStatusVC") as? ChooseStatusController;
        
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
    func refreshAgainstTeamInfo(againstTeams: Dictionary<String,MatchAgainstVOModel>? , matchStatus: MatchStatusModel?) {
            hostTeamName = "无";
            guestTeamName = "无";
            section = 1;
            hostScore = 0;
            guestScore = 0;
        if (againstTeams != nil && againstTeams!.count > 0) {
            for key in againstTeams!.keys{
                    //如果对阵方等于当前对阵方
                    if (matchStatus != nil && matchStatus!.againstIndex == Int(key)) {
                        let againstTeam: MatchAgainstVOModel  = againstTeams![key]!;
                        if (againstTeam != nil && againstTeam.hostTeam != nil) {
                            hostTeamId = againstTeam.hostTeam!.id!;
                            hostTeamHeadImg = againstTeam.hostTeam!.headImg!;
                            if (againstTeam.hostTeam!.shortName != nil) {
                                hostTeamName = againstTeam.hostTeam!.shortName!;
                            } else {
                                hostTeamName = againstTeam.hostTeam!.name!;
                            }
                        }
                        if (againstTeam != nil && againstTeam.guestTeam != nil) {
                            guestTeamId = againstTeam.guestTeam!.id!;
                            guestTeamHeadImg = againstTeam.guestTeam!.headImg!;
                            if (againstTeam.guestTeam!.shortName != nil) {
                                guestTeamName = againstTeam.guestTeam!.shortName!;
                            } else {
                                guestTeamName = againstTeam.guestTeam!.name!;
                            }
                        }
                        var score: String = "0-0";
                        if (matchStatus!.score != nil && matchStatus!.score!.keys.contains(key)) {
                            score = matchStatus!.score![key]!;
                        }
                        let againstScore = score.split(separator:"-");
                        hostScore = Int(againstScore[0])!;
                        guestScore = Int(againstScore[1])!;
                    }
                }
            }
            if (matchStatus != nil && matchStatus!.section != nil) {
                section = matchStatus!.section!;
            }
            if (matchStatus != nil && matchStatus!.againstIndex != nil) {
                againstIndex = matchStatus!.againstIndex!;
            }
        }
    func reloadScoreBoard() {
        let scoreBoard = self.session!.warterMarkView?.viewWithTag(101) as! ScoreBoard;
        scoreBoard.lb_hostscore.text = String(hostScore);
        scoreBoard.lb_guestscore.text = String(guestScore);
        scoreBoard.setTeamNameHost(teamName: hostTeamName);
        scoreBoard.setTeamNameGuest(teamName: guestTeamName);
        scoreBoard.lb_time.text = String(section);
        self.reloadWatermark();
    }
    func reloadWatermark() {
        self.session!.warterMarkView = self.session!.warterMarkView;
    }
    //MARK: - Events
    
    // 开始直播
    @objc func didTappedStartLiveButton(_ button: UIButton) -> Void {
        if (!startLiveButton.isSelected) {
            showSheet(title: "是否开始直播？", message: "") { (action) in
                self.refreshAgainstTeamInfo(againstTeams: self.currentMatch!.againstTeams, matchStatus: self.matchStatusModel);
                self.reloadScoreBoard();
                self.startLiveButton.isSelected = !self.startLiveButton.isSelected;
                self.startLiveButton.setImage(UIImage(named: "stop"), for: UIControl.State())
                let stream = LFLiveStreamInfo()
                stream.url = self.pushUrl;
                self.session.startLive(stream)
                self.bandWidthLabel.isHidden = false;
                self.qualitySettingView.slider_video.isEnabled = false;
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
        dropDown.dataSource = ["直播设置","比分牌设置"];
        dropDown.direction = .top;
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            if(index == 0){
                self.qualitySettingView.setUp();
                self.showEntry(name: "qualitySettingView");
            }else if(index == 1){
                let scoreBoard = self.warterMarkView!.viewWithTag(101) as! ScoreBoard;
                self.warterMarkSettingView.scoreBoard = scoreBoard;
                self.warterMarkSettingView.setUp();
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
        attributes.roundCorners = .all(radius: 10);
        if(name == "qualitySettingView"){
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
        }else if(name == "statusView"){
            let heightConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 180);
            let widthConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 400);
            attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint);
            attributes.positionConstraints.rotation.isEnabled = false;
            attributes.name = "statusVc";
            
            SwiftEntryKit.display(entry: statusVc, using: attributes);
        }else if(name == "warterMarkSettingView"){
            let widthConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 600);
            let heightConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 250);
            attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint);
            attributes.positionConstraints.rotation.isEnabled = false;
            attributes.name = "warterMarkSettingView";
            
            SwiftEntryKit.display(entry: self.warterMarkSettingView, using: attributes);
        }else if(name == "basketballTimelineVC"){
            let widthConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 375);
            let heightConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 220);
            attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint);
            let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: 20);
            let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset);
            attributes.positionConstraints.keyboardRelation = keyboardRelation;
            attributes.entryBackground = .color(color: .white);
            attributes.screenBackground = .color(color: UIColor(white: 50.0/255.0, alpha: 0.3));
            attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero));
            attributes.roundCorners = .all(radius: 10)
            attributes.entranceAnimation = .translation;
            attributes.exitAnimation = .translation;
            attributes.displayDuration = .infinity;
            attributes.entryInteraction = .absorbTouches;
            attributes.screenInteraction = .dismiss;
            attributes.name = "basketballTimelineVC";
            
//            basketballTimelineVc.onSectionChangeClick = { (sectionChange) in
//                let currentSection = Int(self.scoreBoardWarterMark_basketBall.lb_time.text!);
//                if(currentSection! + sectionChange <= 0){
//                    self.view.makeToast("请选择正确的节数",position: .center);
//                    return;
//                }
//                self.scoreBoardWarterMark_basketBall.lb_time.text =  String(currentSection! + sectionChange);
//                self.reloadWatermark();
//            }
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
        basketballTimelineVc.setUp();
        showEntry(name: "basketballTimelineVC")
    }
    // 比赛状态统计
    @objc func didTappedStatusButton(_ button: UIButton) -> Void  {
        statusVc.setUp();
        showEntry(name: "statusView")
    }
    @objc func refreshData(){
        viewModel!.getMatchStatus(matchId: currentMatchId!, callback: { (matchStatusModel) in
            self.matchStatusModel = matchStatusModel;
            if(matchStatusModel != nil){
                self.refreshAgainstTeamInfo(againstTeams: self.currentMatch!.againstTeams,matchStatus: matchStatusModel);
                self.reloadScoreBoard();
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
