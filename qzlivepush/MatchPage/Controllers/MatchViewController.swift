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

class MatchViewController: UIViewController,UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource,IndicatorInfoProvider {
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
    var searchText:String? = nil;
    
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
        let lb_hostname = cell.viewWithTag(2) as! UILabel;
        let lb_guestname = cell.viewWithTag(3) as! UILabel;
        let iv_host = cell.viewWithTag(201) as! UIImageView;
        let iv_guset = cell.viewWithTag(301) as! UIImageView;
        let lb_score = cell.viewWithTag(4) as! UILabel;
        let lb_time = cell.viewWithTag(501) as! UILabel;
        let lb_place = cell.viewWithTag(502) as! UILabel;
        let lb_status = cell.viewWithTag(503) as! UILabel;
        
        let index:Int = indexPath.row;
        let match:MatchModel = self.matchPage![index > self.matchPage!.count ? 0 : index];
        
        lb_name.text = match.name!;
        if(match.hostteam == nil && match.guestteam == nil){
            lb_hostname.text = "无";
            lb_guestname.text = "无";
            iv_host.image = UIImage(named: "logo.png");
            iv_guset.image = UIImage(named: "logo.png");
        }else{
            lb_hostname.text = match.hostteam!.name!;
            lb_guestname.text = match.guestteam!.name!;
//            iv_host.sd_setImage(with: URL(string: match.hostteam!.headimg), placeholderImage: UIImage(named: "logo.png"));
//            iv_guset.sd_setImage(with: URL(string: match.guestteam!.headimg), placeholderImage: UIImage(named: "logo.png"));
            setImg(iv: iv_host, url: match.hostteam!.headImg);
            setImg(iv: iv_guset, url: match.guestteam!.headImg);
        }
        lb_score.text = (match.status == -1 ? "VS" : match.score);
        lb_time.text = match.startTime;
        lb_place.text = match.place;
        lb_status.text = Constant.STATUS_TEXT_MAP[match.status!];
        
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
    func updateSearchResults(for searchController: UISearchController) {
        if (searchController.searchBar.text == nil || searchController.searchBar.text == ""){
            self.searchText = nil;
            self.refreshData();
        }else{
            self.searchText = searchController.searchBar.text;
            self.refreshData();
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            //            navigationItem.hidesSearchBarWhenScrolling = false;
        }
        appDelegate.interfaceOrientations = .portrait
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            //            navigationItem.hidesSearchBarWhenScrolling = true;
        }
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
        
        //searchBar
        let searchController = UISearchController(searchResultsController: nil);
        searchController.searchResultsUpdater = self;
        searchController.obscuresBackgroundDuringPresentation = false;
        self.navigationItem.searchController = searchController;
        definesPresentationContext = true;
        navigationItem.hidesSearchBarWhenScrolling = true;
        
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
            self.view.makeToast("暂无数据");
        }
    }
    //刷新数据
    func refreshData(){
        self.tv_match.es.resetNoMoreData();
        self.matchPage?.removeAll();
        viewModel?.getMatchList(pageNum: 1, pageSize: 5, leagueId: currentLeague!.id, name: self.searchText, round: [self.currentRound], status: nil, dateBegin: nil, dateEnd: nil, orderby: nil, isActivity: nil, disposeBag: disposeBag);
    }
    //加载更多
    func loadMoreData(){
        if(pageInfo != nil && (pageInfo!.current! < pageInfo!.pages!) == false){
            self.tv_match.es.stopLoadingMore();
            self.tv_match.es.noticeNoMoreData();
            return;
        }
        viewModel?.getMatchList(pageNum: pageInfo!.current! + 1, pageSize: pageInfo!.size!, leagueId: currentLeague!.id, name: self.searchText, round: [self.currentRound], status: nil, dateBegin: nil, dateEnd: nil, orderby: nil, isActivity: nil, disposeBag: disposeBag);
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
        let liveActionBasketBall = UIAlertAction(title: "直播+统计（篮球）", style: .default, handler: self.handleLiveBasketballAction);
        let stasticsAction = UIAlertAction(title: "仅统计", style: .default, handler: self.handleStasticsAction);
        alertController.addAction(cancelAction);
        alertController.addAction(liveAction);
        alertController.addAction(liveActionBasketBall);
        alertController.addAction(stasticsAction);
        self.present(alertController, animated: true, completion: nil);
    }
    func handleLiveAction(action: UIAlertAction){
        if(currentMatch != nil && currentMatch!.activityId != nil){
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "LivePage") as! LiveController
            vc.currentMatchId = currentMatch!.id!;
            vc.currentMatch = currentMatch!;
            vc.isBasketBall = false;
            vc.modalPresentationStyle = .fullScreen
            //跳转
            self.present(vc, animated: true,completion: nil);
        }else{
            self.view.makeToast("当前比赛无直播权限");
        }
    }
    func handleLiveBasketballAction(action: UIAlertAction){
        if(currentMatch != nil && currentMatch!.activityId != nil){
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "LivePage") as! LiveController
            vc.currentMatchId = currentMatch!.id!;
            vc.currentMatch = currentMatch!;
            vc.isBasketBall = true;
            vc.modalPresentationStyle = .fullScreen
            //跳转
            self.present(vc, animated: true,completion: nil);
        }else{
            self.view.makeToast("当前比赛无直播权限");
        }
    }
    func handleStasticsAction(action: UIAlertAction){
        if(currentMatch != nil && currentMatch!.type!.contains(1)){
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "TimeLinePage") as! TimeLineController
            vc.currentMatchId = currentMatch!.id!;
            vc.currentMatch = currentMatch!;
            vc.isEntry = false;
            TimeLineViewModel.sharedInstance.liveController = nil;
            vc.viewModel = TimeLineViewModel.sharedInstance;
            vc.modalPresentationStyle = .fullScreen
            //跳转
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.view.makeToast("当前比赛无统计权限");
        }
    }
}
