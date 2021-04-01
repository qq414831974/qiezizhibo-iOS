//
//  StatusRemarkController.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/25.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit
import SwiftEntryKit
import RxSwift

class StatusRemarkController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    @IBOutlet weak var iv_EventImg: UIImageView!
    
    @IBOutlet weak var lb_EventName: UILabel!
    
    @IBOutlet weak var lb_RemarkName: UILabel!
            
    @IBOutlet weak var btn_confirm: UIButton!
    
    @IBOutlet weak var v_against: UIView!
        
    @IBOutlet weak var lb_hostName: UILabel!
    
    @IBOutlet weak var lb_guestName: UILabel!
    
    @IBOutlet weak var lb_score: UILabel!
    
    @IBOutlet weak var iv_hostHeadImg: UIImageView!
    
    @IBOutlet weak var iv_guestHeadImg: UIImageView!
    
    var viewModel:TimeLineViewModel?;
    
    var pickerView:UIPickerView!;
    
    var currentRow:Int = 0;

    var eventType:Int!;
    
    var currentSwitchAgainst:Int = -1;
    
    let disposeBag = DisposeBag();

    override func viewDidLoad() {
        super.viewDidLoad();
        let tap = UITapGestureRecognizer(target:self, action:#selector(self.showPicker));
        self.v_against.isUserInteractionEnabled = true;
        self.v_against.addGestureRecognizer(tap);
        self.btn_confirm.addTarget(self, action: #selector(self.onConfirmClick), for: UIControl.Event.touchUpInside);
    }
    func setUp(){
        viewModel = TimeLineViewModel.sharedInstance;
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count: Int = 1;
        if(viewModel!.controller!.currentMatch != nil && viewModel!.controller!.currentMatch!.againstTeams != nil){
        let againstTeams = viewModel!.controller!.currentMatch!.againstTeams;
            count = againstTeams!.keys.count;
        }
        return count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return getAgainstTeamString(againstIndex: row + 1);
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentRow = row;
    }
    
    @objc func showPicker(sender:UITapGestureRecognizer){
        currentSwitchAgainst = -1;
        if(eventType == 5){
            pickerView = UIPickerView.init();
            pickerView!.dataSource = self;
            pickerView!.delegate = self;
            if(currentRow != nil){
                pickerView!.selectRow(currentRow,inComponent:0,animated:false);
            }else{
                pickerView!.selectRow(0,inComponent:0,animated:false);
            }
            let alertController:UIAlertController=UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.actionSheet);
            alertController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default){
                (alertAction)->Void in
                let currentAgainst: MatchAgainstVOModel? = self.getAgainstTeam(againstIndex: self.currentRow + 1);
                self.currentSwitchAgainst = self.currentRow + 1;
                if(currentAgainst != nil){
                    var hostTeamName = "";
                    var hostHeadImg: String? = nil;
                    if(currentAgainst!.hostTeam != nil ){
                        if(currentAgainst!.hostTeam!.shortName != nil){
                            hostTeamName = currentAgainst!.hostTeam!.shortName!;
                        }else{
                            hostTeamName = currentAgainst!.hostTeam!.name!;
                        }
                        hostHeadImg = currentAgainst!.hostTeam!.headImg;
                    }
                    var guestTeamName = "";
                    var guestHeadImg: String? = nil;
                    if(currentAgainst!.guestTeam != nil){
                        if(currentAgainst!.guestTeam!.shortName != nil){
                            guestTeamName = currentAgainst!.guestTeam!.shortName!;
                        }else{
                            guestTeamName = currentAgainst!.guestTeam!.name!;
                        }
                        guestHeadImg = currentAgainst!.guestTeam!.headImg;
                    }
                    self.lb_hostName.text = hostTeamName;
                    self.lb_guestName.text = guestTeamName;
                    self.setImg(iv: self.iv_hostHeadImg,url: hostHeadImg)
                    self.setImg(iv: self.iv_guestHeadImg,url: guestHeadImg)
                }
            });
            alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel,handler:nil));
            let width = UIScreen.main.bounds.width;
            let height = UIScreen.main.bounds.height;
            pickerView!.frame = CGRect(x: 0, y: 0, width: width > height ? height : width, height: 150);
            alertController.view.addSubview(pickerView!);
            self.present(alertController, animated: false, completion: nil);
        }
    }
    
    func getAgainstTeam(againstIndex: Int) -> MatchAgainstVOModel?{
        var currentAgainst: MatchAgainstVOModel? = nil;
        if(viewModel!.controller!.currentMatch != nil && viewModel!.controller!.currentMatch!.againstTeams != nil){
        let againstTeams = viewModel!.controller!.currentMatch!.againstTeams;
            for key in againstTeams!.keys{
                if(Int(againstIndex) == Int(key)){
                    currentAgainst = againstTeams![key];
                }
            }
        }
        return currentAgainst;
    }
    func getAgainstTeamString(againstIndex:Int) -> String{
        let currentAgainst: MatchAgainstVOModel? = getAgainstTeam(againstIndex: againstIndex);
        if(currentAgainst != nil){
            var againstTeamString = "";
            if(currentAgainst!.hostTeam != nil ){
                if(currentAgainst!.hostTeam!.shortName != nil){
                    againstTeamString = againstTeamString + currentAgainst!.hostTeam!.shortName!;
                }else{
                    againstTeamString = againstTeamString + currentAgainst!.hostTeam!.name!;
                }
            }
            againstTeamString = againstTeamString + "VS";
            if(currentAgainst!.guestTeam != nil){
                if(currentAgainst!.guestTeam!.shortName != nil){
                    againstTeamString = againstTeamString + currentAgainst!.guestTeam!.shortName!;
                }else{
                    againstTeamString = againstTeamString + currentAgainst!.guestTeam!.name!;
                }
            }
            return againstTeamString;
        }
        return "对阵" + String(againstIndex);
    }
    func showMatchAgainstSelector(hostTeamName:String,guestTeamName:String,hostTeamHeadImg:String?,guestTeamHeadImg:String?,score:String){
        v_against.isHidden = false;
        lb_RemarkName.isHidden = false;
        lb_hostName.text = hostTeamName;
        lb_guestName.text = guestTeamName;
        lb_score.text = score;
        setImg(iv: iv_hostHeadImg,url: hostTeamHeadImg);
        setImg(iv: iv_guestHeadImg,url: guestTeamHeadImg);
    }
    
    func hideMatchAgainstSelector(){
        v_against.isHidden = true;
        lb_RemarkName.isHidden = true;
    }
    
    func setImg(iv:UIImageView,url: String?) {
        if(url == nil){
            iv.image = UIImage.init(named: "logo.png")
        }else{
            iv.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "logo.png"));
        }
    }
    @objc func onConfirmClick(){
        let matchId = viewModel!.controller!.currentMatch!.id;
        var againstIndex = (viewModel!.controller!.matchStatusModel == nil || viewModel!.controller!.matchStatusModel!.againstIndex == nil) ? 1 : viewModel!.controller!.matchStatusModel!.againstIndex;
        if(eventType == 5 && self.currentSwitchAgainst != -1){
            againstIndex = self.currentSwitchAgainst;
        }
        
        self.btn_confirm.isUserInteractionEnabled = false;
        SwiftEntryKit.dismiss();
        viewModel!.showLoadingAnimation();
        viewModel!.addTimeLine(matchId: matchId!, teamId: nil, eventType: eventType, againstIndex: againstIndex, section: nil, remark: nil, callback: { (response) in
            self.viewModel!.hideLoadingAnimation()
            if(response.data != nil && response.data!){
                if(self.viewModel!.controller != nil){
                    self.viewModel!.controller!.refreshData();
                    self.viewModel!.controller!.view.makeToast("添加成功",position: .center);
                }
//                SwiftEntryKit.dismiss();
            }else{
                if(self.viewModel!.controller != nil){
                    self.viewModel!.controller!.view.makeToast(response.message,position: .center);
                }
            }
            self.btn_confirm.isUserInteractionEnabled = true;
            self.viewModel!.controller!.refreshData();
        }, disposeBag: disposeBag)
    }
}
