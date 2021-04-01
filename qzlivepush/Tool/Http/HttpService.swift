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
            .asObservable()
            .filterSuccess(target: target)
            .mapJSON()
            .showAPIErrorToast()
            .mapObject(type: ResponseModel<AuthModel>.self);
    }
    func leagues(pageNum:Int,pageSize:Int,name:String?,status:String?) -> Observable<PageModel<LeagueModel>> {
        let target = ApiManager.leagues(pageNum: pageNum, pageSize: pageSize, name: name, status: status);
        return provider.rx.request(target)
            .filter(statusCodes: 200...500)
            .asObservable()
            .filterSuccess(target: target)
            .mapJSON()
            .showAPIErrorToast()
            .mapObject(type: ResponseModel<PageModel<LeagueModel>>.self)
            .map { (result) -> PageModel<LeagueModel> in
                return result.data!
        };
    }
    func league(id:Int)-> Observable<LeagueModel> {
        let target = ApiManager.league(id: id);
        return provider.rx.request(target)
            .filter(statusCodes: 200...500)
            .asObservable()
            .filterSuccess(target: target)
            .mapJSON()
            .showAPIErrorToast()
            .mapObject(type: ResponseModel<LeagueModel>.self)
            .map { (result) -> LeagueModel in
                    return result.data!
            };
    }
    func matches(pageNum:Int,pageSize:Int,sortOrder:String,sortField:String,leagueId:Int?,round:String?)-> Observable<PageModel<MatchModel>> {
        let target = ApiManager.matches(pageNum: pageNum, pageSize: pageSize, sortOrder: sortOrder, sortField: sortField, leagueId: leagueId, round: round);
        return provider.rx.request(target)
            .filter(statusCodes: 200...500)
            .asObservable()
            .filterSuccess(target: target)
            .mapJSON()
            .showAPIErrorToast()
            .mapObject(type: ResponseModel<PageModel<MatchModel>>.self)
            .map { (result) -> PageModel<MatchModel> in
                    return result.data!
            };
    }
    func match(matchId:Int)-> Observable<MatchModel> {
        let target = ApiManager.match(matchId: matchId);
        return provider.rx.request(target)
            .filter(statusCodes: 200...500)
            .asObservable()
            .filterSuccess(target: target)
            .mapJSON()
            .showAPIErrorToast()
            .mapObject(type: ResponseModel<MatchModel>.self)
            .map { (result) -> MatchModel in
                    return result.data!
            };
    }
    func matchStatus(matchId:Int) -> Observable<MatchStatusModel> {
        let target = ApiManager.matchStatus(matchId: matchId);
        return provider.rx.request(target)
            .filter(statusCodes: 200...500)
            .asObservable()
            .filterSuccess(target: target)
            .mapJSON()
            .showAPIErrorToast()
            .mapObject(type: ResponseModel<MatchStatusModel>.self)
            .map { (result) -> MatchStatusModel in
                    return result.data!
            };
    }
    func addTimeLine(matchId:Int,teamId:Int?,eventType:Int,againstIndex:Int?,section:Int?,remark:String?) -> Observable<ResponseBoolModel>{
        let target = ApiManager.addTimeLine(matchId: matchId, teamId: teamId, eventType: eventType, againstIndex: againstIndex, section: section, remark: remark);
        return provider.rx.request(target)
            .filter(statusCodes: 200...500)
            .asObservable()
            .filterSuccess(target: target)
            .mapJSON()
            .showAPIErrorToast()
            .mapObject(type: ResponseBoolModel.self);
    }
    func deleteTimeLine(id:Int)-> Observable<ResponseBoolModel>{
        let target = ApiManager.deleteTimeLine(id: id);
        return provider.rx.request(target)
            .filter(statusCodes: 200...500)
            .asObservable()
            .filterSuccess(target: target)
            .mapJSON()
            .showAPIErrorToast()
            .mapObject(type: ResponseBoolModel.self);
    }
    func activity(activityId: String)-> Observable<ActivityModel>{
        let target = ApiManager.activity(activityId: activityId);
        return provider.rx.request(target)
            .filter(statusCodes: 200...500)
            .asObservable()
            .filterSuccess(target: target)
            .mapJSON()
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
            .asObservable()
            .filterSuccess(target: target)
            .mapJSON()
            .showAPIErrorToast()
            .mapObject(type: ResponseIntModel.self);
    }
}

//扩展Moya,刷新token
extension ObservableType where E == Response {

    func filterSuccess(target:TargetType) -> Observable<E> {
        return flatMap { (response) -> Observable<E> in
        
            if(response.statusCode == 401){
                let userDefault = UserDefaults.standard;
                let token = userDefault.string(forKey: Constant.KEY_REFRESH_TOKEN);
                if(token != nil){
                    return provider.rx.request(ApiManager.refreshToken(refreshToken: token!))
                        .mapJSON().asObservable()
                        .showAPIErrorToast()
                        .mapObject(type: ResponseModel<AuthModel>.self)
                        .flatMapLatest { (res) -> Observable<Response> in
                            if(res.data != nil){
                                let userDefault = UserDefaults.standard;
                                if(userDefault.object(forKey: Constant.KEY_ACCESS_TOKEN) != nil){
                                    userDefault.removeObject(forKey: Constant.KEY_ACCESS_TOKEN)
                                    userDefault.removeObject(forKey: Constant.KEY_REFRESH_TOKEN)
                                }
                                userDefault.set(res.data?.accessToken, forKey: Constant.KEY_ACCESS_TOKEN);
                                userDefault.set(res.data?.refreshToken, forKey: Constant.KEY_REFRESH_TOKEN);
                                userDefault.synchronize();
                            }
                            return provider.rx.request(target as! ApiManager).asObservable();
                        }
                }
            }

            return Observable.just(response)
        }
    }
}
