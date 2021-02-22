//
//  ScoreBoardSetting.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/29.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit
import Toast_Swift
import SwiftEntryKit
//import Pikko
import RxSwift
import SDWebImage
class ScoreBoardSettingView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var iv_scoreBoard: UIImageView!
    @IBOutlet weak var lb_leagueName: UILabel!
    @IBOutlet weak var lb_hostscore: UILabel!
    @IBOutlet weak var lb_guestscore: UILabel!
    @IBOutlet weak var lb_time: UILabel!
    @IBOutlet weak var lb_host: UILabel!
    @IBOutlet weak var lb_guest: UILabel!
    @IBOutlet weak var iv_hostShirt: UIImageView!
    @IBOutlet weak var iv_guestShirt: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btn_confirm: UIButton!
    @IBOutlet weak var btn_pause: UIButton!
    @IBOutlet weak var iv_hostShirt2: UIImageView!
    @IBOutlet weak var iv_guestShirt2: UIImageView!
    @IBOutlet weak var btn_hostShirt: UIButton!
    @IBOutlet weak var btn_guestShirt: UIButton!
    //Constraint
    @IBOutlet weak var leagueName_x: NSLayoutConstraint!
    @IBOutlet weak var leagueName_y: NSLayoutConstraint!
    @IBOutlet weak var hostShirt_x: NSLayoutConstraint!
    @IBOutlet weak var hostShirt_y: NSLayoutConstraint!
    @IBOutlet weak var hostName_x: NSLayoutConstraint!
    @IBOutlet weak var hostName_y: NSLayoutConstraint!
    @IBOutlet weak var hostScore_x: NSLayoutConstraint!
    @IBOutlet weak var hostScore_y: NSLayoutConstraint!
    @IBOutlet weak var gusetShirt_x: NSLayoutConstraint!
    @IBOutlet weak var guestShirt_y: NSLayoutConstraint!
    @IBOutlet weak var guestName_x: NSLayoutConstraint!
    @IBOutlet weak var guestName_y: NSLayoutConstraint!
    @IBOutlet weak var gusetScore_x: NSLayoutConstraint!
    @IBOutlet weak var guestScore_y: NSLayoutConstraint!
    @IBOutlet weak var time_x: NSLayoutConstraint!
    @IBOutlet weak var time_y: NSLayoutConstraint!
    
    var viewModel:LiveViewModel!;
    
    var scoreBoard:ScoreBoard!;

    var scoreBoardModel:ScoreBoardModel!;
    
    var scoreBoardList:[ScoreBoardModel] = [ScoreBoardModel]();
    var currentBackgroundTag = 0;
    var currentShirt:[UIImageView] = [UIImageView]();
    var timer:Timer?;
    let disposeBag = DisposeBag();
    
    private let cellIdentifier = "scoreBoardCollectionCell"

    override func awakeFromNib() {
        super.awakeFromNib();
        collectionView.register(UINib(nibName: "ScoreBoardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:cellIdentifier);
        viewModel = LiveViewModel.sharedInstance;
        iv_hostShirt.tag = 1001;
        iv_guestShirt.tag = 1002;
        btn_hostShirt.tag = 2001;
        btn_guestShirt.tag = 2002;
        addInputTarget(target: lb_leagueName);
        addInputTarget(target: lb_host);
        addInputTarget(target: lb_guest);
        addInputTarget(target: lb_time);
        addColorPicker(target: iv_hostShirt);
        addColorPicker(target: iv_guestShirt);
        addCannotTarget(target: lb_hostscore);
        addCannotTarget(target: lb_guestscore);
        addColorPicker(target: btn_hostShirt);
        addColorPicker(target: btn_guestShirt);
        
        btn_confirm.addTarget(self, action: #selector(onBtnConfirmClick), for: UIControl.Event.touchUpInside);
        
        btn_pause.addTarget(self, action: #selector(onBtnPauseClick), for: UIControl.Event.touchUpInside);
//        btn_pause.layer.cornerRadius = 15;
        btn_pause.layer.masksToBounds = true;
        btn_pause.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5);
        btn_pause.isHidden = true;
        
//        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = true;
    }
    func setUp(){
        iv_scoreBoard.image = scoreBoard.board.image;
        lb_leagueName.text = scoreBoard.lb_leagueName.text;
        lb_host.text = scoreBoard.lb_hostName.text;
        lb_guest.text = scoreBoard.lb_guestName.text;
        lb_hostscore.text = scoreBoard.lb_hostscore.text;
        lb_guestscore.text = scoreBoard.lb_guestscore.text;
        lb_time.text = scoreBoard.lb_time.text;
        iv_hostShirt.tintColor = scoreBoard.iv_hostShirt.tintColor;
        iv_guestShirt.tintColor = scoreBoard.iv_guestShirt.tintColor;
        iv_hostShirt2.tintColor = scoreBoard.iv_hostShirt.tintColor;
        iv_guestShirt2.tintColor = scoreBoard.iv_guestShirt.tintColor;
        viewModel.scoreboard(callback: { (scoreBoardModels) in
            self.scoreBoardList = scoreBoardModels;
            self.collectionView.reloadData();
        }, disposeBag: disposeBag);
    }
    func updateConstraint(scoreBoard:ScoreBoardModel){
        scoreBoardModel = scoreBoard;
        currentBackgroundTag = scoreBoard.id!
        collectionView.reloadData();
        leagueName_x.constant = CGFloat(scoreBoard.title!.x! * 600);
        leagueName_y.constant = CGFloat(scoreBoard.title!.y! * 120);
        hostShirt_x.constant = CGFloat(scoreBoard.hostshirt!.x! * 600);
        hostShirt_y.constant = CGFloat(scoreBoard.hostshirt!.y! * 120);
        hostName_x.constant = CGFloat(scoreBoard.hostname!.x! * 600);
        hostName_y.constant = CGFloat(scoreBoard.hostname!.y! * 120);
        hostScore_x.constant = CGFloat(scoreBoard.hostscore!.x! * 600);
        hostScore_y.constant = CGFloat(scoreBoard.hostscore!.y! * 120);
        gusetShirt_x.constant = CGFloat(scoreBoard.guestshirt!.x! * 600);
        guestShirt_y.constant = CGFloat(scoreBoard.guestshirt!.y! * 120);
        guestName_x.constant = CGFloat(scoreBoard.guestname!.x! * 600);
        guestName_y.constant = CGFloat(scoreBoard.guestname!.y! * 120);
        gusetScore_x.constant = CGFloat(scoreBoard.guestscore!.x! * 600);
        guestScore_y.constant = CGFloat(scoreBoard.guestscore!.y! * 120);
        time_x.constant = CGFloat(scoreBoard.time!.x! * 600);
        time_y.constant = CGFloat(scoreBoard.time!.y! * 120);
//        iv_hostShirt.sd_setImage(with: URL(string: scoreBoard.hostshirtpic!), placeholderImage: UIImage(named: "shirt2"))
//        iv_guestShirt.sd_setImage(with: URL(string: scoreBoard.guestshirtpic!), placeholderImage: UIImage(named: "shirt2"))
        iv_scoreBoard.sd_setImage(with: URL(string: scoreBoard.scoreboardpic!), placeholderImage: UIImage(named: "score-board-default.png"))
        SDWebImageManager.shared.loadImage(with: URL(string: scoreBoard.hostshirtpic!), progress: nil) { (image, data, error, cacheType, finished, imageURL) in
            if(image != nil){
                self.iv_hostShirt.image = image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate);
//                self.iv_hostShirt2.image = image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate);
            }else{
               self.iv_hostShirt.image = UIImage(named: "shirt2")
//                self.iv_hostShirt2.image = UIImage(named: "shirt2")
            }
        }
        SDWebImageManager.shared.loadImage(with: URL(string: scoreBoard.guestshirtpic!), progress: nil) { (image, data, error, cacheType, finished, imageURL) in
            if(image != nil){
                self.iv_guestShirt.image = image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate);
//                self.iv_guestShirt2.image = image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate);
            }else{
                self.iv_guestShirt.image = UIImage(named: "shirt2")
//                self.iv_guestShirt2.image = UIImage(named: "shirt2")
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ScoreBoardCollectionViewCell;
        let index:Int = indexPath.section * 2 + indexPath.row;
        let scoreBoardModel:ScoreBoardModel = scoreBoardList[index > scoreBoardList.count ? 0 : index];
        
        cell.background.sd_setImage(with: URL(string: scoreBoardModel.scoreboardpic!), placeholderImage: UIImage(named: "score-board-default.png"))
        
        if(scoreBoardModel.id! == currentBackgroundTag){
            cell.selectItem(isSelect: true)
        }else{
            cell.selectItem(isSelect: false)
        }
        cell.tag = scoreBoardModel.id!;
        let tap = UITapGestureRecognizer(target:self, action:#selector(onCellSelect));
        cell.isUserInteractionEnabled = true;
        cell.addGestureRecognizer(tap);
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if(scoreBoardList.count == 0){
            return 0;
        }
        if(scoreBoardList.count % 2 == 0){
            return 2;
        }
        return scoreBoardList.count % 2;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        if(scoreBoardList.count == 0){
            return 1;
        }
        return Int(ceil(Double(scoreBoardList.count) / 2.0));
    }
    
    @objc func onCellSelect(sender:UITapGestureRecognizer){
        currentBackgroundTag = sender.view!.tag;
        collectionView.reloadData();
        var scoreBoard:ScoreBoardModel?;
        for item in scoreBoardList {
            if(item.id! == currentBackgroundTag){
                scoreBoard = item;
            }
        }
        scoreBoardModel = scoreBoard;
        updateConstraint(scoreBoard: scoreBoard!);
    }
    func addCannotTarget(target:UIView){
        let tap = UITapGestureRecognizer(target:self, action:#selector(showCannotToast));
        target.isUserInteractionEnabled = true;
        target.addGestureRecognizer(tap);
    }
    func addInputTarget(target:UIView){
        let tap = UITapGestureRecognizer(target:self, action:#selector(showInput));
        target.isUserInteractionEnabled = true;
        target.addGestureRecognizer(tap);
    }
    @objc func showCannotToast(){
        self.makeToast("自动生成，无法修改");
    }
    @objc func showInput(sender:UITapGestureRecognizer){
        let target = sender.view as! UILabel;
        let alertController:UIAlertController=UIAlertController(title: "请输入", message: nil, preferredStyle: UIAlertController.Style.alert);
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default){
            (alertAction)->Void in
            target.text = alertController.textFields![0].text;
        });
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel,handler:nil));
        alertController.addTextField { (textField) in
            textField.text = target.text
        }
        let alertVC:UIViewController = UIViewController.init();
        self.addSubview(alertVC.view);
//        alertController.show();
        alertVC.present(alertController, animated: true, completion:{
            alertVC.view.removeFromSuperview();
        });
    }
    func addColorPicker(target:UIView){
        let tap = UITapGestureRecognizer(target:self, action:#selector(showColorPicker));
        target.isUserInteractionEnabled = true;
        target.addGestureRecognizer(tap);
    }
    @objc func showColorPicker(target:UITapGestureRecognizer){
        if(target.view!.tag == 1001 || target.view!.tag == 2001){
            currentShirt = [iv_hostShirt,iv_hostShirt2];
        }else if(target.view!.tag == 1002 || target.view!.tag == 2002){
            currentShirt = [iv_guestShirt,iv_guestShirt2];
        }
        var attributes = EKAttributes.centerFloat;
        let widthConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 300);
        let heightConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 300);
        attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint);
        attributes.positionConstraints.rotation.isEnabled = false;
        attributes.entryBackground = .color(color: .white);
        attributes.screenBackground = .color(color: UIColor(white: 50.0/255.0, alpha: 0.3));
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero));
        attributes.scroll = .disabled
        attributes.entranceAnimation = .translation;
        attributes.exitAnimation = .translation;
        attributes.displayDuration = .infinity;
        attributes.entryInteraction = .absorbTouches;
        attributes.screenInteraction = .dismiss;
        attributes.name = "colorPicker";
//        attributes.roundCorners = .all(radius: 10);
        attributes.lifecycleEvents.didDisappear = {
//            self.viewModel!.controller!.currentScoreBoard = self.scoreBoardModel;
            self.viewModel!.controller!.showEntry(name: "scoreBoardSettingVc");
        }
        let colorPicker: ColorPicker = Bundle.main.loadNibNamed("ColorPicker", owner: self, options: nil)!.first as! ColorPicker;
        colorPicker.delegate = self;
        SwiftEntryKit.display(entry: colorPicker, using: attributes);
    }
    @objc func onBtnConfirmClick(){
        let scoreBoard = viewModel.controller!.session!.warterMarkView!.viewWithTag(101) as! ScoreBoard;
        scoreBoard.board!.image = iv_scoreBoard.image;
        scoreBoard.iv_guestShirt!.tintColor = iv_guestShirt.tintColor;
        scoreBoard.iv_hostShirt!.tintColor = iv_hostShirt.tintColor;
        scoreBoard.lb_leagueName!.text = lb_leagueName!.text;
        if(lb_leagueName!.text!.count > 12){
            scoreBoard.lb_leagueName!.font = UIFont.boldSystemFont(ofSize: 30)
        }else{
            scoreBoard.lb_leagueName!.font = UIFont.boldSystemFont(ofSize: 35)
        }
        scoreBoard.lb_hostName!.text = lb_host!.text;
        scoreBoard.lb_guestName!.text = lb_guest!.text;
        if(viewModel.isPureTimeFormat(string: lb_time!.text!)){
            scoreBoard.lb_time!.text = lb_time!.text;
        }
        viewModel.controller!.currentScoreBoard = scoreBoardModel;
        scoreBoard.updateConstraint(scoreBoard: scoreBoardModel);
        viewModel.controller!.session!.warterMarkView!.layoutIfNeeded();
        viewModel.controller!.session!.warterMarkView = viewModel.controller!.session!.warterMarkView;

        SwiftEntryKit.dismiss();
    }
    @objc func onBtnPauseClick(){
        stopTimer();
    }
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(refershTime), userInfo: nil, repeats: true)
        //开始计时器
        timer!.fire()
    }
    func stopTimer(){
        if(timer != nil){
            timer!.invalidate()
        }
    }
    @objc func refershTime(){
        let time = addTime(time: lb_time.text!);
        lb_time.text = time;
    }
    func addTime(time:String) -> String{
        let timeArray = time.split(separator: ":");
        var minite = Int(timeArray[0]);
        var second = Int(timeArray[1]);
        var minteString = "0";
        var secondString = "0";
        second = second! + 1;
        if(second! >= 60){
            minite = minite! + 1;
            second = 0;
        }
        if(minite! < 10){
            minteString = "0" + String(minite!)
        }else{
            minteString = String(minite!)
        }
        if(second! < 10){
            secondString = "0" + String(second!)
        }else{
            secondString = String(second!)
        }
        return minteString + ":" + secondString
    }
}
//extension ScoreBoardSettingView: PikkoDelegate {
//
//    /// This method gets called whenever the pikko color was updated.
//    func writeBackColor(color: UIColor) {
//        for shirt in currentShirt {
//            shirt.tintColor = color;
//        }
//    }
//}
extension ScoreBoardSettingView: ColorPickerDelegate {
    
    /// This method gets called whenever the pikko color was updated.
    func onColorChange(color: UIColor) {
        for shirt in currentShirt {
            shirt.tintColor = color;
        }
        SwiftEntryKit.dismiss();
    }
}
