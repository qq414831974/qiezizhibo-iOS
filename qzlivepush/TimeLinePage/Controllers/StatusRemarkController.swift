//
//  StatusRemarkController.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/25.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit

class StatusRemarkController: UIViewController{
    @IBOutlet weak var iv_EventImg: UIImageView!
    
    @IBOutlet weak var lb_EventName: UILabel!
    
    @IBOutlet weak var lb_RemarkName: UILabel!
    
    @IBOutlet weak var tf_Remark: TextFieldWithLeftView!
    
    @IBOutlet weak var v_Remark: UIView!
    
    @IBOutlet weak var btn_confirm: UIButton!
    
    @IBOutlet weak var v_minute: UIView!
    
    @IBOutlet weak var tf_minute: UITextField!
    
    var chooseStatus:ChooseStatusController!;
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        chooseStatus!.initRemarkView();
    }
    
    @objc func showPicker(sender:UITapGestureRecognizer){
        chooseStatus.showPicker(sender: sender);
    }
}
