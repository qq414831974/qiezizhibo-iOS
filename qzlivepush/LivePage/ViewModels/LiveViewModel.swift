//
//  LiveViewModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/29.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import RxSwift

class LiveViewModel{
    var controller:LiveController?;
    var currentEvent:TimeLineEvent?;
    var currentTeam:TeamModel?;
    var currentPlayer:PlayerModel?;
    typealias Callback<T> = (_ res : T) -> Void
    
    func initWith(_ controller:LiveController?) {
        self.controller = controller;
    }
    class var sharedInstance: LiveViewModel {
        struct Static {
            static let instance: LiveViewModel = LiveViewModel()
        }
        return Static.instance
    }
    
    func getMatch(matchId:Int, callback:@escaping Callback<MatchModel>, disposeBag: DisposeBag) {
        HttpService().match(matchId: matchId).subscribe(onNext:{(res) in
            callback(res);
        }).disposed(by: disposeBag);
    }
    func getMatchStatus(matchId:Int, callback:@escaping Callback<MatchStatusModel>, disposeBag: DisposeBag){
        HttpService().matchStatus(matchId: matchId).subscribe(onNext:{(res) in
            callback(res);
        }).disposed(by: disposeBag);
    }
    func addTimeLine(matchId:Int,teamId:Int?,eventType:Int,againstIndex:Int?,section:Int?,remark:String?,callback:@escaping Callback<ResponseBoolModel>, disposeBag: DisposeBag){
        HttpService().addTimeLine(matchId: matchId, teamId: teamId, eventType: eventType, againstIndex: againstIndex, section: section, remark: remark).subscribe(onNext:{(res) in
            callback(res);
        }).disposed(by: disposeBag);
    }
    func deleteTimeLine(id:Int,callback:@escaping Callback<ResponseBoolModel>, disposeBag: DisposeBag){
        HttpService().deleteTimeLine(id: id).subscribe(onNext:{(res) in
            callback(res);
        }).disposed(by: disposeBag);
    }
    
    func getQuailtyIndex(quality:LFLiveVideoQuality) -> Int?{
        let qualitys:[Int:LFLiveVideoQuality] = [1:LFLiveVideoQuality.high6,2:LFLiveVideoQuality.high4,3:LFLiveVideoQuality.high5];
        for (key,value) in qualitys{
            if(value == quality){
                return key;
            }
        }
        return nil;
    }
    func getQualityName(quality:LFLiveVideoQuality) -> String{
        let index = getQuailtyIndex(quality:quality);
        let quailtys:[Int:String] = [1:"低",2:"中",3:"高"];
        return quailtys[index!]!;
    }
    func activity(activityId: String, callback:@escaping Callback<ActivityModel>, disposeBag: DisposeBag) {
        HttpService().activity(activityId: activityId).subscribe(onNext:{(res) in
            callback(res);
        }).disposed(by: disposeBag);
    }
    func activityQuality(activityId: String, callback:@escaping Callback<ResponseIntModel>, disposeBag: DisposeBag) {
        HttpService().activityQuality(activityId: activityId).subscribe(onNext:{(res) in
            callback(res);
        }).disposed(by: disposeBag);
    }
}
