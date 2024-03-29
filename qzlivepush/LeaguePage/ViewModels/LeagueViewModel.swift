//
//  LeagueViewModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/5/30.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import Toast_Swift
import RxSwift
import Moya

class LeagueViewModel {
    var controller: LeagueViewController?;
    
    init(_ controller:LeagueViewController?) {
        self.controller = controller;
    }
    func getLeagueList(pageNum:Int, pageSize:Int, city:String?, country:String?, name:String?, state:String? = "live", disposeBag: DisposeBag) {
        HttpService().leagues(pageNum: pageNum, pageSize: pageSize, city: city, country: country,name: name, status: state).subscribe(onNext:{(res) in
            self.controller!.leaguePage = self.controller!.leaguePage! + res.records!;
            self.controller!.pageInfo = res;
            self.controller!.reloadData();
        }).disposed(by: disposeBag);
    }
}
