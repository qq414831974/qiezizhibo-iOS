//
//  UIAlertController+Extension.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/7/1.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit
import Toast_Swift

extension UIAlertController {
    func show(){
        let win = UIWindow(frame:UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        win.rootViewController = vc
        win.windowLevel = UIWindow.Level.alert + 1
        win.makeKeyAndVisible()
        vc.present(self,animated:true,completion:nil)
    }
}
