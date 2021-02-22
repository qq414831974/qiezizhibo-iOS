//
//  ChoosePlayerController.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/18.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit
import RxSwift
import FloatingPanel

class ChoosePlayerController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, FloatingPanelControllerDelegate{
    var viewModel:TimeLineViewModel?;
    let disposeBag = DisposeBag();
    var playerList:[PlayerModel] = [PlayerModel]();
    @IBOutlet weak var btn_close: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        viewModel = TimeLineViewModel.sharedInstance;
        btn_close.addTarget(self, action: #selector(onBtnCloseClick), for: UIControl.Event.touchUpInside);
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(playerList.count > 0){
            return self.playerList.count;
        }
        return 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:PlayerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "playerCollectionCell",for: indexPath) as! PlayerCollectionViewCell;
        cell.backgroundColor = .clear;
        let index:Int = indexPath.row;
        
        let player:PlayerModel = playerList[index > self.playerList.count ? 0 : index];
        
        cell.setPlayerImg(url: player.headImg);
        cell.lb_playerName.text = player.name!;
        cell.setPlayerShirt(num: player.shirtNum!);

        cell.tag = player.id!;

        let tap = UITapGestureRecognizer(target:self, action:#selector(showTimeAndRemark));
        cell.isUserInteractionEnabled = true;
        cell.addGestureRecognizer(tap);

        return cell;
    }
    @objc func onBtnCloseClick(){
        viewModel!.controller!.fpc_player.hide(animated: false) {
            self.viewModel!.controller!.fpc_team.show(animated: false)
        }
    }
    @objc func showTimeAndRemark(sender:UITapGestureRecognizer){
        let playerId = sender.view!.tag;
        for item in playerList {
            if(item.id! == playerId){
                self.viewModel!.currentPlayer = item;
            }
        }
        viewModel!.controller!.fpc_player.hide(animated: false) {
            self.viewModel!.controller!.timeRemarkVc.initView();
            if(self.viewModel!.controller!.fpc_timeRemark.parent != nil){
                self.viewModel!.controller!.fpc_timeRemark.show(animated: false);
            }
            self.viewModel!.controller!.fpc_timeRemark.addPanel(toParent: self.viewModel!.controller!, belowView: nil, animated: false);
        }
    }
    func getTeamPlayer(teamId:Int){
        viewModel!.getMatchPlayersByTeamId(matchId: viewModel!.controller!.currentMatchId!, teamId: teamId, callback: { (playerList) in
            self.playerList = playerList;
            self.collectionView.reloadData();
        }, disposeBag: disposeBag);
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
            case .full: return 150.0
            case .half: return 120.0
            case .tip: return 34.0
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
class PlayerCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var iv_playerImg: UIImageView!
    
    @IBOutlet weak var lb_playerName: UILabel!
    
    @IBOutlet weak var v_playerShirt: UIView!
    
    @IBOutlet weak var lb_playerShirtNum: UILabel!
    
    @IBOutlet weak var iv_playerShirtImg: UIImageView!
    
    func setPlayerImg(url: String?) {
        if(url == nil){
            iv_playerImg.image = UIImage.init(named: "defaultAvatar.jpg")
        }else{
            iv_playerImg.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "defaultAvatar.jpg"));
        }
    }
    func setPlayerShirt(num: Int?) {
        if(num == nil){
            v_playerShirt.isHidden = true;
        }else{
            lb_playerShirtNum.text = String(num!);
        }
    }
}
