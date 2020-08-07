//
//  MatchTabViewController.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/11.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import ObjectMapper
import RxSwift

class MatchTabViewController: ButtonBarPagerTabStripViewController {
    var viewModel:MatchViewModel?;
    var currentLeague: LeagueModel?;
    var rounds = [String]();
    let disposeBag = DisposeBag();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = currentLeague!.name;
        buttonBarView.selectedBar.backgroundColor = UIColor.init(red: 0, green: 0.57, blue: 1, alpha: 1);
        buttonBarView.backgroundColor = UIColor.groupTableViewBackground;
        settings.style.buttonBarItemBackgroundColor = UIColor.groupTableViewBackground;
        settings.style.buttonBarItemTitleColor = UIColor.darkText;
        viewModel = MatchViewModel.init(nil);
        viewModel?.getLeagueMatch(id: currentLeague!.id!, callback: { (leagueModel) in
            self.currentLeague = leagueModel;
            self.reloadPagerTabStripView();
//            self.reloadInputViews();
        }, disposeBag: disposeBag)
    }
    override func viewDidAppear(_ animated: Bool) {
        if(currentLeague!.currentRound != nil){
            let index = rounds.firstIndex(of: currentLeague!.currentRound!);
            if(index != nil ){
                self.moveToViewController(at: index!, animated: true);
            }
        }
    }
    // MARK: - PagerTabStripDataSource
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var childList = [MatchViewController]();
        if(self.currentLeague!.round != nil && self.currentLeague!.round!.rounds != nil){
            rounds = self.currentLeague!.round!.rounds!;
            rounds.forEach { (round) in
                let child = MatchViewController.instantiate(itemInfo: round);
                child.currentLeague = self.currentLeague;
                if(round.trimmingCharacters(in: CharacterSet.whitespaces) != ""){
                    child.currentRound = round;
                }
                childList.append(child);
            }
        }else{
            let child = MatchViewController.instantiate(itemInfo: "所有场次");
            child.currentLeague = self.currentLeague;
            childList.append(child);
        }
        
            return childList;
    }
}
