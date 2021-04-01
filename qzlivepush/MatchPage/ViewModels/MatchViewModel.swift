//
//  MatchViewModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/11.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import RxSwift

class MatchViewModel {
    typealias Callback<T> = (_ res : T) -> Void

    var controller: MatchViewController?;
    
    init(_ controller:MatchViewController?) {
        self.controller = controller;
    }
    func getMatchList(pageNum:Int,pageSize:Int,sortOrder:String,sortField:String,leagueId:Int?,round:String?, disposeBag: DisposeBag) {
        HttpService().matches(pageNum: pageNum, pageSize: pageSize,sortOrder: sortOrder, sortField: sortField, leagueId: leagueId, round: round).subscribe(onNext:{(res) in
            self.controller!.matchPage = self.controller!.matchPage! + res.records!;
            self.controller!.pageInfo = res;
            self.controller!.reloadData();
        }).disposed(by: disposeBag);
    }
    func getLeagueMatch(id:Int,callback:@escaping Callback<LeagueModel>, disposeBag: DisposeBag){
        HttpService().league(id: id).subscribe(onNext:{(res) in
            callback(res);
        }).disposed(by: disposeBag);
    }
}
