//
//  ScoreAndStatusController.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/25.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit
import SwiftEntryKit
import RxSwift

class ScoreAndStatusController:UIViewController{
    @IBOutlet weak var tf_score: UITextField!
    
    @IBOutlet weak var v_unopen: UIView!
    
    @IBOutlet weak var v_start: UIView!
    
    @IBOutlet weak var v_half: UIView!
    
    @IBOutlet weak var v_secondHalf: UIView!
    
    @IBOutlet weak var v_finish: UIView!
    
    @IBOutlet weak var btn_confirm: UIButton!
    
    var viewModel:TimeLineViewModel?;
    
    var checkBoxList:[UICheckBox] = [UICheckBox]();
    var checkBoxVList:[UIView] = [UIView]();
    
    var currentStatus:Int?;
    
    let disposeBag = DisposeBag();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        viewModel = TimeLineViewModel.sharedInstance;
        
        if(viewModel!.controller!.matchStatus != nil){
            currentStatus = viewModel!.controller!.matchStatus!.status!;
            tf_score.text = viewModel!.controller!.matchStatus!.score!;
        }else {
            currentStatus = -1;
            tf_score.text = "0-0";
        }
        
        
        var index:Int = 0;
        
        switch currentStatus {
        case -1:
            index = 0;
            break;
        case 0:
            index = 1;
            break;
        case 14:
            index = 2;
            break;
        case 15:
            index = 3;
            break;
        case 21:
            index = 4;
            break;
        default:
            index = 0;
        }
        
        checkBoxList.append(v_unopen.viewWithTag(101) as! UICheckBox);
        checkBoxList.append(v_start.viewWithTag(101) as! UICheckBox);
        checkBoxList.append(v_half.viewWithTag(101) as! UICheckBox);
        checkBoxList.append(v_secondHalf.viewWithTag(101) as! UICheckBox);
        checkBoxList.append(v_finish.viewWithTag(101) as! UICheckBox);
        
        checkBoxVList.append(v_unopen);
        checkBoxVList.append(v_start);
        checkBoxVList.append(v_half);
        checkBoxVList.append(v_secondHalf);
        checkBoxVList.append(v_finish);
        
        var i = 0;
        for v in checkBoxVList {
            v.tag = i;
            let tap = UITapGestureRecognizer(target:self, action:#selector(unselectOther));
            v.isUserInteractionEnabled = true;
            v.addGestureRecognizer(tap);
            i = i + 1;
        }
        
        i = 0;
        for v in checkBoxList{
            if(index == i){
                v.isSelected = true;
            }
            v.tag = i;
            v.addTarget(self, action: #selector(unselectOther), for: UIControl.Event.touchUpInside);
            i = i + 1;
        }
        btn_confirm.addTarget(self, action: #selector(onConfirmClick), for: UIControl.Event.touchUpInside);
    }
    func refreshData(){
        if(viewModel!.controller!.matchStatus != nil){
            tf_score.text = viewModel!.controller!.matchStatus!.score!;
        }else{
            tf_score.text = "0-0"
        }
    }
    @objc func unselectOther(sender: Any){
        var index:Int?;
        if(sender is UIGestureRecognizer){
            index = (sender as! UIGestureRecognizer).view!.tag;
        }else{
            index = (sender as! UIView).tag;
        }
        var i = 0;
        for v in checkBoxList {
            if(i == index){
                v.isSelected = true;
            }else{
                v.isSelected = false;
            }
            i = i + 1;
        }
    }
    @objc func onConfirmClick(){
        let match = viewModel!.controller!.currentMatch!;
        var status = -1;
        var i = 0;
        var index = 0;
        for v in checkBoxList{
            if(v.isSelected){
                index = i;
            }
            i = i + 1;
        }
        switch index {
        case 0:
            status = -1;
            break;
        case 1:
            status = 0;
            break;
        case 2:
            status = 14;
            break;
        case 3:
            status = 15;
            break;
        case 4:
            status = 21;
            break;
        default:
            status = -1;
        }
        viewModel!.updateScoreAndStatus(matchId: match.id!, hostteamId: match.hostTeamId, guestteamId: match.guestTeamId, score: tf_score.text ?? "0-0", status: status, callback: { (response) in
            if(response.data != nil && response.data!){
                self.viewModel!.controller!.view.makeToast("修改成功");
                SwiftEntryKit.dismiss();
            }else{
                self.viewModel!.controller!.view.makeToast(response.message);
            }
            self.viewModel!.controller!.refreshData();
        }, disposeBag: disposeBag)
    }
}
