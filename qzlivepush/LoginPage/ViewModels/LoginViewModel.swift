//
//  LoginViewModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/5/28.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import Moya
import RxSwift
import Toast_Swift

class LoginViewModel {
    var controller: LoginViewController?;
    
    init(_ controller:LoginViewController?) {
        self.controller = controller;
    }
    
    func login(username: String?, password: String?, isRemember: Bool, disposeBag: DisposeBag){
        if(username == nil || password == nil){
            self.controller!.view.makeToast("用户名或密码不能为空",position: .center);
            self.controller!.setBtnLoginState("default");
            return;
        }
        if(username?.trimmingCharacters(in: CharacterSet.whitespaces) == "" || password?.trimmingCharacters(in: CharacterSet.whitespaces) == ""){
            self.controller!.view.makeToast("用户名或密码不能为空",position: .center);
            self.controller!.setBtnLoginState("default");
            return;
        }
        HttpService().login(username: username!,password: password!).subscribe(onNext: { (res) in
            if(res != nil && res.code == "200"){
                if(res.data != nil){
                    let userDefault = UserDefaults.standard;
                    if(userDefault.object(forKey: Constant.KEY_ACCESS_TOKEN) != nil){
                        userDefault.removeObject(forKey: Constant.KEY_ACCESS_TOKEN)
                        userDefault.removeObject(forKey: Constant.KEY_REFRESH_TOKEN)
                    }
                    userDefault.set(res.data?.accessToken, forKey: Constant.KEY_ACCESS_TOKEN);
                    userDefault.set(res.data?.refreshToken, forKey: Constant.KEY_REFRESH_TOKEN);

                    if(isRemember){
                        let str = "{\"userName\":\"\(username!)\",\"password\":\"\(password!)\"}"
                        let userData:UserModel = UserModel.init(JSONString: str)!
                        userDefault.set(userData.toJSONString(), forKey: Constant.KEY_USER_INFO)
                        userDefault.set(true, forKey: Constant.KEY_IS_REMEMBERME)
                    }else{
                        if(userDefault.object(forKey: Constant.KEY_USER_INFO) != nil){
                            userDefault.removeObject(forKey: Constant.KEY_USER_INFO)
                        }
                    }
                    userDefault.synchronize();
                    self.controller!.toHomePage();
                }
            }else{
                self.controller!.view.makeToast(res.message,position: .center);
            }
            self.controller!.setBtnLoginState("default");
        }).disposed(by: disposeBag);
    }
    
    func getLoginInfo()->UserModel?{
        let userDefault = UserDefaults.standard;
        var userInfo:UserModel? = nil;
        if(userDefault.object(forKey: Constant.KEY_USER_INFO) != nil){
            userInfo = UserModel(JSONString: userDefault.string(forKey: Constant.KEY_USER_INFO)!);
        }
        return userInfo;
    }
    func isRememberMe()->Bool{
        let userDefault = UserDefaults.standard;
        var isRememberMe:Bool = false;
        if(userDefault.object(forKey: Constant.KEY_IS_REMEMBERME) != nil){
            isRememberMe = userDefault.bool(forKey: Constant.KEY_IS_REMEMBERME);
        }
        return isRememberMe;
    }
}
