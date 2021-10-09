//
//  OneyuanTimelineController.swift
//  qzlivepush
//
//  Created by 吴帆 on 2020/12/10.
//  Copyright © 2020 qiezizhibo. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper

class OneyuanTimelineController: UIViewController{
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
    var viewModel:TimeLineViewModel?;

    let disposeBag = DisposeBag();
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
    func setUp(){
        viewModel = TimeLineViewModel.sharedInstance;
    }
    @objc func onBtnScoreClick(btn: UIButton){
        if(viewModel!.controller!.matchStatusModel == nil){
            self.view.makeToast("正在操作中...",position: .center);
            return;
        }
        switch btn {
        case btn_host_reduce1:
            updateMatchSocre(matchId: viewModel!.controller!.currentMatch!.id!,teamId: viewModel!.controller!.hostTeamId!,eventType: 11)
            break;
        case btn_host_reduce2:
            updateMatchSocre(matchId: viewModel!.controller!.currentMatch!.id!,teamId: viewModel!.controller!.hostTeamId!,eventType: 12)
            break;
        case btn_host_reduce3:
            updateMatchSocre(matchId: viewModel!.controller!.currentMatch!.id!,teamId: viewModel!.controller!.hostTeamId!,eventType: 13)
            break;
        case btn_host_plus1:
            updateMatchSocre(matchId: viewModel!.controller!.currentMatch!.id!,teamId: viewModel!.controller!.hostTeamId!,eventType: 1)
            break;
        case btn_host_plus2:
            updateMatchSocre(matchId: viewModel!.controller!.currentMatch!.id!,teamId: viewModel!.controller!.hostTeamId!,eventType: 2)
            break;
        case btn_host_plus3:
            updateMatchSocre(matchId: viewModel!.controller!.currentMatch!.id!,teamId: viewModel!.controller!.hostTeamId!,eventType: 3)
            break;
        case btn_guest_reduce1:
            updateMatchSocre(matchId: viewModel!.controller!.currentMatch!.id!,teamId: viewModel!.controller!.guestTeamId!,eventType: 11)
            break;
        case btn_guest_reduce2:
            updateMatchSocre(matchId: viewModel!.controller!.currentMatch!.id!,teamId: viewModel!.controller!.guestTeamId!,eventType: 12)
            break;
        case btn_guest_reduce3:
            updateMatchSocre(matchId: viewModel!.controller!.currentMatch!.id!,teamId: viewModel!.controller!.guestTeamId!,eventType: 13)
            break;
        case btn_guest_plus1:
            updateMatchSocre(matchId: viewModel!.controller!.currentMatch!.id!,teamId: viewModel!.controller!.guestTeamId!,eventType: 1)
            break;
        case btn_guest_plus2:
            updateMatchSocre(matchId: viewModel!.controller!.currentMatch!.id!,teamId: viewModel!.controller!.guestTeamId!,eventType: 2)
            break;
        case btn_guest_plus3:
            updateMatchSocre(matchId: viewModel!.controller!.currentMatch!.id!,teamId: viewModel!.controller!.guestTeamId!,eventType: 3)
            break;
        default:
            break;
        }
    }
    @objc func onBtnPreSectionClick(btn: UIButton){
        updateMatchSection(matchId: viewModel!.controller!.currentMatch!.id!,eventType: 14);
    }
    @objc func onBtnNextSectionClick(btn: UIButton){
        updateMatchSection(matchId: viewModel!.controller!.currentMatch!.id!,eventType: 4);
    }
    func updateMatchSection(matchId: Int,eventType: Int){
        if(isUpdating){
            self.view.makeToast("正在操作中...",position: .center);
            return
        }
        isUpdating = true;
        var againstIndex = 1;
        if(viewModel!.controller!.matchStatusModel != nil && viewModel!.controller!.matchStatusModel!.againstIndex != nil){
            againstIndex = viewModel!.controller!.matchStatusModel!.againstIndex!;
        }
        do {
        try HttpService().addTimeLine(matchId: matchId, teamId: nil, eventType: eventType, againstIndex: againstIndex, section: nil, remark: nil).subscribe(onNext:{(res) in
            if(res.data != nil && res.data!){
                self.isUpdating = false;
                self.view.makeToast("添加成功",position: .center);
                self.viewModel!.controller!.refreshData();
            }else{
                self.isUpdating = false;
                self.view.makeToast("添加失败:" + res.message,position: .center);
            }
        },onError: { (error) in
            self.isUpdating = false;
            self.view.makeToast("添加失败",position: .center);
        }).disposed(by: disposeBag);
        }catch{
            self.isUpdating = false;
            self.view.makeToast("添加失败",position: .center);
        }
    }
    func updateMatchSocre(matchId: Int,teamId: Int,eventType: Int){
        if(isUpdating){
            self.view.makeToast("正在操作中...",position: .center);
            return
        }
        isUpdating = true;
        var againstIndex = 1;
        var section = 1;
        if(viewModel!.controller!.matchStatusModel != nil && viewModel!.controller!.matchStatusModel!.againstIndex != nil){
            againstIndex = viewModel!.controller!.matchStatusModel!.againstIndex!;
        }
        if(viewModel!.controller!.matchStatusModel != nil && viewModel!.controller!.matchStatusModel!.section != nil){
            section = viewModel!.controller!.matchStatusModel!.section!;
        }
        do {
        try HttpService().addTimeLine(matchId: matchId, teamId: teamId, eventType: eventType, againstIndex: againstIndex, section: section, remark: "1").subscribe(onNext:{(res) in
            if(res.data != nil && res.data!){
                self.isUpdating = false;
                self.view.makeToast("添加成功",position: .center);
                self.viewModel!.controller!.refreshData();
            }else{
                self.isUpdating = false;
                self.view.makeToast("添加失败:" + res.message,position: .center);
            }
        },onError: { (error) in
            self.isUpdating = false;
            self.view.makeToast("添加失败",position: .center);
        }).disposed(by: disposeBag);
        }catch{
            self.isUpdating = false;
            self.view.makeToast("添加失败",position: .center);
        }
    }
}
