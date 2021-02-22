//
//  ChooseStatusController.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/25.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit
import SwiftEntryKit
import RxSwift

class ChooseStatusController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate{
    var viewModel:TimeLineViewModel?;
    var statusRemarkVc:StatusRemarkController!;
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pickerView:UIPickerView!;
    var datePicker:UIDatePicker!;
    var currentRow:Int = 0;
    
    var currentEvent:TimeLineEvent!;
    let disposeBag = DisposeBag();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        viewModel = TimeLineViewModel.sharedInstance;
        statusRemarkVc = storyboard?.instantiateViewController(withIdentifier: "statusRemarkVc") as? StatusRemarkController;
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 120;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row);
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentRow = row;
        self.statusRemarkVc.tf_Remark.text = String(row);
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:StatusCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "statusCollectionCell",for: indexPath) as! StatusCollectionCell;
        cell.backgroundColor = .clear;
        let index:Int = indexPath.row;
        
        let event:TimeLineEvent = Constant.EVENT_TYPE[Constant.STATUS_SHOW[index]!]!;
        cell.iv_EventImg.image = UIImage.svg(named: event.icon,size: CGSize.init(width: 60, height: 60));
        cell.lb_EventName.text = event.text;
        if(index == 13){
            cell.lb_EventName.font = UIFont.systemFont(ofSize: 10);
        }else{
            cell.lb_EventName.font = UIFont.systemFont(ofSize: 13);
        }
        cell.tag = event.eventType;
        
        let tap = UITapGestureRecognizer(target:self, action:#selector(showDialog));
        cell.isUserInteractionEnabled = true;
        cell.addGestureRecognizer(tap);
        
        return cell;
    }
    func initRemarkView(){
        let event = currentEvent!;
        let eventtype = event.eventType;
        self.statusRemarkVc.tf_Remark.text = nil;
        self.statusRemarkVc.iv_EventImg.image = UIImage.svg(named: event.icon,size: CGSize.init(width: 60, height: 60));
        self.statusRemarkVc.lb_EventName.text = event.text;
        if(eventtype==0||eventtype==14||eventtype==15||eventtype==11||eventtype==12){
            self.statusRemarkVc.lb_RemarkName.text = "开始于";
        }else{
            self.statusRemarkVc.lb_RemarkName.text = "分钟数";
        }
        if(eventtype==21){
            self.statusRemarkVc.lb_RemarkName.isHidden = true;
            self.statusRemarkVc.v_Remark.isHidden = true;
            self.statusRemarkVc.tf_Remark.isHidden = true;
        }else{
            self.statusRemarkVc.lb_RemarkName.isHidden = false;
            self.statusRemarkVc.v_Remark.isHidden = false;
            self.statusRemarkVc.tf_Remark.isHidden = false;
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let nowDateString = formatter.string(from: Date());
            self.statusRemarkVc.tf_Remark.text = nowDateString;
        }
        if(eventtype == 16){
            let currentMinute = (viewModel!.controller!.matchStatus == nil || viewModel!.controller!.matchStatus!.minute == nil) ? 0 : viewModel!.controller!.matchStatus!.minute;
            self.statusRemarkVc.v_minute.isHidden = false;
            self.statusRemarkVc.tf_minute.text = String(currentMinute!);
        }else{
            self.statusRemarkVc.v_minute.isHidden = true;
            self.statusRemarkVc.tf_minute.text = "0";
        }
        let tap = UITapGestureRecognizer(target:self.statusRemarkVc, action:#selector(self.statusRemarkVc.showPicker));
        self.statusRemarkVc.v_Remark.isUserInteractionEnabled = true;
        self.statusRemarkVc.v_Remark.addGestureRecognizer(tap);
        self.statusRemarkVc.v_Remark.tag = eventtype;
        
        self.statusRemarkVc.btn_confirm.addTarget(self, action: #selector(self.onConfirmClick), for: UIControl.Event.touchUpInside);
    }
    @objc func showDialog(sender: UITapGestureRecognizer){
        let eventtype = sender.view!.tag;
        currentEvent = Constant.EVENT_TYPE[eventtype]!;
        SwiftEntryKit.dismiss(SwiftEntryKit.EntryDismissalDescriptor.specific(entryName: "statusVc")) {
            var attributes = EKAttributes.centerFloat;
            let widthConstraint = EKAttributes.PositionConstraints.Edge.fill;
            let heightConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 240);
            attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint);
            attributes.entryBackground = .color(color: .groupTableViewBackground);
            attributes.screenBackground = .color(color: UIColor(white: 50.0/255.0, alpha: 0.3));
            attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero));
            attributes.entranceAnimation = .translation;
            attributes.exitAnimation = .translation;
            attributes.displayDuration = .infinity;
            attributes.entryInteraction = .absorbTouches;
            attributes.screenInteraction = .dismiss;
            attributes.name = "statusRemarkVc";
            self.statusRemarkVc.chooseStatus = self;
            SwiftEntryKit.display(entry: self.statusRemarkVc, using: attributes);
        }
    }
    @objc func showPicker(sender:UITapGestureRecognizer){
        let eventtype = sender.view!.tag;
        if(eventtype==0||eventtype==14||eventtype==15||eventtype==11||eventtype==12){
            datePicker = UIDatePicker();
            datePicker.locale = Locale(identifier: "zh_CN");
            datePicker.addTarget(self, action: #selector(dateChanged),
                                 for: .valueChanged);
            let alertController:UIAlertController=UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.actionSheet);
            alertController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default){
                (alertAction)->Void in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
                if(self.datePicker.date.compare(Date()) == .orderedDescending){
                    self.viewModel!.controller!.view.makeToast("时间选择时间不能超过当前时间，请重新选择",position: .center);
                }else{
                    self.statusRemarkVc.tf_Remark.text = formatter.string(from: self.datePicker.date);
                }
            });
            alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel,handler:nil));
            let width = UIScreen.main.bounds.width;
            let height = UIScreen.main.bounds.height;
            datePicker!.frame = CGRect(x: 0, y: 0, width: width > height ? height : width, height: 150);
            alertController.view.addSubview(datePicker);
            self.statusRemarkVc.present(alertController, animated: false, completion: nil);
        }else{
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
                self.statusRemarkVc.tf_Remark.text = String(self.currentRow);
            });
            alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel,handler:nil));
            let width = UIScreen.main.bounds.width;
            let height = UIScreen.main.bounds.height;
            pickerView!.frame = CGRect(x: 0, y: 0, width: width > height ? height : width, height: 150);
            alertController.view.addSubview(pickerView!);
            self.statusRemarkVc.present(alertController, animated: false, completion: nil);
        }
    }
    @objc func dateChanged(datePicker : UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        if(datePicker.date.compare(Date()) == .orderedDescending){
            self.viewModel!.controller!.view.makeToast("时间选择时间不能超过当前时间，请重新选择",position: .center);
        }else{
            self.statusRemarkVc.tf_Remark.text = formatter.string(from: datePicker.date);
        }
    }
    @objc func onConfirmClick(){
        let matchId = viewModel!.controller!.currentMatch!.id;
        let eventtype = self.currentEvent.eventType;
        let remark = self.statusRemarkVc.tf_Remark.text;
        let halfMinute = viewModel!.controller!.currentMatch!.duration! / 2;
        let currentMinute = (viewModel!.controller!.matchStatus == nil || viewModel!.controller!.matchStatus!.minute == nil) ? 0 : viewModel!.controller!.matchStatus!.minute;
        let minuteData:[Int:Int] = [0:0,14:halfMinute,15:halfMinute,13:currentMinute!,11:currentMinute!,12:120,21:150,16: Int(self.statusRemarkVc.tf_minute.text!)!];
        let minute = minuteData[eventtype]!;
        self.statusRemarkVc.btn_confirm.isUserInteractionEnabled = false;
        SwiftEntryKit.dismiss();
        viewModel!.showLoadingAnimation()
        viewModel!.addTimeLine(matchId: matchId!, teamId: nil, playerId: nil, eventtype: eventtype, minute: minute, remark: remark, text: nil, callback: { (response) in
            self.viewModel!.hideLoadingAnimation()
            if(response.data != nil && response.data!){
                if(self.viewModel!.controller != nil){
                    self.viewModel!.controller!.view.makeToast("添加成功",position: .center);
                }
                if(self.viewModel!.liveController != nil){
                    self.viewModel!.liveController!.view.makeToast("添加成功",position: .center);
                }
                if(self.viewModel!.liveController != nil){
                    //比赛开始
                    if(eventtype == 0){
                        self.viewModel!.liveController!.startTimer_time();
                        //中场
                    }else if(eventtype == 14){
                        self.viewModel!.liveController!.stopTimer_time();
                        self.viewModel!.liveController!.stopTimeToHalf();
                    }else if(eventtype == 15){
                        self.viewModel!.liveController!.startTimer_time();
                    }else if(eventtype == 21){
                        self.viewModel!.liveController!.stopTimer_time();
                    }
                }
//                SwiftEntryKit.dismiss();
            }else{
                if(self.viewModel!.controller != nil){
                    self.viewModel!.controller!.view.makeToast(response.message,position: .center);
                }
                if(self.viewModel!.liveController != nil){
                    self.viewModel!.liveController!.view.makeToast(response.message,position: .center);
                }
            }
            self.statusRemarkVc.btn_confirm.isUserInteractionEnabled = true;
            self.viewModel!.controller!.refreshData();
        }, disposeBag: disposeBag)
    }
}

class StatusCollectionCell: UICollectionViewCell{
    @IBOutlet weak var iv_EventImg: UIImageView!
    @IBOutlet weak var lb_EventName: UILabel!
}
