//
//  TimeLineViewModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/15.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import RxSwift

class TimeLineViewModel {
    var controller: TimeLineController?;
    var liveController: LiveController?;
    var currentEvent:TimeLineEvent?;
    var currentTeam:TeamModel?;
    var currentPlayer:PlayerModel?;
    typealias Callback<T> = (_ res : T) -> Void
    
    func initWith(_ controller:TimeLineController?) {
        self.controller = controller;
    }
    func addLiveController(_ liveController:LiveController?){
        self.liveController = liveController;
    }
    class var sharedInstance: TimeLineViewModel {
        struct Static {
            static let instance: TimeLineViewModel = TimeLineViewModel()
        }
        return Static.instance
    }
    
    func getMatch(matchId:Int, disposeBag: DisposeBag) {
        HttpService().match(matchId: matchId).subscribe(onNext:{(res) in
            self.controller!.currentMatch = res;
            self.controller!.refreshData();
            self.controller!.startTimer();
            self.controller!.setTeamData(match: res);
        }).disposed(by: disposeBag);
    }
    func getMatchStatus(matchId:Int, type: [String]?, disposeBag: DisposeBag){
        HttpService().matchStatus(matchId: matchId,type: type).subscribe(onNext:{(res) in
            self.controller!.matchStatus = res;
            self.controller!.header.lb_score.text = res.score;
            self.controller!.header.lb_status.text = Constant.EVENT_TYPE[res.status!]!.text;
            if(self.controller!.timeRemarkVc != nil && res.time != nil){
                self.controller!.timeRemarkVc.tf_time.text = String(res.time!);
                self.controller!.header.lb_minute.text = String(res.time!) + "'";
            }else{
                self.controller!.header.lb_minute.isHidden = true;
            }
            if(res.timeLines != nil){
                var timelineList = [TimeLineModel]();
                var passAndPassion = [TimeLineModel]();
                for timeline in res.timeLines! {
                    if(timeline.eventType != 23){
                        timelineList.append(timeline);
                    }else{
                        passAndPassion.append(timeline);
                    }
                }
                self.controller!.timeLineList = timelineList;
                self.controller!.passAndPassionList = passAndPassion;
            }
            self.controller!.reloadData();
        }).disposed(by: disposeBag);
    }
    func getMatchPlayersByTeamId(matchId:Int, teamId:Int, callback:@escaping Callback<[PlayerModel]>, disposeBag: DisposeBag){
        HttpService().getMatchPlayersByTeamId(matchId: matchId,teamId: teamId).subscribe(onNext:{(res) in
            callback(res);
        }).disposed(by: disposeBag);
    }
    func addTimeLine(matchId:Int,teamId:Int?,playerId:Int?,eventtype:Int,minute:Int,remark:String?,text:String?,callback:@escaping Callback<ResponseBoolModel>, disposeBag: DisposeBag){
        HttpService().addTimeLine(matchId: matchId, teamId: teamId, playerId: playerId, eventtype: eventtype, minute: minute, remark: remark, text: text).subscribe(onNext:{(res) in
            callback(res);
        }).disposed(by: disposeBag);
    }
    func deleteTimeLine(id:Int,callback:@escaping Callback<ResponseBoolModel>, disposeBag: DisposeBag){
        HttpService().deleteTimeLine(id: id).subscribe(onNext:{(res) in
            callback(res);
        }).disposed(by: disposeBag);
    }
    func updateScoreAndStatus(matchId: Int, hostteamId: Int?, guestteamId: Int?, score: String, status: Int, callback:@escaping Callback<ResponseBoolModel>, disposeBag: DisposeBag) {
        HttpService().updateScoreAndStatus(matchId: matchId, hostteamId: hostteamId, guestteamId: guestteamId, score: score, status: status).subscribe(onNext:{(res) in
            callback(res);
        }).disposed(by: disposeBag);
    }
}
