//
//  ChooseEventController.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/18.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit
import FloatingPanel

class ChooseEventController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, FloatingPanelControllerDelegate{
    var viewModel:TimeLineViewModel?;    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var btn_close: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        viewModel = TimeLineViewModel.sharedInstance;
        btn_close.addTarget(self, action: #selector(onBtnCloseClick), for: UIControl.Event.touchUpInside);
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 17;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:EventCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCollectionCell",for: indexPath) as! EventCollectionViewCell;
        cell.backgroundColor = .clear;
        let index:Int = indexPath.row;
        
        let event:TimeLineEvent = Constant.EVENT_TYPE[Constant.EVENT_SHOW[index]!]!;
        cell.iv_EventImg.image = UIImage.svg(named: event.icon,size: CGSize.init(width: 60, height: 60));
        cell.lb_EventName.text = event.text;
        if(index == 13){
            cell.lb_EventName.font = UIFont.systemFont(ofSize: 10);
        }else{
            cell.lb_EventName.font = UIFont.systemFont(ofSize: 13);
        }
        cell.tag = event.eventType;
        
        let tap = UITapGestureRecognizer(target:self, action:#selector(showTeam));
        cell.isUserInteractionEnabled = true;
        cell.addGestureRecognizer(tap);
        
        return cell;
    }
    @objc func showTeam(sender: UITapGestureRecognizer){
        let eventType = sender.view!.tag;
        self.viewModel!.currentEvent = Constant.EVENT_TYPE[eventType];
        viewModel!.controller!.teamVc.initView();
        viewModel!.controller!.fpc.hide(animated: true) {
            if(self.viewModel!.controller!.fpc_team.parent != nil){
                self.viewModel!.controller!.fpc_team.show(animated: true);
            }
            self.viewModel!.controller!.fpc_team.addPanel(toParent: self.viewModel!.controller!, belowView: nil, animated: true);
        }
    }
    @objc func onBtnCloseClick(){
        viewModel!.controller!.fpc.move(to: .tip, animated: true);
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
            return .half
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
class EventCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var iv_EventImg: UIImageView!
    
    @IBOutlet weak var lb_EventName: UILabel!
}
