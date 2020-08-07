//
//  LeagueViewController.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/5/22.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import ESPullToRefresh
import SDWebImage
import DropDown

class LeagueViewController: UIViewController,UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var tv_league: UITableView!
    var viewModel:LeagueViewModel?;
    let disposeBag = DisposeBag();
    var pageInfo:PageModel<LeagueModel>?;
    var leaguePage:[LeagueModel]? = [LeagueModel]();
    var searchText:String? = nil;
    var pickerView:UIPickerView? = nil;
    var currentRow = 0;
    var currentIndex = 0;
    var currentCity:String? = nil;
    var currentStatus:String? = nil;
    var dropDown:DropDown? = nil;
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0){
            return Constant.PROVINCE.count;
        }
        return Constant.CITY[currentRow].count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(component == 0){
            return Constant.PROVINCE[row];
        }
        return Constant.CITY[currentRow][row];
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 0){
            currentRow = row;
            currentIndex = 0;
            currentCity = Constant.CITY[currentRow][0];
            pickerView.reloadAllComponents();
        }else{
            currentCity = Constant.CITY[currentRow][row];
            currentIndex = row;
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view:UITableViewHeaderFooterView = UITableViewHeaderFooterView.init(reuseIdentifier: "headerIdentifier");
        view.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 25);
        view.backgroundColor = UIColor.groupTableViewBackground;
        
        let btn_location:UIButton = UIButton.init(type: UIButton.ButtonType.custom);
        btn_location.frame = CGRect.init(x: tableView.frame.size.width - 190, y: 5, width: 90, height: 18);
        btn_location.titleLabel?.textAlignment = NSTextAlignment.center;
        if(currentCity != nil){
            btn_location.isSelected = true;
            btn_location.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15);
            btn_location.setTitle(self.currentCity! + " ▼", for: UIControl.State.selected);
        }else{
            btn_location.isSelected = false;
            btn_location.titleLabel?.font = UIFont.systemFont(ofSize: 15);
            btn_location.setTitle("地区 ▽", for: UIControl.State.normal);
        }
        
        btn_location.tag = 201;
        btn_location.setTitleColor(UIColor.darkGray, for: UIControl.State.normal);
        btn_location.setTitleColor(UIColor.black, for: UIControl.State.selected);
        btn_location.addTarget(self, action: #selector(btn_locationClick), for: UIControl.Event.touchUpInside);
        
        let btn_status:UIButton = UIButton.init(type: UIButton.ButtonType.custom);
        btn_status.frame = CGRect.init(x: tableView.frame.size.width - 100, y: 5, width: 90, height: 18);
        btn_status.titleLabel?.textAlignment = NSTextAlignment.center;
        if(currentStatus != nil){
            btn_status.isSelected = true;
            btn_status.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15);
            btn_status.setTitle(self.currentStatus! + " ▼", for: UIControl.State.selected);
        }else{
            btn_status.isSelected = false;
            btn_status.titleLabel?.font = UIFont.systemFont(ofSize: 15);
            btn_status.setTitle("状态 ▽", for: UIControl.State.normal);
        }
        btn_status.tag = 202;
        btn_status.setTitleColor(UIColor.darkGray, for: UIControl.State.normal);
        btn_status.setTitleColor(UIColor.black, for: UIControl.State.selected);
        btn_status.addTarget(self, action: #selector(btn_statusClick), for: UIControl.Event.touchUpInside);
        
        dropDown = DropDown();
        dropDown!.anchorView = btn_status;
        dropDown!.dataSource = ["未开始", "进行中", "已结束"];
        dropDown!.direction = .bottom;
        dropDown!.width = 80;
        dropDown!.bottomOffset = CGPoint(x: 0, y: 25);
        dropDown!.selectionAction = { [unowned self] (index: Int, item: String) in
            self.currentStatus = item;
            btn_status.isSelected = true;
            btn_status.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15);
            btn_status.setTitle(self.currentStatus! + " ▼", for: UIControl.State.selected);
            self.refreshData();
        }
        
//        view.addSubview(btn_location);
        view.addSubview(btn_status);
        return view;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.leaguePage == nil ? 0 : self.leaguePage!.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leagueIdentifier",for: indexPath);
        let iv_headimg = cell.viewWithTag(2) as! UIImageView;
        let lb_name = cell.viewWithTag(1) as! UILabel;
        let lb_city = cell.viewWithTag(3) as! UILabel;
        let lb_status = cell.viewWithTag(4) as! UILabel;
        let lb_time = cell.viewWithTag(5) as! UILabel;
        let index:Int = indexPath.row;
        if(self.leaguePage!.count == 0){
            return cell;
        }
        let league:LeagueModel = self.leaguePage![index > self.leaguePage!.count ? 0 : index];
        let dateBegin:Date = DateUtils.stringConvertDate(string: league.dateBegin!);
        let dateEnd:Date = DateUtils.stringConvertDate(string: league.dateEnd!);
        let dateNow:Date = Date();
        lb_name.text = league.name!;
        iv_headimg.sd_setImage(with: URL(string: league.headImg!), placeholderImage: UIImage(named: "logo.png"))
        lb_city.text = league.city!;
        lb_time.text = DateUtils.dateConvertString(date: dateBegin).components(separatedBy: " ").first! + " - " + DateUtils.dateConvertString(date: dateEnd).components(separatedBy: " ").first!;
        if dateNow.compare(dateBegin) == .orderedAscending
        {
            lb_status.text = "未开始";
        }
        if dateNow.compare(dateBegin) == .orderedDescending && dateNow.compare(dateEnd) == .orderedAscending
        {
            lb_status.text = "进行中";
        }
        if dateNow.compare(dateEnd) == .orderedDescending
        {
            lb_status.text = "已结束";
        }
        return cell;
    }
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text)
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
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            //            navigationItem.hidesSearchBarWhenScrolling = true;
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tv_league.es.addPullToRefresh {
            [unowned self] in
            /// 在这里做刷新相关事件
            self.refreshData();
        }
        self.tv_league.es.addInfiniteScrolling {
            [unowned self] in
            /// 在这里做加载更多相关事件
            self.loadMoreData();
        }
        //注入
        viewModel = LeagueViewModel.init(self);
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
        tv_league.reloadData();
        self.tv_league.es.stopPullToRefresh(ignoreDate: true, ignoreFooter: false);
        self.tv_league.es.stopLoadingMore();
        if(self.leaguePage!.count == 0 || self.leaguePage == nil){
            self.tv_league.es.noticeNoMoreData();
            self.view.makeToast("暂无数据");
        }
    }
    //刷新数据
    func refreshData() {
        self.tv_league.es.resetNoMoreData();
        self.leaguePage?.removeAll();
        viewModel?.getLeagueList(pageNum: 1, pageSize: 5, city: currentCity, country: "中国", name: self.searchText, state: Constant.STATUS_MAP[currentStatus] ?? nil, disposeBag: disposeBag);
    }
    //加载更多
    func loadMoreData(){
        if(pageInfo != nil && (pageInfo!.current! < pageInfo!.pages!) == false){
            self.tv_league.es.stopLoadingMore();
            self.tv_league.es.noticeNoMoreData();
            return;
        }
        viewModel?.getLeagueList(pageNum: pageInfo!.current! + 1, pageSize: pageInfo!.size!, city: currentCity, country: "中国", name: self.searchText, state: Constant.STATUS_MAP[currentStatus] ?? nil, disposeBag: disposeBag);
    }
    //地区筛选点击
    @objc func btn_locationClick(){
        let btn_location:UIButton = self.tv_league.headerView(forSection: 0)!.viewWithTag(201) as! UIButton;
        if(btn_location.isSelected == true){
            switchLocationPicker(isFilter: false);
            return;
        }
        showLocationPickerView();
    }
    //状态筛选点击
    @objc func btn_statusClick(){
        //        let btn_location:UIButton = tv_league.headerView(forSection: 0)!.viewWithTag(202) as! UIButton;
        //        btn_location.isSelected = true;
        //        btn_location.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15);
        //        btn_location.setTitle("状态 ▼", for: UIControl.State.selected);
        showStatusPickerView();
    }
    //地区选择器
    func showLocationPickerView(){
        pickerView = UIPickerView.init();
        pickerView!.dataSource = self;
        pickerView!.delegate = self;
        if(currentCity != nil){
            pickerView!.selectRow(currentIndex,inComponent:currentRow,animated:true)
        }else{
            pickerView!.selectRow(0,inComponent:0,animated:true)
        }
        self.currentCity = Constant.CITY[1][0];
        let alertController:UIAlertController=UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.actionSheet);
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default){
            (alertAction)->Void in
            self.switchLocationPicker(isFilter: true);
        });
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel,handler:nil));
        let width = self.view.frame.width;
        pickerView!.frame = CGRect(x: 10, y: 0, width: width, height: 250);
        alertController.view.addSubview(pickerView!);
        self.present(alertController, animated: true, completion: nil);
    }
    //切换筛选状态
    func switchLocationPicker(isFilter: Bool){
        let btn_location:UIButton = self.tv_league.headerView(forSection: 0)!.viewWithTag(201) as! UIButton;
        if(isFilter){
            btn_location.isSelected = true;
            btn_location.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15);
            btn_location.setTitle(self.currentCity! + " ▼", for: UIControl.State.selected);
        }else{
            btn_location.isSelected = false;
            btn_location.titleLabel?.font = UIFont.systemFont(ofSize: 15);
            btn_location.setTitle("地区 ▽", for: UIControl.State.normal);
            currentCity = nil;
        }
        self.refreshData();
    }
    //状态选择器
    func showStatusPickerView(){
        let btn_status:UIButton = tv_league.headerView(forSection: 0)!.viewWithTag(202) as! UIButton;
        if(dropDown!.isHidden){
            if(btn_status.isSelected == true){
                self.currentStatus = nil;
                btn_status.isSelected = false;
                btn_status.titleLabel?.font = UIFont.systemFont(ofSize: 15);
                btn_status.setTitle("状态 ▽", for: UIControl.State.normal);
                refreshData();
            }else{
                dropDown!.show();
            }
        }else{
            dropDown!.hide();
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMatchSegue" {
            if let row = tv_league.indexPathForSelectedRow?.row {
                let league:LeagueModel = self.leaguePage![row > self.leaguePage!.count ? 0 : row];
                let data = league;
                let detailViewController = segue.destination as! MatchTabViewController;
                detailViewController.currentLeague = data
            }
        }
    }
}
