//
//  TimeLineViewModel.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/15.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import RxSwift

class TimeLineViewModel {
    var controller: LiveController?;
    var currentEvent:TimeLineEvent?;
    var currentTeam:TeamModel?;
    var currentPlayer:PlayerModel?;
    typealias Callback<T> = (_ res : T) -> Void
    
    func initWith(_ controller:LiveController?) {
        self.controller = controller;
    }
    class var sharedInstance: TimeLineViewModel {
        struct Static {
            static let instance: TimeLineViewModel = TimeLineViewModel()
        }
        return Static.instance
    }
    
    func addTimeLine(matchId:Int,teamId:Int?,eventType:Int,againstIndex:Int?,section:Int?,remark:String?,callback:@escaping Callback<ResponseBoolModel>, disposeBag: DisposeBag){
        HttpService().addTimeLine(matchId: matchId, teamId: teamId, eventType: eventType, againstIndex: againstIndex, section: section, remark: remark).subscribe(onNext:{(res) in
            callback(res);
        }).disposed(by: disposeBag);
    }
    
    func showLoadingAnimation(){
        if(self.controller != nil){
            self.controller!.view.makeToastActivity(.center)
        }
    }
    func hideLoadingAnimation(){
        if(self.controller != nil){
            self.controller!.view.hideToastActivity();
        }
    }
}
