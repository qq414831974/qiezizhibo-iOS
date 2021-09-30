//
//  MatchViewController.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/11.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit
import RxSwift
import ESPullToRefresh
import SDWebImage
import XLPagerTabStrip
import Toast_Swift

class MatchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,IndicatorInfoProvider {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var itemInfo: IndicatorInfo = "View";
    var currentMatch:MatchModel? = nil;
    
    static func instantiate(itemInfo:String?) -> MatchViewController
    {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sb_matchList") as! MatchViewController;
        if(itemInfo != nil){
            viewController.itemInfo = IndicatorInfo.init(title: itemInfo);
        }
        return viewController;
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    var currentLeague: LeagueModel?;
    var currentRound: String?;
    
    @IBOutlet weak var tv_match: UITableView!
    var viewModel:MatchViewModel?;
    let disposeBag = DisposeBag();
    var pageInfo:PageModel<MatchModel>?;
    var matchPage:[MatchModel]? = [MatchModel]();
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchPage == nil ? 0 : self.matchPage!.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchIdentifier",for: indexPath);
        let lb_name = cell.viewWithTag(1) as! UILabel;
        let lb_time = cell.viewWithTag(501) as! UILabel;
        let lb_place = cell.viewWithTag(502) as! UILabel;
        let lb_status = cell.viewWithTag(503) as! UILabel;
        let view_matchAgainst_container = cell.viewWithTag(101)!;
        let view_matchAgainst = view_matchAgainst_container.viewWithTag(1011)!;

        let index:Int = indexPath.row;
        let match:MatchModel = self.matchPage![index > self.matchPage!.count ? 0 : index];
        
        lb_name.text = match.name!;
        if(match.againstTeams != nil && !match.againstTeams!.isEmpty){
            var index = 0;
            for key in match.againstTeams!.keys{
                let againstTeam = match.againstTeams![key];
                var hostTeamName = "无";
                var guestTeamName = "无";
                var hostTeamHeadImg:String? = nil;
                var guestTeamHeadImg:String? = nil;
                var score = "0-0";
                if(againstTeam != nil && againstTeam!.hostTeam != nil){
                    hostTeamName = againstTeam!.hostTeam!.name!;
                    hostTeamHeadImg = againstTeam!.hostTeam!.headImg != nil ? againstTeam!.hostTeam!.headImg! : nil;
                }
                if(againstTeam != nil && againstTeam!.guestTeam != nil){
                    guestTeamName = againstTeam!.guestTeam!.name!;
                    guestTeamHeadImg = againstTeam!.guestTeam!.headImg != nil ? againstTeam!.guestTeam!.headImg! : nil;
                }
                if(match.status != nil && match.status!.score != nil && match.status!.score![key] != nil){
                    score = match.status!.score![key]!;
                }
                let matchAgainst = MatchAgainstView(frame: CGRect(x: index * 300 + (index + 1) * 10, y: 5, width: 300, height: 60));
                matchAgainst.tag = 2000 + Int(key)!;
                matchAgainst.lb_vs?.text = score;
                matchAgainst.lb_hostName?.text = hostTeamName;
                matchAgainst.lb_guestName?.text = guestTeamName;

                setImg(iv: matchAgainst.iv_hostHeadImg!, url: hostTeamHeadImg);
                setImg(iv: matchAgainst.iv_guestHeadImg!, url: guestTeamHeadImg);
                view_matchAgainst.addSubview(matchAgainst);
                index = index + 1;
            }

            let scrollWidthConstraint = view_matchAgainst.constraints.filter { $0.identifier == "againstScrollWidth" }.first
            scrollWidthConstraint!.constant = CGFloat(index * 300 + (index + 1) * 10);
            if(CGFloat(index * 300 + (index + 1) * 10) < (UIScreen.main.bounds.width - 20)){
                let contentViewLeadingConstraint = view_matchAgainst_container.constraints.filter { $0.identifier == "contentViewLeading" }.first
                contentViewLeadingConstraint!.constant = (UIScreen.main.bounds.width - 20.0 - CGFloat(index * 300 + (index + 1) * 10)) / 2 ;
            }
        }else{
            let againstLabel = UILabel()
            againstLabel.text = "无对阵"
            againstLabel.textColor = UIColor.black;
            againstLabel.font = UIFont.systemFont(ofSize: 15);
            againstLabel.textAlignment = NSTextAlignment.center;
            let heightConstraint = NSLayoutConstraint.init(item: againstLabel, attribute: NSLayoutConstraint.Attribute.height, relatedBy:NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 70);
            let widthConstraint = NSLayoutConstraint.init(item: againstLabel, attribute: NSLayoutConstraint.Attribute.width, relatedBy:NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant:UIScreen.main.bounds.width - 20)
            let leftConstraint = NSLayoutConstraint.init(item: againstLabel, attribute: NSLayoutConstraint.Attribute.leading, relatedBy:NSLayoutConstraint.Relation.equal, toItem: view_matchAgainst, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
            let topConstraint = NSLayoutConstraint.init(item: againstLabel, attribute: NSLayoutConstraint.Attribute.top, relatedBy:NSLayoutConstraint.Relation.equal, toItem: view_matchAgainst, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
            againstLabel.translatesAutoresizingMaskIntoConstraints = false;
            view_matchAgainst.translatesAutoresizingMaskIntoConstraints = false
            againstLabel.addConstraint(heightConstraint);
            againstLabel.addConstraint(widthConstraint);
            view_matchAgainst.addSubview(againstLabel);
            view_matchAgainst.addConstraint(leftConstraint);
            view_matchAgainst.addConstraint(topConstraint);
            
            let scrollWidthConstraint = view_matchAgainst.constraints.filter { $0.identifier == "againstScrollWidth" }.first
            scrollWidthConstraint!.constant = UIScreen.main.bounds.width - 20;
        }
        lb_time.text = match.startTime;
        lb_place.text = match.place;
        if(match.status != nil && match.status!.status != nil){
            lb_status.text = Constant.STATUS_TEXT_MAP[match.status!.status!];
        }
        cell.tag = match.id!;
        
        let tap = UITapGestureRecognizer(target:self, action:#selector(showSelect));
        
        cell.isUserInteractionEnabled = true;
        cell.addGestureRecognizer(tap);
        
        return cell;
    }
    func setImg(iv:UIImageView,url: String?) {
        if(url == nil){
            iv.image = UIImage.init(named: "logo.png")
        }else{
            iv.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "logo.png"));
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.interfaceOrientations = .portrait
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        self.tv_match.es.addPullToRefresh {
            [unowned self] in
            /// 在这里做刷新相关事件
            self.refreshData();
        }
        self.tv_match.es.addInfiniteScrolling {
            [unowned self] in
            /// 在这里做加载更多相关事件
            self.loadMoreData();
        }
        //注入
        viewModel = MatchViewModel.init(self);
        
        //加载数据
        refreshData();
    }
    //刷新表格
    func reloadData(){
        tv_match.reloadData();
        self.tv_match.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false);
        self.tv_match.es.stopLoadingMore();
        if(self.matchPage!.count == 0 || self.matchPage == nil){
            self.tv_match.es.noticeNoMoreData();
            self.view.makeToast("暂无数据",position: .center);
        }
    }
    //刷新数据
    func refreshData(){
        self.tv_match.es.resetNoMoreData();
        self.matchPage?.removeAll();
        viewModel?.getMatchList(pageNum: 1, pageSize: 5, sortOrder: "desc", sortField: "startTime", leagueId: currentLeague!.id, round: self.currentRound, disposeBag: disposeBag);
    }
    //加载更多
    func loadMoreData(){
        if(pageInfo != nil && (pageInfo!.current! < pageInfo!.pages!) == false){
            self.tv_match.es.stopLoadingMore();
            self.tv_match.es.noticeNoMoreData();
            return;
        }
        viewModel?.getMatchList(pageNum: pageInfo!.current! + 1, pageSize: pageInfo!.size!, sortOrder: "desc", sortField: "startTime", leagueId: currentLeague!.id, round: self.currentRound, disposeBag: disposeBag);
    }
    //提示
    @objc func showSelect(sender: UITapGestureRecognizer){
        matchPage!.forEach { (matchModel) in
            if(matchModel.id == sender.view!.tag){
                currentMatch = matchModel;
            }
        }
        let alertController = UIAlertController(title: currentMatch!.name, message: currentMatch!.startTime, preferredStyle: .actionSheet);
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil);
        let liveAction = UIAlertAction(title: "直播+统计", style: .default, handler: self.handleLiveAction);
        alertController.addAction(cancelAction);
        alertController.addAction(liveAction);
        self.present(alertController, animated: true, completion: nil);
    }
    func handleLiveAction(action: UIAlertAction){
        if(currentMatch != nil && currentMatch!.activityId != nil){
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "LivePage") as! LiveController
            vc.currentMatchId = currentMatch!.id!;
            vc.currentMatch = currentMatch!;
            vc.modalPresentationStyle = .fullScreen
            //跳转
            self.present(vc, animated: true,completion: nil);
        }else{
            self.view.makeToast("当前比赛无直播权限",position: .center);
        }
    }
}
