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
    func getMatchList(pageNum:Int,pageSize:Int,leagueId:Int?,name:String?,round:[String?]?,status:String?,dateBegin:Date?,dateEnd:Date?,orderby:String?,isActivity:Bool?, disposeBag: DisposeBag) {
        HttpService().matches(pageNum: pageNum, pageSize: pageSize, leagueId: leagueId, name: name, round: round, status: status, dateBegin: dateBegin, dateEnd: dateEnd, orderby: orderby, isActivity: isActivity).subscribe(onNext:{(res) in
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
