//
//  ApiManager.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/5/22.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//
import Moya

enum ApiManager {
    case login(username:String,password:String);
    case leagues(pageNum:Int,pageSize:Int,city:String?,country:String?,name:String?,status:String?);
    case league(id:Int);
    case matches(pageNum:Int,pageSize:Int,leagueId:Int?,name:String?,round:[String?]?,status:String?,dateBegin:Date?,dateEnd:Date?,orderby:String?,isActivity:Bool?);
    case match(matchId:Int);
    case matchStatus(matchId:Int,type:[String]?);
    case getMatchPlayersByTeamId(matchId:Int,teamId:Int);
    case addTimeLine(matchId:Int,teamId:Int?,playerId:Int?,eventtype:Int,minute:Int,remark:String?,text:String?);
    case deleteTimeLine(id:Int);
    case updateScoreAndStatus(matchId:Int,score:String,status:Int);
    case activity(activityId:String);
    case activityQuality(activityId:String);
    case scoreboard;
    case refreshToken(refreshToken:String);
}

extension ApiManager:TargetType{
    
    var baseURL: URL {
        return URL.init(string: "https://git.qiezizhibo.com")!
//        return URL.init(string: "http://192.168.170.103:8080")!
    }
    
    //请求路径
    var path:String{
        switch self {
        case .login(username: _, password:_):
            return "/service-admin/auth"
        case .leagues(pageNum: _, pageSize: _, city: _, country: _, name: _,status: _):
            return "/service-admin/football/league"
        case .league(id: let id):
            return "/service-admin/football/league/\(id)";
        case .matches(pageNum: _, pageSize: _, leagueId: _, name: _,round: _, status: _, dateBegin: _, dateEnd: _,orderby: _,isActivity: _):
            return "/service-admin/football/match"
        case .match(matchId: let matchId):
            return "/service-admin/football/match/" + String(matchId);
        case .matchStatus(matchId: _,type: _):
            return "/service-admin/football/timeline/status";
        case .getMatchPlayersByTeamId(matchId: _,teamId: _):
            return "/service-admin/football/player";
        case .addTimeLine(matchId: _,teamId: _,playerId: _,eventtype: _,minute: _,remark: _,text: _):
            return "/service-admin/football/timeline";
        case .deleteTimeLine(id: _):
            return "/service-admin/football/timeline";
        case .updateScoreAndStatus(matchId: _, score: _, status: _):
            return "/service-admin/football/match/score";
        case .activity(activityId: let activityId):
            return "/service-admin/activity/" + activityId;
        case .activityQuality(activityId: let activityId):
            return "/service-admin/activity/" + activityId + "/quality";
        case .scoreboard:
            return "/service-admin/sys/scoreboard";
        case .refreshToken(refreshToken: _):
            return "/service-admin/auth/refresh_token";
        }
    }
    
    var headers: [String : String]?{
        let userDefault = UserDefaults.standard;
        let token = userDefault.string(forKey: Constant.KEY_ACCESS_TOKEN);
        switch self {
        case .login(username: _, password:_):
            return ["Content-type" : "application/json"]
        case .refreshToken(refreshToken: _):
            return ["Content-type" : "application/json"]
        default:
            if(token != nil ){
                return ["Content-type" : "application/json" ,
                        "Authorization" : "Bearer " + token!]
            }
            return ["Content-type" : "application/json"]
        }
    }
    //    //请求的参数
    //    var parameters: [String: Any]? {
    //        switch self {
    //        case .login(username: _, password:_):
    //            return ["userName":userName,"passWord":pwd];
    //
    //        }
    //
    //    }
    
    ///请求方式
    var method: Moya.Method {
        switch self {
        case .login(username: _, password: _):
            return .post;
        case .leagues(pageNum: _, pageSize: _, city: _, country: _, name: _, status: _):
            return .get;
        case .league(id: _):
            return .get;
        case .matches(pageNum: _, pageSize: _, leagueId: _, name: _, round: _, status: _, dateBegin: _, dateEnd: _, orderby: _, isActivity: _):
            return .get;
        case .match(matchId: _):
            return .get;
        case .matchStatus(matchId: _, type: _):
            return .get;
        case .getMatchPlayersByTeamId(matchId: _, teamId: _):
            return .get;
        case .addTimeLine(matchId: _, teamId: _, playerId: _, eventtype: _, minute: _, remark: _, text: _):
            return .post;
        case .deleteTimeLine(id: _):
            return .delete;
        case .updateScoreAndStatus(matchId: _, score: _, status: _):
            return .put;
        case .activity(activityId: _):
            return .get;
        case .activityQuality(activityId: _):
            return .get;
        case .scoreboard:
            return .get;
        case .refreshToken(refreshToken: _):
            return .post;
        }
    }
    
    /// The method used for parameter encoding.
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    /// Provides stub data for use in testing.
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    //MARK:task type
    var task: Task {
        switch self {
        case .login(username: let userName, password: let pwd):
            return .requestData(jsonToData(jsonDic: ["userName": userName  ,"password": pwd])!);
        case .leagues(pageNum: let pageNum, pageSize: let pageSize, city: let city, country: let country, name: let name, status: let status):
            var params:[String:Any] = ["pageNum":pageNum,"pageSize":pageSize,"sortField":"sortIndex","sortOrder":"desc","leagueType":4];
            if(city != nil){params["city"] = city;}
            if(country != nil){params["country"] = country;}
            if(name != nil){params["name"] = name;}
            if(status != nil){params["status"] = status;}
            return .requestParameters(parameters: params, encoding: URLEncoding.default);
        case .league(id: _):
            return .requestPlain;
        case .matches(pageNum: let pageNum, pageSize: let pageSize, leagueId: let leagueId, name: let name, round: let round, status: let status, dateBegin: let dateBegin, dateEnd: let dateEnd,orderby: let orderby, isActivity: let isActivity):
            var params:[String:Any] = ["pageNum":pageNum,"pageSize":pageSize];
            if(leagueId != nil){params["leagueId"] = leagueId;}
            if(name != nil){params["name"] = name;}
            if(round != nil){
                var roundString = "";
                for index in 0..<round!.count {
                    if(index != 0){
                        roundString = "\(roundString),\(round![index]!)"
                    }else{
                        roundString = round![index]!
                    }
                }
                params["round"] = roundString;
            }
            if(status != nil){params["status"] = status;}
            if(dateBegin != nil && dateEnd != nil){params["dateBegin"] = dateBegin;params["dateEnd"] = dateEnd;}
            if(orderby != nil){params["sortField"] = orderby;}
            if(isActivity != nil){params["isActivity"] = isActivity;}
            return .requestParameters(parameters: params, encoding: URLEncoding.default);
        case .match(matchId: _):
            return .requestPlain;
        case .matchStatus(matchId: let matchId, type: let type):
            var params:[String:Any] = ["matchId":matchId];
            if(type != nil){params["type"] = type!.joined(separator: ",");}
            return .requestParameters(parameters: params, encoding: URLEncoding.default);
        case .getMatchPlayersByTeamId(matchId: _, teamId: let teamId):
            let params:[String:Int] = ["teamId":teamId,"pageNum":1,"pageSize":100];
            return .requestParameters(parameters: params, encoding: URLEncoding.default);
        case .addTimeLine(matchId: let matchId, teamId: let teamId, playerId: let playerId, eventtype: let eventtype, minute: let minute, remark: let remark, text: let text):
            var params:[String:Any] = ["matchId":matchId,"eventType":eventtype,"minute":minute];
            if(teamId != nil){params["teamId"] = teamId;}
            if(playerId != nil){params["playerId"] = playerId;}
            if(remark != nil){params["remark"] = remark;}
            if(text != nil){params["text"] = text;}
            return .requestData(jsonToData(jsonDic: params)!);
        case .deleteTimeLine(id: let id):
            let params:[String:Any] = ["id":id];
            return .requestParameters(parameters: params, encoding: URLEncoding.default);
        case .updateScoreAndStatus(matchId: let matchId, score: let score, status: let status):
            let params:[String:Any] = ["id":matchId,"status":status,"score":score];
            return .requestData(jsonToData(jsonDic: params)!);
        case .activity(activityId: _):
            return .requestPlain;
        case .activityQuality(activityId: _):
            return .requestPlain;
        case .scoreboard:
            return .requestPlain;
        case .refreshToken(refreshToken: let refreshToken):
            let params:[String:String] = ["refresh_token":refreshToken];
            return .requestData(jsonToData(jsonDic: params)!);
        }
    }
    
    var validate: Bool {
        return false
    }
    
    //字典转Data
    private func jsonToData(jsonDic:Dictionary<String, Any>) -> Data? {
        if (!JSONSerialization.isValidJSONObject(jsonDic)) {
            print("is not a valid json object")
            return nil
        }
        //利用自带的json库转换成Data
        //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
        let data = try? JSONSerialization.data(withJSONObject: jsonDic, options: [])
        //Data转换成String打印输出
        let str = String(data:data!, encoding: String.Encoding.utf8)
        //输出json字符串
        print("Json Str:\(str!)")
        return data
    }
}
