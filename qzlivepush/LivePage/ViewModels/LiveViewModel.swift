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
    func getMatchStatus(matchId:Int, type: [String]?, callback:@escaping Callback<MatchStatusModel>, disposeBag: DisposeBag){
        HttpService().matchStatus(matchId: matchId,type: type).subscribe(onNext:{(res) in
            callback(res);
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
    func scoreboard(callback:@escaping Callback<[ScoreBoardModel]>, disposeBag: DisposeBag) {
        HttpService().scoreboard().subscribe(onNext:{(res) in
            callback(res);
        }).disposed(by: disposeBag);
    }
    func isPureTimeFormat(string: String) -> Bool {
        if (string.contains(":") == false && string != "" && string != ":"){
            return false;
        }
        let timeArray = string.split(separator: ":");
        if(timeArray.count > 2){
            return false;
        }
        if(string.hasPrefix(":")){
            return false;
        }
        if(string.hasSuffix(":")){
            return false;
        }
        var str = string.trimmingCharacters(in: CharacterSet.decimalDigits)
        str = str.trimmingCharacters(in: CharacterSet.init(charactersIn: ":"))
        if(str.count > 0){
            return false
        }
        return true
    }
}
