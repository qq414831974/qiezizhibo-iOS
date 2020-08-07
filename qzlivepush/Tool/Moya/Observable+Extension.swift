//
//  Observable+Extension.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/5/23.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import Foundation
import RxSwift

extension Observable {
    func showAPIErrorToast() -> Observable<Element> {
        return self.do(onNext: { (event) in
        }, onError: { (error) in
            // TODO: 可以在此处做一些网络错误的时候的提示信息
            print("\(error.localizedDescription)")
        }, onCompleted: {
        }, onSubscribe: {
        }, onDispose: {
        })
    }
}
