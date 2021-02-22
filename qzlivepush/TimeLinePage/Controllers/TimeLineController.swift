//
//  TimeLineController.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/15.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit
import RxSwift
import XLPagerTabStrip
import ObjectMapper
import FloatingPanel
import SwiftEntryKit

class TimeLineController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var tv_timeLine: UITableView!
    
    var fpc: FloatingPanelController!
    var fpc_team: FloatingPanelController!
    var fpc_player: FloatingPanelController!
    var fpc_timeRemark: FloatingPanelController!
    var teamVc: ChooseTeamController!
    var eventVc: ChooseEventController!
    var playerVc: ChoosePlayerController!
    var timeRemarkVc: TimeAndRemarkController!
    var statusVc: ChooseStatusController!
    var scoreAndStatusVc: ScoreAndStatusController!
//    var editEventVc:EditEventController!
    
    @IBOutlet var header: TimeLineTableHeader!
    
    var viewModel:TimeLineViewModel?;
    let disposeBag = DisposeBag();
    var timeLineList:[TimeLineModel] = [TimeLineModel]();
    var passAndPassionList:[TimeLineModel] = [TimeLineModel]();
    var matchStatus:MatchStatusModel?;
    var currentMatchId:Int?;
    var currentMatch:MatchModel?;
    var currentDeleteEvent:TimeLineModel?;
    var isEntry:Bool = false;
    var timer:Timer?;
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(currentMatch != nil && timeLineList.count > 0){
            return self.timeLineList.count;
        }
        return 0;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index:Int = indexPath.row;
        if(currentMatch != nil && timeLineList.count > 0){
            var cell:TimeLineCell? = nil;
            let timeline:TimeLineModel = self.timeLineList[index > self.timeLineList.count ? 0 : index];
            
            if(currentMatch?.hostteam!.id! ==  timeline.teamId){
                cell = tableView.dequeueReusableCell(withIdentifier: "leftTimeLineID",for: indexPath) as! TimeLineCellLeft;
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: "rightTimeLineID",for: indexPath) as! TimeLineCellRight;
            }
            
            let event:TimeLineEvent = Constant.EVENT_TYPE[timeline.eventType!]!;
            cell!.setEventImg(img: UIImage.svg(named: event.icon,size: CGSize.init(width: 35, height: 35)));
            cell!.setEventName(eventName: event.text);
            if(event.type != TimeLineEvent.timeEvent){
                cell!.setMinute(minute: timeline.time!);
            }else{
                cell!.setMinute(minute: nil);
            }
            if(timeline.player != nil){
                cell!.setPlayerImg(url: timeline.player!.headImg);
                cell!.setPlayerName(name: timeline.player!.name!);
                cell!.showPlayer();
            }else{
                cell!.hidePlayer();
            }
            if(timeline.remark != nil && timeline.eventType == 10){
                cell!.setSecondEventImg(img: UIImage.svg(named: "substitution_arrow.svg",size: CGSize.init(width: 35, height: 35)));
                let player:PlayerModel?;
                do{
                    player = try Mapper<PlayerModel>().map(JSONString: timeline.remark!);
                    cell!.setSecondPlayerImg(url: player!.headImg);
                    cell!.setSecondPlayerName(name: player!.name!);
                    cell!.showSecondPlayer();
                }catch{
                    cell!.hideSecondPlayer();
                }
            }else{
                cell!.hideSecondPlayer();
            }
            if(timeline == timeLineList.first!){
                cell!.divideInTop();
            }else if(timeline != timeLineList.last!){
                cell!.divideNormal();
            }
            if(timeline == timeLineList.last!){
                cell!.divideInBottom();
            }else if(timeline != timeLineList.first!){
                cell!.divideNormal();
            }
            cell!.tag = index;
            let tap = UITapGestureRecognizer(target:self, action:#selector(showEditEvent));
            cell!.isUserInteractionEnabled = true;
            cell!.addGestureRecognizer(tap);
            return cell!;
        }
        return UITableViewCell();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        let img = UIImage.svg(named: "finish.svg", size: CGSize.init(width: 30, height: 30)).withRenderingMode(UIImage.RenderingMode.alwaysOriginal);
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: img, style: UIBarButtonItem.Style.plain, target: self, action: #selector(onRightBarClick));
        
        teamVc = storyboard?.instantiateViewController(withIdentifier: "chooseTeamVC") as? ChooseTeamController;
        eventVc = storyboard?.instantiateViewController(withIdentifier: "chooseEventVC") as? ChooseEventController;
        playerVc = storyboard?.instantiateViewController(withIdentifier: "choosePlayerVC") as? ChoosePlayerController;
        timeRemarkVc = storyboard?.instantiateViewController(withIdentifier: "chooseTimeRemarkVC") as? TimeAndRemarkController;
        statusVc = storyboard?.instantiateViewController(withIdentifier: "chooseStatusVC") as? ChooseStatusController;
        scoreAndStatusVc = storyboard?.instantiateViewController(withIdentifier: "scoreAndStatusVc") as? ScoreAndStatusController;
//        editEventVc = storyboard?.instantiateViewController(withIdentifier: "editEventVc") as? EditEventController;
        
        //floatPanel
        fpc = FloatingPanelController()
        fpc.delegate = eventVc
        fpc_team = FloatingPanelController()
        fpc_team.delegate = teamVc
        fpc_player = FloatingPanelController()
        fpc_player.delegate = playerVc
        fpc_timeRemark = FloatingPanelController()
        fpc_timeRemark.delegate = timeRemarkVc
        
        // Initialize FloatingPanelController and add the view
        fpc.surfaceView.backgroundColor = UIColor.white.withAlphaComponent(0.97);
        fpc.surfaceView.cornerRadius = 24.0
        fpc.surfaceView.borderWidth = 1.0 / traitCollection.displayScale
        fpc.surfaceView.borderColor = UIColor.black.withAlphaComponent(0.2)
        
        fpc_team.surfaceView.backgroundColor = UIColor.white.withAlphaComponent(0.97);
        fpc_team.surfaceView.cornerRadius = 24.0
        fpc_team.surfaceView.borderWidth = 1.0 / traitCollection.displayScale
        fpc_team.surfaceView.borderColor = UIColor.black.withAlphaComponent(0.2)
        
        fpc_player.surfaceView.backgroundColor = UIColor.white.withAlphaComponent(0.97);
        fpc_player.surfaceView.cornerRadius = 24.0
        fpc_player.surfaceView.borderWidth = 1.0 / traitCollection.displayScale
        fpc_player.surfaceView.borderColor = UIColor.black.withAlphaComponent(0.2)
        
        fpc_timeRemark.surfaceView.backgroundColor = UIColor.white.withAlphaComponent(0.97);
        fpc_timeRemark.surfaceView.cornerRadius = 24.0
        fpc_timeRemark.surfaceView.borderWidth = 1.0 / traitCollection.displayScale
        fpc_timeRemark.surfaceView.borderColor = UIColor.black.withAlphaComponent(0.2)
        
        // Set a content view controller
        fpc.set(contentViewController: eventVc)
        fpc.track(scrollView: eventVc.collectionView)
        
        fpc_team.set(contentViewController: teamVc)
        
        fpc_player.set(contentViewController: playerVc)
        fpc_player.track(scrollView: playerVc.collectionView)
        
        fpc_timeRemark.set(contentViewController: timeRemarkVc)
        
        fpc.addPanel(toParent: self, belowView: nil, animated: false)
        
        //header
        let tap = UITapGestureRecognizer(target:self, action:#selector(showEditScore));
        header!.lb_score.isUserInteractionEnabled = true;
        header!.lb_score.addGestureRecognizer(tap);
        if(isEntry){
            header.btn_close.isHidden = false;
        }else{
            header.btn_close.isHidden = true;
        }
        //注入
        viewModel = TimeLineViewModel.sharedInstance;
        viewModel!.initWith(self);
        
        navigationItem.title = currentMatch!.name!;
        navigationController?.navigationBar.titleTextAttributes = (NSDictionary(object: UIFont.systemFont(ofSize: 12), forKey: NSAttributedString.Key.font as NSCopying) as! [NSAttributedString.Key : Any])
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.getMatch(matchId: currentMatchId!, disposeBag: disposeBag);
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if(timer != nil){
            timer!.invalidate()
        }
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(refreshData), userInfo: nil, repeats: true)
        //开始计时器
        timer!.fire()
    }
    //刷新表格
    func reloadData(){
        tv_timeLine.reloadData();
        self.tv_timeLine.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false);
        self.tv_timeLine.es.stopLoadingMore();
    }
    //刷新数据
    @objc func refreshData(){
        self.tv_timeLine.es.resetNoMoreData();
        self.timeLineList.removeAll();
        viewModel?.getMatchStatus(matchId: currentMatchId!, type: nil, disposeBag: disposeBag);
    }
    //设置主客队
    func setTeamData(match:MatchModel){
        if(match != nil && match.hostteam != nil && match.guestteam != nil){
            teamVc.setHostImg(url: match.hostteam!.headImg,tag: match.hostteam!.id!);
            teamVc.setGuestImg(url: match.guestteam!.headImg,tag: match.guestteam!.id!);
            teamVc.lb_host.text = match.hostteam!.name;
            teamVc.lb_guest.text = match.guestteam!.name;
            
            header.setHostImg(url: match.hostteam!.headImg);
            header.setGuestImg(url: match.guestteam!.headImg);
            header.lb_host.text = match.hostteam!.name;
            header.lb_guest.text = match.guestteam!.name;
            
//            editEventVc!.teamList.append(match.hostteam!);
//            editEventVc!.teamList.append(match.guestteam!);
        }
    }
    @objc func onRightBarClick(){
        var attributes = EKAttributes.topFloat;
        let widthConstraint = EKAttributes.PositionConstraints.Edge.fill;
        let heightConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 180);
        attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint);
        attributes.entryBackground = .color(color: .white);
        attributes.screenBackground = .color(color: UIColor(white: 50.0/255.0, alpha: 0.3));
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero));
        attributes.entranceAnimation = .translation;
        attributes.exitAnimation = .translation;
        attributes.displayDuration = .infinity;
        attributes.entryInteraction = .absorbTouches;
        attributes.screenInteraction = .dismiss;
        attributes.name = "statusVc";
        
        SwiftEntryKit.display(entry: statusVc, using: attributes);
    }
    @objc func showEditEvent(sender:UITapGestureRecognizer){
        //        var attributes = EKAttributes.centerFloat;
        //        let widthConstraint = EKAttributes.PositionConstraints.Edge.fill;
        //        let heightConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 600);
        //        attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint);
        //        attributes.entryBackground = .color(color: .groupTableViewBackground);
        //        attributes.screenBackground = .color(color: UIColor(white: 50.0/255.0, alpha: 0.3));
        //        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero));
        //        attributes.entranceAnimation = .translation;
        //        attributes.exitAnimation = .translation;
        //        attributes.displayDuration = .infinity;
        //        attributes.entryInteraction = .absorbTouches;
        //        attributes.screenInteraction = .dismiss;
        //        attributes.name = "editEventVc";
        //
        //        let index = sender.view!.tag;
        //        let timeline:TimeLineModel = self.timeLineList[index > self.timeLineList.count ? 0 : index];
        //        editEventVc!.currentTimeLineEvent = timeline;
        //
        //        SwiftEntryKit.display(entry: editEventVc, using: attributes);
        let index = sender.view!.tag;
        let timeline:TimeLineModel = self.timeLineList[index > self.timeLineList.count ? 0 : index];
        let event:TimeLineEvent = Constant.EVENT_TYPE[timeline.eventType!]!;
        currentDeleteEvent = timeline;
        let alertController = UIAlertController(title: "是否删除此事件？", message: event.text + "在" + String(timeline.time ?? 0) + "分钟", preferredStyle: .actionSheet);
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil);
        let confirmAction = UIAlertAction(title: "确定", style: .destructive, handler: self.handleDeleteConfirm);
        alertController.addAction(cancelAction);
        alertController.addAction(confirmAction);
        self.present(alertController, animated: true, completion: nil);
    }
    @objc func showEditScore(sender:UIGestureRecognizer){
        var attributes = EKAttributes.centerFloat;
        let widthConstraint = EKAttributes.PositionConstraints.Edge.fill;
        let heightConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 190);
        attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint);
        let offset = EKAttributes.PositionConstraints.KeyboardRelation.Offset(bottom: 10, screenEdgeResistance: 20);
        let keyboardRelation = EKAttributes.PositionConstraints.KeyboardRelation.bind(offset: offset);
        attributes.positionConstraints.keyboardRelation = keyboardRelation;
        attributes.entryBackground = .color(color: .white);
        attributes.screenBackground = .color(color: UIColor(white: 50.0/255.0, alpha: 0.3));
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero));
//        attributes.roundCorners = .all(radius: 10)
        attributes.entranceAnimation = .translation;
        attributes.exitAnimation = .translation;
        attributes.displayDuration = .infinity;
        attributes.entryInteraction = .absorbTouches;
        attributes.screenInteraction = .dismiss;
        attributes.name = "scoreAndStatusVc";
        
        SwiftEntryKit.display(entry: scoreAndStatusVc, using: attributes);
    }
    @objc func handleDeleteConfirm(action: UIAlertAction){
        if(currentDeleteEvent != nil){
            viewModel!.deleteTimeLine(id: currentDeleteEvent!.id!, callback: { (response) in
                if(response.data != nil && response.data!){
                    self.view.makeToast("删除成功");
                }else{
                    self.view.makeToast(response.message);
                }
                self.refreshData();
            }, disposeBag: disposeBag)
        }
    }
}
class TimeLineTableHeader:UIView{
    @IBOutlet weak var iv_host: UIImageView!
    
    @IBOutlet weak var iv_guest: UIImageView!
    
    @IBOutlet weak var lb_host: UILabel!
    
    @IBOutlet weak var lb_guest: UILabel!
    
    @IBOutlet weak var lb_score: UILabel!
    
    @IBOutlet weak var lb_minute: UILabel!
    
    @IBOutlet weak var lb_status: UILabel!
    
    @IBOutlet weak var btn_close: UIButton!
    
    override func awakeFromNib() {
        btn_close.isHidden = true;
        btn_close.addTarget(self, action: #selector(onBtnCloseClick), for: UIControl.Event.touchUpInside);
    }
    
    @objc func onBtnCloseClick(){
        SwiftEntryKit.dismiss()
    }
    
    func setHostImg(url: String?) {
        if(url == nil){
            iv_host.image = UIImage.init(named: "defaultAvatar.jpg")
        }else{
            iv_host.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "defaultAvatar.jpg"));
        }
    }
    func setGuestImg(url: String?) {
        if(url == nil){
            iv_guest.image = UIImage.init(named: "defaultAvatar.jpg")
        }else{
            iv_guest.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "defaultAvatar.jpg"));
        }
    }
}
