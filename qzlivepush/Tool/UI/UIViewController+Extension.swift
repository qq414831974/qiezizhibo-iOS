//
//  UIViewController+Extension.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/3.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit
import Alamofire

extension UIViewController{
    func openEventServiceWithBolck(action :@escaping ((Bool)->())) {
        let manager = NetworkReachabilityManager(host: "www.apple.com")
        manager?.listener = { status in
            if status == .reachable(.ethernetOrWiFi) { //WIFI
                action(true)
            } else if status == .reachable(.wwan) { // 蜂窝网络
                action(true)
            } else if status == .notReachable { // 无网络
                action(false)
            } else { // 其他
                action(false)
            }
        }
        manager?.startListening()//开始监听网络
    }
    
    func authorize(status:Bool){
        
        switch status {
        case true:
            return;
            
        case false:
            // 请求授权
            DispatchQueue.main.async(execute: { () -> Void in
                let alertController = UIAlertController(title: "网络权限访问受限",
                                                        message: "点击“设置”，允许访问您的网络",
                                                        preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler:nil)
                
                let settingsAction = UIAlertAction(title:"设置", style: .default, handler: {
                    (action) -> Void in
                    let url = URL(string: UIApplication.openSettingsURLString)
                    if let url = url, UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(url, options: [:],
                                                      completionHandler: {
                                                        (success) in
                            })
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                })
                
                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        }
        return;
    }
}
