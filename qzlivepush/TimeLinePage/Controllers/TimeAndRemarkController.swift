//
//  TimeAndRemarkController.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/18.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit
import FloatingPanel
import DropDown
import RxSwift
import Toast_Swift

class TimeAndRemarkController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, FloatingPanelControllerDelegate{
    @IBOutlet weak var btn_close: UIButton!
    @IBOutlet weak var iv_teamImg: UIImageView!
    @IBOutlet weak var lb_teamName: UILabel!
    @IBOutlet weak var iv_playerImg: UIImageView!
    @IBOutlet weak var lb_playerName: UILabel!
    @IBOutlet weak var iv_eventImg: UIImageView!
    @IBOutlet weak var lb_eventName: UILabel!
    @IBOutlet weak var tf_time: TextFieldWithLeftView!
    @IBOutlet weak var lb_remark: UILabel!
    @IBOutlet weak var btn_remarkDetail: UIButton!
    @IBOutlet weak var tv_description: UITextView!
    @IBOutlet weak var btn_confirm: UIButton!
    @IBOutlet weak var v_time: UIView!
    
    var viewModel:TimeLineViewModel?;
    var remark:String?;
    var pickerView:UIPickerView? = nil;
    var currentRow = 0;
    var dropDown:DropDown? = nil;
    
    let disposeBag = DisposeBag();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        btn_close.addTarget(self, action: #selector(onBtnCloseClick), for: UIControl.Event.touchUpInside);
        btn_confirm.addTarget(self, action: #selector(onBtnConfirmClick), for: UIControl.Event.touchUpInside);
        let tap = UITapGestureRecognizer(target:self, action:#selector(showMinutePickerView));
        v_time.isUserInteractionEnabled = true;
        v_time.addGestureRecognizer(tap);
        
        btn_remarkDetail.addTarget(self, action: #selector(onRemarkDetailClick), for: UIControl.Event.touchUpInside)
    }
    func initView(){
        viewModel = TimeLineViewModel.sharedInstance;
        setTeamImg(url: viewModel!.currentTeam!.headImg);
        lb_teamName.text = viewModel!.currentTeam!.name!;
        if(viewModel!.currentPlayer != nil){
            setPlayerImg(url: viewModel!.currentPlayer!.headImg);
            lb_playerName.text = viewModel!.currentPlayer!.name;
        }else{
            setPlayerImg(url: nil);
            lb_playerName.text = "无";
        }
        iv_eventImg.image = UIImage.svg(named: viewModel!.currentEvent!.icon,size: CGSize.init(width: 40, height: 40));
        lb_eventName.text = viewModel!.currentEvent!.text;

        //dropdown
        currentRow = 0;
        dropDown = DropDown();
//        dropDown!.anchorView = btn_remarkDetail;
        dropDown!.dataSource = [];
        dropDown!.direction = .top;
        dropDown!.width = 160;
        
        dropDown!.bottomOffset = CGPoint(x: 0, y: 25);
        dropDown!.selectionAction = { [unowned self] (index: Int, item: String) in
            self.btn_remarkDetail.setTitle(item, for: UIControl.State.normal);
            if(self.viewModel!.currentEvent!.remarkValue == nil){
                self.remark = String(self.viewModel!.controller!.playerVc!.playerList[index].id!);
            }else{
                for i in self.viewModel!.currentEvent!.remarkValue! {
                    for (key, value) in i {
                        if(key == item){
                            self.remark = value;
                        }
                    }
                }
            }
        }
        //remark
        remark = nil;
        btn_remarkDetail.setTitle("请选择", for: UIControl.State.normal);
        if(viewModel!.currentEvent!.remarkName != nil){
            lb_remark.text = viewModel!.currentEvent!.remarkName!;
            var dataSource:[String] = [];
            if(viewModel!.currentEvent!.remarkValue == nil){
                for item in viewModel!.controller!.playerVc!.playerList {
                    if(item.id != viewModel!.currentPlayer!.id){
                        dataSource.append(item.name! + "(" + String(item.shirtNum!) + ")");
                    }
                }
                dropDown!.dataSource = dataSource;
            }else{
                for item in viewModel!.currentEvent!.remarkValue! {
                    for (key, value) in item {
                        dataSource.append(key);
                    }
                }
                dropDown!.dataSource = dataSource;
            }
            lb_remark.isHidden = false;
            btn_remarkDetail.isHidden = false;
        }else{
            lb_remark.isHidden = true;
            btn_remarkDetail.isHidden = true;
        }
        if(viewModel!.controller!.matchStatus == nil){
            tf_time.text = "0"
        }else{
            if(viewModel!.controller!.matchStatus!.time == nil){
                tf_time.text = "0"
            }else{
                tf_time.text = String(viewModel!.controller!.matchStatus!.time!);
            }
        }
        tv_description.text = "";
        tv_description.isEditable = false;
        let tap = UITapGestureRecognizer(target:self, action:#selector(showDescriptionEditer));
        tv_description.isUserInteractionEnabled = true;
        tv_description.addGestureRecognizer(tap);
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
        tf_time.text = String(currentRow);
    }
    //选队员
    @objc func onRemarkDetailClick(sender: UIButton){
//        let window = UIWindow(frame: UIScreen.main.bounds)
        dropDown!.show(onTopOf: self.view.window);
    }
    //地区选择器
    @objc func showMinutePickerView(){
        pickerView = UIPickerView.init();
        pickerView!.dataSource = self;
        pickerView!.delegate = self;
        if(currentRow != nil){
            pickerView!.selectRow(currentRow,inComponent:0,animated:false)
        }else{
            pickerView!.selectRow(0,inComponent:0,animated:false)
        }
        let alertController:UIAlertController=UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.actionSheet);
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default){
            (alertAction)->Void in
        });
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel,handler:nil));
        let width = UIScreen.main.bounds.width;
        let height = UIScreen.main.bounds.height;
        pickerView!.frame = CGRect(x: 0, y: 0, width: width > height ? height : width, height: 150);
        alertController.view.addSubview(pickerView!);
        self.present(alertController, animated: false, completion: nil);
    }
    @objc func showDescriptionEditer(){
        let alertController:UIAlertController=UIAlertController(title: "请输入描述", message: nil, preferredStyle: UIAlertController.Style.alert);
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default){
            (alertAction)->Void in
            self.tv_description.text = alertController.textFields![0].text;
        });
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel,handler:nil));
        alertController.addTextField { (textField) in
        }
        self.present(alertController, animated: false, completion: nil);
    }
    func setTeamImg(url: String?) {
        if(url == nil){
            iv_teamImg.image = UIImage.init(named: "defaultAvatar.jpg")
        }else{
            iv_teamImg.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "defaultAvatar.jpg"));
        }
    }
    func setPlayerImg(url: String?) {
        if(url == nil){
            iv_playerImg.image = UIImage.init(named: "defaultAvatar.jpg")
        }else{
            iv_playerImg.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "defaultAvatar.jpg"));
        }
    }
    @objc func onBtnConfirmClick(){
        let matchId:Int = self.viewModel!.controller!.currentMatchId!;
        let teamId:Int = self.viewModel!.currentTeam!.id!;
        let playerId:Int? = self.viewModel!.currentPlayer == nil ? nil : self.viewModel!.currentPlayer!.id!;
        let eventtype:Int = self.viewModel!.currentEvent!.eventType;
        let minute:Int = Int(self.tf_time.text!)!;
        let remark:String? = self.remark;
        var text:String? = self.tv_description.text;
        if(text != nil && text!.trimmingCharacters(in: CharacterSet.whitespaces) == ""){
            text = nil;
        }
        //换人
        if(eventtype == 10 && (remark == nil || remark!.trimmingCharacters(in: CharacterSet.whitespaces) == "")){
            self.viewModel!.controller!.view.makeToast("请选择换上的球员");
            return;
        }
        btn_confirm.isUserInteractionEnabled = false;
        viewModel!.addTimeLine(matchId: matchId, teamId: teamId, playerId: playerId, eventtype: eventtype, minute: minute, remark: remark, text: text, callback: { (response) in
            if(response.data != nil && response.data!){
                self.viewModel!.controller!.view.makeToast("添加成功");
                self.viewModel!.controller!.fpc_timeRemark.hide(animated: false, completion: {
                    self.viewModel!.controller!.fpc.show(animated: false);
                })
            }else{
                self.viewModel!.controller!.view.makeToast(response.message);
            }
            self.btn_confirm.isUserInteractionEnabled = true;
            self.viewModel!.controller!.refreshData();
        }, disposeBag: disposeBag)
    }
    @objc func onBtnCloseClick(){
        viewModel!.controller!.fpc_timeRemark.hide(animated: false) {
            if(self.viewModel!.currentPlayer == nil){
                self.viewModel!.controller!.fpc_team.show(animated: false);
            }else{
                self.viewModel!.controller!.fpc_player.show(animated: false);
            }
        }
    }
    // MARK: FloatingPanelControllerDelegate
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return FloatingPanelStocksLayout()
    }
    
    func floatingPanel(_ vc: FloatingPanelController, behaviorFor newCollection: UITraitCollection) -> FloatingPanelBehavior? {
        return FloatingPanelStocksBehavior()
    }
    
    func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) {
        if vc.position == .full {
            // Dimiss top bar with dissolve animation
            UIView.animate(withDuration: 0.25) {
                //                self.topBannerView.alpha = 0.0
                //                self.labelStackView.alpha = 1.0
                self.view.backgroundColor = UIColor.clear
            }
        }
    }
    func floatingPanelDidEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetPosition: FloatingPanelPosition) {
        if targetPosition == .full {
            // Present top bar with dissolve animation
            UIView.animate(withDuration: 0.25) {
                //                self.topBannerView.alpha = 1.0
                //                self.labelStackView.alpha = 0.0
                self.view.backgroundColor = UIColor.clear
            }
        }
    }
    // MARK: My custom layout
    
    class FloatingPanelStocksLayout: FloatingPanelLayout {
        var initialPosition: FloatingPanelPosition {
            return .full
        }
        
        var topInteractionBuffer: CGFloat { return 0.0 }
        var bottomInteractionBuffer: CGFloat { return 0.0 }
        
        func insetFor(position: FloatingPanelPosition) -> CGFloat? {
            switch position {
            case .full: return (UIScreen.main.bounds.height - TimeLineViewModel.sharedInstance.controller!.view.safeAreaInsets.top - 334 - 44 + 20)
            case .half: return 34.0
            case .tip: return nil
            case .hidden: return nil
            }
        }
        
        func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
            return 0.0
        }
    }
    
    // MARK: My custom behavior
    
    class FloatingPanelStocksBehavior: FloatingPanelBehavior {
        var velocityThreshold: CGFloat {
            return 15.0
        }
        
        func interactionAnimator(_ fpc: FloatingPanelController, to targetPosition: FloatingPanelPosition, with velocity: CGVector) -> UIViewPropertyAnimator {
            let timing = timeingCurve(to: targetPosition, with: velocity)
            return UIViewPropertyAnimator(duration: 0, timingParameters: timing)
        }
        
        private func timeingCurve(to: FloatingPanelPosition, with velocity: CGVector) -> UITimingCurveProvider {
            let damping = self.damping(with: velocity)
            return UISpringTimingParameters(dampingRatio: damping,
                                            frequencyResponse: 0.4,
                                            initialVelocity: velocity)
        }
        
        private func damping(with velocity: CGVector) -> CGFloat {
            switch velocity.dy {
            case ...(-velocityThreshold):
                return 0.7
            case velocityThreshold...:
                return 0.7
            default:
                return 1.0
            }
        }
    }
}
