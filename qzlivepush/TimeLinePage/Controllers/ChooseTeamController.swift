//
//  ChooseTeamController.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/18.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit
import FloatingPanel
import SDWebImage

class ChooseTeamController: UIViewController,FloatingPanelControllerDelegate{
    var viewModel:TimeLineViewModel?;
    
    @IBOutlet weak var iv_host: UIImageView!
    
    @IBOutlet weak var iv_guest: UIImageView!

    @IBOutlet weak var lb_host: UILabel!
    
    @IBOutlet weak var lb_guest: UILabel!
    
    @IBOutlet weak var btn_close: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        viewModel = TimeLineViewModel.sharedInstance;
        btn_close.addTarget(self, action: #selector(onBtnCloseClick), for: UIControl.Event.touchUpInside);
    }
    func initView() {
        self.viewModel!.currentPlayer = nil;
        
        var tapFunc_host:UITapGestureRecognizer!;
        var tapFunc_guest:UITapGestureRecognizer!;
        
        let eventType = viewModel!.currentEvent!.eventType;
        if(eventType == 1 || eventType == 2 || eventType == 7 || eventType == 8 || eventType == 10 || eventType == 22){
            tapFunc_host = UITapGestureRecognizer(target:self, action:#selector(showPlayer));
            tapFunc_guest = UITapGestureRecognizer(target:self, action:#selector(showPlayer));
        }else{
            tapFunc_host = UITapGestureRecognizer(target:self, action:#selector(showTimeAndRemark));
            tapFunc_guest = UITapGestureRecognizer(target:self, action:#selector(showTimeAndRemark));
        }
        iv_host.isUserInteractionEnabled = true;
        iv_host.addGestureRecognizer(tapFunc_host);
        
        iv_guest.isUserInteractionEnabled = true;
        iv_guest.addGestureRecognizer(tapFunc_guest);
    }
    func setHostImg(url: String?,tag: Int) {
        iv_host.tag = tag;
        if(url == nil){
            iv_host.image = UIImage.init(named: "defaultAvatar.jpg")
        }else{
            iv_host.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "defaultAvatar.jpg"));
        }
    }
    func setGuestImg(url: String?,tag: Int) {
        iv_guest.tag = tag;
        if(url == nil){
            iv_guest.image = UIImage.init(named: "defaultAvatar.jpg")
        }else{
            iv_guest.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "defaultAvatar.jpg"));
        }
    }
    @objc func onBtnCloseClick(){
        viewModel!.controller!.fpc_team.hide(animated: false) {
            self.viewModel!.controller!.fpc.show(animated: false)
        }
    }
    @objc func showPlayer(sender: UITapGestureRecognizer){
        let teamId = sender.view!.tag;
        if(self.viewModel!.controller!.currentMatch == nil){
            return;
        }
        if(self.viewModel!.controller!.currentMatch!.hostTeam == nil){
            return;
        }
        if(self.viewModel!.controller!.currentMatch!.guestTeam == nil){
            return;
        }
        if(self.viewModel!.controller!.currentMatch!.hostTeam!.id == teamId){
            self.viewModel!.currentTeam = self.viewModel!.controller!.currentMatch!.hostTeam!;
        }else{
            self.viewModel!.currentTeam = self.viewModel!.controller!.currentMatch!.guestTeam!;
        }
        self.viewModel!.controller!.playerVc.getTeamPlayer(teamId: teamId);
        viewModel!.controller!.fpc_team.hide(animated: false) {
            if(self.viewModel!.controller!.fpc_player.parent != nil){
                self.viewModel!.controller!.fpc_player.show(animated: false);
            }
            self.viewModel!.controller!.fpc_player.addPanel(toParent: self.viewModel!.controller!, belowView: nil, animated: false);
        }
    }
    @objc func showTimeAndRemark(sender:UITapGestureRecognizer){
        let teamId = sender.view!.tag;
        if(self.viewModel!.controller!.currentMatch == nil){
            return;
        }
        if(self.viewModel!.controller!.currentMatch!.hostTeam == nil){
            return;
        }
        if(self.viewModel!.controller!.currentMatch!.guestTeam == nil){
            return;
        }
        if(self.viewModel!.controller!.currentMatch!.hostTeam!.id == teamId){
            self.viewModel!.currentTeam = self.viewModel!.controller!.currentMatch!.hostTeam!;
        }else{
            self.viewModel!.currentTeam = self.viewModel!.controller!.currentMatch!.guestTeam!;
        }
        viewModel!.controller!.fpc_team.hide(animated: false) {
            self.viewModel!.controller!.timeRemarkVc.initView();
            if(self.viewModel!.controller!.fpc_timeRemark.parent != nil){
                self.viewModel!.controller!.fpc_timeRemark.show(animated: false);
            }
            self.viewModel!.controller!.fpc_timeRemark.addPanel(toParent: self.viewModel!.controller!, belowView: nil, animated: false);
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
            case .full: return (UIScreen.main.bounds.height - TimeLineViewModel.sharedInstance.controller!.view.safeAreaInsets.top - 144 - 44 + 20)
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
