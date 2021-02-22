//
//  BasketballTimelineController.swift
//  qzlivepush
//
//  Created by 吴帆 on 2020/12/10.
//  Copyright © 2020 qiezizhibo. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper

class BasketballTimelineController: UIViewController{
    @IBOutlet weak var btn_host_reduce1: UIButton!
    @IBOutlet weak var btn_host_reduce2: UIButton!
    @IBOutlet weak var btn_host_reduce3: UIButton!
    @IBOutlet weak var btn_host_plus1: UIButton!
    @IBOutlet weak var btn_host_plus2: UIButton!
    @IBOutlet weak var btn_host_plus3: UIButton!
    
    @IBOutlet weak var btn_guest_reduce1: UIButton!
    @IBOutlet weak var btn_guest_reduce2: UIButton!
    @IBOutlet weak var btn_guest_reduce3: UIButton!
    @IBOutlet weak var btn_guest_plus1: UIButton!
    @IBOutlet weak var btn_guest_plus2: UIButton!
    @IBOutlet weak var btn_guest_plus3: UIButton!
    
    @IBOutlet weak var btn_next_section: UIButton!
    @IBOutlet weak var btn_pre_section: UIButton!
    
    typealias Callback<T> = (_ res : T) -> Void

    let disposeBag = DisposeBag();
    var match:MatchModel?;
    var isUpdating: Bool = false;
    var onSectionChangeClick:(Callback<Int>)? = nil;

    override func viewDidLoad() {
        super.viewDidLoad();
        btn_host_reduce1.addTarget(self, action: #selector(onBtnScoreClick), for: UIControl.Event.touchUpInside);
        btn_host_reduce2.addTarget(self, action: #selector(onBtnScoreClick), for: UIControl.Event.touchUpInside);
        btn_host_reduce3.addTarget(self, action: #selector(onBtnScoreClick), for: UIControl.Event.touchUpInside);
        
        btn_host_plus1.addTarget(self, action: #selector(onBtnScoreClick), for: UIControl.Event.touchUpInside);
        btn_host_plus2.addTarget(self, action: #selector(onBtnScoreClick), for: UIControl.Event.touchUpInside);
        btn_host_plus3.addTarget(self, action: #selector(onBtnScoreClick), for: UIControl.Event.touchUpInside);
        
        btn_guest_reduce1.addTarget(self, action: #selector(onBtnScoreClick), for: UIControl.Event.touchUpInside);
        btn_guest_reduce2.addTarget(self, action: #selector(onBtnScoreClick), for: UIControl.Event.touchUpInside);
        btn_guest_reduce3.addTarget(self, action: #selector(onBtnScoreClick), for: UIControl.Event.touchUpInside);
        
        btn_guest_plus1.addTarget(self, action: #selector(onBtnScoreClick), for: UIControl.Event.touchUpInside);
        btn_guest_plus2.addTarget(self, action: #selector(onBtnScoreClick), for: UIControl.Event.touchUpInside);
        btn_guest_plus3.addTarget(self, action: #selector(onBtnScoreClick), for: UIControl.Event.touchUpInside);
        
        btn_pre_section.addTarget(self, action: #selector(onBtnPreSectionClick), for: UIControl.Event.touchUpInside);
        btn_next_section.addTarget(self, action: #selector(onBtnNextSectionClick), for: UIControl.Event.touchUpInside);
    }
    
    @objc func onBtnScoreClick(btn: UIButton){
        if(match == nil){
            return;
        }
        switch btn {
        case btn_host_reduce1:
            updateMatchSocre(matchId: match!.id!,teamId: match!.hostTeamId!,scoreChange: -1)
            break;
        case btn_host_reduce2:
            updateMatchSocre(matchId: match!.id!,teamId: match!.hostTeamId!,scoreChange: -2)
            break;
        case btn_host_reduce3:
            updateMatchSocre(matchId: match!.id!,teamId: match!.hostTeamId!,scoreChange: -3)
            break;
        case btn_host_plus1:
            updateMatchSocre(matchId: match!.id!,teamId: match!.hostTeamId!,scoreChange: 1)
            break;
        case btn_host_plus2:
            updateMatchSocre(matchId: match!.id!,teamId: match!.hostTeamId!,scoreChange: 2)
            break;
        case btn_host_plus3:
            updateMatchSocre(matchId: match!.id!,teamId: match!.hostTeamId!,scoreChange: 3)
            break;
        case btn_guest_reduce1:
            updateMatchSocre(matchId: match!.id!,teamId: match!.guestTeamId!,scoreChange: -1)
            break;
        case btn_guest_reduce2:
            updateMatchSocre(matchId: match!.id!,teamId: match!.guestTeamId!,scoreChange: -2)
            break;
        case btn_guest_reduce3:
            updateMatchSocre(matchId: match!.id!,teamId: match!.guestTeamId!,scoreChange: -3)
            break;
        case btn_guest_plus1:
            updateMatchSocre(matchId: match!.id!,teamId: match!.guestTeamId!,scoreChange: 1)
            break;
        case btn_guest_plus2:
            updateMatchSocre(matchId: match!.id!,teamId: match!.guestTeamId!,scoreChange: 2)
            break;
        case btn_guest_plus3:
            updateMatchSocre(matchId: match!.id!,teamId: match!.guestTeamId!,scoreChange: 3)
            break;
        default:
            break;
        }
    }
    @objc func onBtnPreSectionClick(btn: UIButton){
        if(onSectionChangeClick != nil){
            onSectionChangeClick!(-1);
        }
    }
    @objc func onBtnNextSectionClick(btn: UIButton){
        if(onSectionChangeClick != nil){
            onSectionChangeClick!(1);
        }
    }
    func updateMatchSocre(matchId: Int,teamId: Int,scoreChange: Int){
        if(isUpdating){
            self.view.makeToast("正在操作中...",position: .center);
            return
        }
        isUpdating = true;
        do {
        try HttpService().matchStatus(matchId: matchId,type: ["score"]).subscribe(onNext:{(res) in
            if(res != nil && res.score != nil){
                let scoreString = res.score!
                let scores = scoreString.split(separator: "-");
                var hostScore = Int(scores[0]);
                var guestScore = Int(scores[1]);
                var score = scoreString;
                if(teamId == self.match!.hostTeamId && (hostScore! + scoreChange > 0)){
                    hostScore = hostScore! + scoreChange;
                }else if(teamId == self.match!.guestTeamId && (guestScore! + scoreChange > 0)){
                    guestScore = guestScore! + scoreChange;
                }else{
                    self.view.makeToast("请选择正确的比分",position: .center);
                    self.isUpdating = false;
                    return;
                }
                score = "\(hostScore!)-\(guestScore!)"
                HttpService().updateScoreAndStatus(matchId: matchId, hostteamId: self.match!.hostTeamId, guestteamId: self.match!.guestTeamId,  score: score, status: 0).subscribe(onNext:{(response) in
                    self.isUpdating = false;
                    if(response.data != nil && response.data!){
                        self.view.makeToast("修改成功",position: .center);
                    }
                }).disposed(by: self.disposeBag);
            }
        }).disposed(by: disposeBag);
        }catch{
            self.isUpdating = false;
            self.view.makeToast("修改失败",position: .center);
        }
    }
}
