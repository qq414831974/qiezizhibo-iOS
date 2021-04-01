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

class ChooseStatusController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    var viewModel:TimeLineViewModel?;
    var statusRemarkVc:StatusRemarkController!;
    
    @IBOutlet weak var collectionView: UICollectionView!
        
    var currentEvent:TimeLineEvent!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        statusRemarkVc = storyboard?.instantiateViewController(withIdentifier: "statusRemarkVc") as? StatusRemarkController;
    }
    func setUp(){
        viewModel = TimeLineViewModel.sharedInstance;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5;
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

    @objc func showDialog(sender: UITapGestureRecognizer){
        let eventType = sender.view!.tag;
        currentEvent = Constant.EVENT_TYPE[eventType]!;
        SwiftEntryKit.dismiss(SwiftEntryKit.EntryDismissalDescriptor.specific(entryName: "statusVc")) {
            var attributes = EKAttributes.centerFloat;
            let widthConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 400);
            let heightConstraint = EKAttributes.PositionConstraints.Edge.constant(value: 220);
            attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint);
            attributes.entryBackground = .color(color: .groupTableViewBackground);
            attributes.screenBackground = .color(color: UIColor(white: 50.0/255.0, alpha: 0.3));
            attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 10, offset: .zero));
            attributes.entranceAnimation = .none;
            attributes.exitAnimation = .translation;
            attributes.displayDuration = .infinity;
            attributes.entryInteraction = .absorbTouches;
            attributes.screenInteraction = .dismiss;
            attributes.name = "statusRemarkVc";
            self.statusRemarkVc.setUp();
            attributes.lifecycleEvents.willAppear = {
                if(self.currentEvent.eventType == 5){
                    let hostTeamName = self.viewModel!.controller!.hostTeamName;
                    let guestTeamName = self.viewModel!.controller!.guestTeamName;
                    let hostTeamHeadImg = self.viewModel!.controller!.hostTeamHeadImg;
                    let guestTeamHeadImg = self.viewModel!.controller!.guestTeamHeadImg;
                    let score = String(self.viewModel!.controller!.hostScore) + "-" + String(self.viewModel!.controller!.guestScore);
                    self.statusRemarkVc.showMatchAgainstSelector(hostTeamName: hostTeamName, guestTeamName: guestTeamName, hostTeamHeadImg: hostTeamHeadImg, guestTeamHeadImg: guestTeamHeadImg, score: score);
                }else{
                    self.statusRemarkVc.hideMatchAgainstSelector();
                }
                self.statusRemarkVc.iv_EventImg.image = UIImage.svg(named: self.currentEvent.icon,size: CGSize.init(width: 50, height: 50));
                self.statusRemarkVc.lb_EventName.text = self.currentEvent.text;
                self.statusRemarkVc.eventType = self.currentEvent.eventType;
            }
            SwiftEntryKit.display(entry: self.statusRemarkVc, using: attributes);
        }
    }
}

class StatusCollectionCell: UICollectionViewCell{
    @IBOutlet weak var iv_EventImg: UIImageView!
    @IBOutlet weak var lb_EventName: UILabel!
}
