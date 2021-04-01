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
    case leagues(pageNum:Int,pageSize:Int,name:String?,status:String?);
    case league(id:Int);
    case matches(pageNum:Int,pageSize:Int,sortOrder:String,sortField:String,leagueId:Int?,round:String?);
    case match(matchId:Int);
    case matchStatus(matchId:Int);
    case addTimeLine(matchId:Int,teamId:Int?,eventType:Int,againstIndex:Int?,section:Int?,remark:String?);
    case deleteTimeLine(id:Int);
    case activity(activityId:String);
    case activityQuality(activityId:String);
    case refreshToken(refreshToken:String);
}

extension ApiManager:TargetType{
    
    var baseURL: URL {
        return URL.init(string: "https://basketball.qiezizhibo.com")!
    }
    
    //请求路径
    var path:String{
        switch self {
        case .login(username: _, password:_):
            return "/service-admin/auth"
        case .leagues(pageNum: _, pageSize: _, name: _,status: _):
            return "/service-admin/basketball/league"
        case .league(id: let id):
            return "/service-admin/basketball/league/\(id)";
        case .matches(pageNum: _, pageSize: _, sortOrder: _, sortField: _, leagueId: _, round: _):
            return "/service-admin/basketball/match"
        case .match(matchId: let matchId):
            return "/service-admin/basketball/match/" + String(matchId);
        case .matchStatus(matchId: _):
            return "/service-admin/basketball/timeline/status";
        case .addTimeLine(matchId: _,teamId: _,eventType: _,againstIndex: _,section: _,remark: _):
            return "/service-admin/basketball/timeline";
        case .deleteTimeLine(id: _):
            return "/service-admin/football/timeline";
        case .activity(activityId: let activityId):
            return "/service-admin/activity/" + activityId;
        case .activityQuality(activityId: let activityId):
            return "/service-admin/activity/" + activityId + "/quality";
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
        case .leagues(pageNum: _, pageSize: _, name: _, status: _):
            return .get;
        case .league(id: _):
            return .get;
        case .matches(pageNum: _, pageSize: _, sortOrder: _, sortField: _, leagueId: _, round: _):
            return .get;
        case .match(matchId: _):
            return .get;
        case .matchStatus(matchId: _):
            return .get;
        case .addTimeLine(matchId: _, teamId: _, eventType: _, againstIndex: _, section: _, remark: _):
            return .post;
        case .deleteTimeLine(id: _):
            return .delete;
        case .activity(activityId: _):
            return .get;
        case .activityQuality(activityId: _):
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
        case .leagues(pageNum: let pageNum, pageSize: let pageSize, name: let name, status: let status):
            var params:[String:Any] = ["pageNum":pageNum,"pageSize":pageSize,"sortField":"sortIndex","sortOrder":"desc","leagueType":4];
            if(name != nil){params["name"] = name;}
            if(status != nil){params["status"] = status;}
            return .requestParameters(parameters: params, encoding: URLEncoding.default);
        case .league(id: _):
            return .requestPlain;
        case .matches(pageNum: let pageNum, pageSize: let pageSize, sortOrder: let sortOrder,  sortField: let sortField, leagueId: let leagueId, round: let round):
            var params:[String:Any] = ["pageNum":pageNum,"pageSize":pageSize,"sortOrder":sortOrder,"sortField":sortField];
            if(leagueId != nil){params["leagueId"] = leagueId;}
            if(round != nil){
                params["round"] = round;
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.default);
        case .match(matchId: _):
            return .requestPlain;
        case .matchStatus(matchId: let matchId):
            let params:[String:Any] = ["matchId":matchId];
            return .requestParameters(parameters: params, encoding: URLEncoding.default);
        case .addTimeLine(matchId: let matchId, teamId: let teamId, eventType: let eventType, againstIndex: let againstIndex, section: let section, remark: let remark):
            var params:[String:Any] = ["matchId":matchId,"eventType":eventType];
            if(teamId != nil){params["teamId"] = teamId;}
            if(againstIndex != nil){params["againstIndex"] = againstIndex;}
            if(section != nil){params["section"] = section;}
            if(remark != nil){params["remark"] = remark;}
            return .requestData(jsonToData(jsonDic: params)!);
        case .deleteTimeLine(id: let id):
            let params:[String:Any] = ["id":id];
            return .requestParameters(parameters: params, encoding: URLEncoding.default);
        case .activity(activityId: _):
            return .requestPlain;
        case .activityQuality(activityId: _):
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
