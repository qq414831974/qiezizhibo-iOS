//
//  HttpService.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/5/22.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import SwiftyJSON
import RxSwift
import Moya
import ObjectMapper
var provider = MoyaProvider<ApiManager>.init(plugins:[NetworkLoggerPlugin(verbose: true)])

struct HttpService {
    func login(username: String, password: String) -> Observable<ResponseModel<AuthModel>> {
        let target = ApiManager.login(username: username, password: password);
        return provider.rx.request(target)
            .filter(statusCodes: 200...500)
//            .filterSuccelssfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: ResponseModel<AuthModel>.self);
    }
    func leagues(pageNum:Int,pageSize:Int,city:String?,country:String?,name:String?,status:String?) -> Observable<PageModel<LeagueModel>> {
        let target = ApiManager.leagues(pageNum: pageNum, pageSize: pageSize, city: city, country: country, name: name, status: status);
        return provider.rx.request(target)
            .filter(statusCodes: 200...399)
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: ResponseModel<PageModel<LeagueModel>>.self)
            .map { (result) -> PageModel<LeagueModel> in
                return result.data!
        };
    }
    func league(id:Int)-> Observable<LeagueModel> {
        let target = ApiManager.league(id: id);
        return provider.rx.request(target)
            .filter(statusCodes: 200...399)
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: ResponseModel<LeagueModel>.self)
            .map { (result) -> LeagueModel in
                    return result.data!
            };
    }
    func matches(pageNum:Int,pageSize:Int,leagueId:Int?,name:String?,round:[String?]?,status:String?,dateBegin:Date?,dateEnd:Date?,orderby:String?,isActivity:Bool?)-> Observable<PageModel<MatchModel>> {
        let target = ApiManager.matches(pageNum: pageNum, pageSize: pageSize, leagueId: leagueId,name: name, round: round, status: status, dateBegin: dateBegin, dateEnd: dateEnd, orderby: orderby, isActivity: isActivity);
        return provider.rx.request(target)
            .filter(statusCodes: 200...399)
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: ResponseModel<PageModel<MatchModel>>.self)
            .map { (result) -> PageModel<MatchModel> in
                    return result.data!
            };
    }
    func match(matchId:Int)-> Observable<MatchModel> {
        let target = ApiManager.match(matchId: matchId);
        return provider.rx.request(target)
            .filter(statusCodes: 200...399)
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: ResponseModel<MatchModel>.self)
            .map { (result) -> MatchModel in
                    return result.data!
            };
    }
    func matchStatus(matchId:Int,type:[String]?) -> Observable<MatchStatusModel> {
        let target = ApiManager.matchStatus(matchId: matchId, type: type);
        return provider.rx.request(target)
            .filter(statusCodes: 200...500)
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: ResponseModel<MatchStatusModel>.self)
            .map { (result) -> MatchStatusModel in
                    return result.data!
            };
    }
    func getMatchPlayersByTeamId(matchId:Int,teamId:Int) -> Observable<Array<PlayerModel>>{
        let target = ApiManager.getMatchPlayersByTeamId(matchId: matchId, teamId: teamId);
        return provider.rx.request(target)
            .filter(statusCodes: 200...399)
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: ResponseModel<PageModel<PlayerModel>>.self)
            .map { (result) -> Array<PlayerModel> in
                return result.data!.records!
            };
    }
    func addTimeLine(matchId:Int,teamId:Int?,playerId:Int?,eventtype:Int,minute:Int,remark:String?,text:String?) -> Observable<ResponseBoolModel>{
        let target = ApiManager.addTimeLine(matchId: matchId, teamId: teamId, playerId: playerId, eventtype: eventtype, minute: minute, remark: remark, text: text);
        return provider.rx.request(target)
            .filter(statusCodes: 200...500)
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: ResponseBoolModel.self);
    }
    func deleteTimeLine(id:Int)-> Observable<ResponseBoolModel>{
        let target = ApiManager.deleteTimeLine(id: id);
        return provider.rx.request(target)
            .filter(statusCodes: 200...500)
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: ResponseBoolModel.self);
    }
    func updateScoreAndStatus(matchId: Int, hostteamId: Int?, guestteamId: Int?, score: String, status: Int)-> Observable<ResponseBoolModel>{
        let target = ApiManager.updateScoreAndStatus(matchId: matchId, score: score, status: status);
        return provider.rx.request(target)
            .filter(statusCodes: 200...500)
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: ResponseBoolModel.self);
    }
    func activity(activityId: String)-> Observable<ActivityModel>{
        let target = ApiManager.activity(activityId: activityId);
        return provider.rx.request(target)
            .filter(statusCodes: 200...500)
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: ResponseModel<ActivityModel>.self)
            .map { (result) -> ActivityModel in
                return result.data!
            };
    }
    func activityQuality(activityId: String)-> Observable<ResponseIntModel>{
        let target = ApiManager.activityQuality(activityId: activityId);
        return provider.rx.request(target)
            .filter(statusCodes: 200...500)
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: ResponseIntModel.self);
    }
    func scoreboard()-> Observable<Array<ScoreBoardModel>>{
        let target = ApiManager.scoreboard;
        return provider.rx.request(target)
            .filter(statusCodes: 200...500)
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: ResponseArrayModel<ScoreBoardModel>.self)
            .map { (result) -> Array<ScoreBoardModel> in
                    return result.data!
            };
    }
}
//
////扩展Moya
//extension ObservableType where E == Response {
//
//    func filterSuccess(disposeBag:DisposeBag,target:TargetType) -> Observable<E> {
//        return flatMap { (response) -> Observable<E> in
//
//            guard 200 ... 299 ~= response.statusCode else{
//                return Observable.just(response)
//            }
//
//            let json = try JSON(data: response.data).dictionaryValue
//            guard let code = json["code"]?.intValue else{
//                return Observable.just(response)
//            }
////
////            //处理过期（过期的code是后台定好的）
////            guard code == ErrorCode.sys_tokenExpired.rawValue else{
////                return Observable.just(response)
////            }
////            //缓存过期是请求的target
////            UserManager.shared.needResendTarget = target
////
////            guard let target = UserManager.shared.needResendTarget else{
////                fatalError("没有target")
////            }
////            //更新token
////            let updateToken =  MineServices().updateToken()
////            //替换本地的token
////            updateToken.drive(onNext: { (json) in
////                let token = json.dictionaryValue["data"]?.dictionaryValue["token"]?.stringValue
////                UserManager.shared.loginInfo.token = token
////                UserManager.shared.updateLocalToken(json.dictionaryValue["data"]?.dictionaryValue["token"]?.stringValue ?? "")
////            }).disposed(by: disposeBag)
////
////            let updateTokenSuccess = updateToken.map{$0.dictionaryValue["code"]?.intValue == 0}
////
////            //利用flatMapLatest把上一次缓存的target发送出去
////            let responses = updateTokenSuccess.asObservable().flatMapLatest({ _ -> Observable<Response> in
//                return provider.rx.request(target).asObservable()
////            })
////
////            return responses
//
//        }
//    }
//}
