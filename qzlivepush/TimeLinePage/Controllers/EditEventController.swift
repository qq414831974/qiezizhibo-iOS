//
//  EditEventController.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/25.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit
import ObjectMapper
import DropDown

class EditEventController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate{
    @IBOutlet weak var v_event: UIView!
    
    @IBOutlet weak var v_team: UIView!
    
    @IBOutlet weak var v_player: UIView!
    
    @IBOutlet weak var v_minute: UIView!
    
    @IBOutlet weak var v_time: UIView!
    
    @IBOutlet weak var v_text: UIView!
    
    @IBOutlet weak var iv_eventImg: UIImageView!
    
    @IBOutlet weak var lb_eventName: UILabel!
    
    @IBOutlet weak var iv_teamImg: UIImageView!
    
    @IBOutlet weak var lb_teamName: UILabel!
    
    @IBOutlet weak var iv_playerImg: UIImageView!
    
    @IBOutlet weak var lb_playerName: UILabel!
    
    @IBOutlet weak var lb_minute: UITextField!
    
    @IBOutlet weak var lb_time: UITextField!
    
    @IBOutlet weak var tv_text: UITextView!
    
    @IBOutlet weak var btn_delete: UIButton!
    
    @IBOutlet weak var btn_confirm: UIButton!
    
    @IBOutlet weak var btn_cancel: UIButton!
    
    @IBOutlet weak var v_secondPlayer: UIView!
    
    @IBOutlet weak var iv_secondPlayer: UIImageView!
    
    @IBOutlet weak var lb_secondPlayer: UILabel!
    
    @IBOutlet weak var vlb_time: UIView!
    
    @IBOutlet weak var vlb_minute: UIView!
    
    var currentTimeLineEvent:TimeLineModel!;
    var teamList:[TeamModel] = [TeamModel]();
    var datePicker:UIDatePicker!;
    var pickerView:UIPickerView!;
    var dropDown:DropDown!;
    var currentRow:Int? = 0;
    var currentMinutePicker:Int?;
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
    }
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    override func viewWillAppear(_ true: Bool) {
        v_team.isHidden = true;
        for team in teamList {
            if(currentTimeLineEvent.teamId != nil && currentTimeLineEvent.teamId == team.id){
                v_team.isHidden = false;
                setImg(imageView: iv_teamImg,url: team.headImg);
                lb_teamName.text = team.name!;
            }
        }
        if(currentTimeLineEvent.player != nil){
            v_player.isHidden = false;
            setImg(imageView: iv_playerImg,url: currentTimeLineEvent.player!.headImg);
            lb_playerName.text = currentTimeLineEvent.player!.name;
        }else{
            v_player.isHidden = true;
        }
        let event = Constant.EVENT_TYPE[currentTimeLineEvent.eventType!];
        iv_eventImg.image = UIImage.svg(named: event!.icon, size: CGSize.init(width: 60, height: 60))
        lb_eventName.text = event!.text;
        if(currentTimeLineEvent.time != nil){
            v_minute.isHidden = false;
            lb_minute.text = String(currentTimeLineEvent.time!);
            let tap = UITapGestureRecognizer(target:self, action:#selector(showMinutePicker));
            vlb_minute.isUserInteractionEnabled = true;
            vlb_minute.addGestureRecognizer(tap);
            vlb_minute.tag = 201;
        }else{
            v_minute.isHidden = true;
        }
        if(event!.eventType == 1 || event!.eventType == 10){
            if(currentTimeLineEvent.remark != nil){
                let player:PlayerModel?;
                do{
                    player = try Mapper<PlayerModel>().map(JSONString: currentTimeLineEvent.remark!);
                    if(player != nil){
                        v_secondPlayer.isHidden = false;
                        setImg(imageView: iv_secondPlayer, url: player!.headImg);
                        lb_secondPlayer.text = player!.name!;
                    }else{
                        v_secondPlayer.isHidden = true;
                    }
                }catch{}
            }else{
                v_secondPlayer.isHidden = true;
            }
        }else{
            if(event!.eventType==0||event!.eventType==14||event!.eventType==15||event!.eventType==11||event!.eventType==12){
                if(currentTimeLineEvent.remark != nil){
                    v_time.isHidden = false;
                    let tap = UITapGestureRecognizer(target:self, action:#selector(showDatePicker));
                    vlb_time.isUserInteractionEnabled = true;
                    vlb_time.addGestureRecognizer(tap);
                }else{
                    v_time.isHidden = true;
                }
            }else if(event!.eventType==16){
                if(currentTimeLineEvent.remark != nil){
                    v_time.isHidden = false;
                    lb_time.text = currentTimeLineEvent.remark;
                    let tap = UITapGestureRecognizer(target:self, action:#selector(showMinutePicker));
                    vlb_time.isUserInteractionEnabled = true;
                    vlb_time.addGestureRecognizer(tap);
                    vlb_time.tag = 202;
                }else{
                    v_time.isHidden = true;
                }
            }else if(event!.eventType==4||event!.eventType==18){
                if(currentTimeLineEvent.remark != nil){
                    v_time.isHidden = false;
                    lb_time.text = currentTimeLineEvent.remark;
                    let tap = UITapGestureRecognizer(target:self, action:#selector(showDropDown));
                    vlb_time.isUserInteractionEnabled = true;
                    vlb_time.addGestureRecognizer(tap);
                    vlb_time.tag = 101;
                }else{
                    v_time.isHidden = true;
                }
            }else if(event!.eventType==2){
                if(currentTimeLineEvent.remark != nil){
                    v_time.isHidden = false;
                    lb_time.text = currentTimeLineEvent.remark;
                    let tap = UITapGestureRecognizer(target:self, action:#selector(showDropDown));
                    vlb_time.isUserInteractionEnabled = true;
                    vlb_time.addGestureRecognizer(tap);
                    vlb_time.tag = 102;
                }else{
                    v_time.isHidden = true;
                }
            }else{
                v_time.isHidden = true;
            }
        }
    }
    
    func setImg(imageView:UIImageView,url: String?) {
        if(url == nil){
            imageView.image = UIImage.init(named: "defaultAvatar.jpg")
        }else{
            imageView.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "defaultAvatar.jpg"));
        }
    }
    @objc func showDatePicker(){
        datePicker = UIDatePicker();
        datePicker.locale = Locale(identifier: "zh_CN");
        datePicker.addTarget(self, action: #selector(dateChanged),
                             for: .valueChanged);
        let alertController:UIAlertController=UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.actionSheet);
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default){
            (alertAction)->Void in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            self.lb_time.text = formatter.string(from: self.datePicker.date);
        });
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel,handler:nil));
        let width = self.view.frame.width;
        datePicker.frame = CGRect(x: 10, y: 0, width: width, height: 250);
        alertController.view.addSubview(datePicker);
        self.present(alertController, animated: true, completion: nil);
    }
    @objc func dateChanged(datePicker : UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        self.lb_time.text = formatter.string(from: datePicker.date);
    }
    @objc func showMinutePicker(sender:UIGestureRecognizer){
        currentMinutePicker = sender.view!.tag;
        pickerView = UIPickerView.init();
        pickerView!.dataSource = self;
        pickerView!.delegate = self;
        if(currentMinutePicker == 201){
            currentRow = (currentTimeLineEvent.time != nil ? currentTimeLineEvent.time : 0);
        }else{
            currentRow = Int(currentTimeLineEvent.remark!);
        }
        if(currentRow != nil){
            pickerView!.selectRow(currentRow!,inComponent:0,animated:true);
        }else{
            pickerView!.selectRow(0,inComponent:0,animated:true);
        }
        let alertController:UIAlertController=UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.actionSheet);
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default){
            (alertAction)->Void in
            if(self.currentMinutePicker == 201){
                self.lb_minute.text = String(self.currentRow!);
            }else if(self.currentMinutePicker == 202){
                self.lb_time.text = String(self.currentRow!);
            }
        });
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel,handler:nil));
        let width = self.view.frame.width;
        pickerView!.frame = CGRect(x: 10, y: 0, width: width, height: 250);
        alertController.view.addSubview(pickerView!);
        self.present(alertController, animated: true, completion: nil);
    }
    @objc func showDropDown(sender:UIGestureRecognizer){
        let tag = sender.view!.tag;
        dropDown = DropDown();
        if(tag == 101){
            dropDown.dataSource = ["射门被拦截","射在门框","射偏"];
        }else{
            dropDown.dataSource = ["失败","成功"];
        }
        dropDown!.anchorView = vlb_time;
        dropDown!.dataSource = [];
        dropDown!.direction = .bottom;
        dropDown!.width = vlb_time.bounds.width;
        dropDown!.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lb_time.text = item;
        }
    }
}
