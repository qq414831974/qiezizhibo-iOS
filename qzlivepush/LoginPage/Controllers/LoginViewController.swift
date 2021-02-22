//
//  LoginViewController.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/5/28.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit
import RxSwift
import SPPermission

class LoginViewController: UIViewController,UITextFieldDelegate {
    var viewModel:LoginViewModel?;
    let disposeBag = DisposeBag();
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{ return .portrait}
    @IBOutlet weak var centerAnchor: NSLayoutConstraint!
    @IBOutlet weak var btn_login: UIButton!;
    @IBOutlet weak var tf_username: UITextField!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var cb_rememberme: UICheckBox!
    @IBAction func btn_loginClick(_ sender: Any) {
        tf_username.resignFirstResponder();
        tf_password.resignFirstResponder();
        setBtnLoginState("loading");
        self.login();
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField is TextFieldWithLeftView){
            (textField as! TextFieldWithLeftView).setHighlighted(highlighted: true);
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField is TextFieldWithLeftView){
            (textField as! TextFieldWithLeftView).setHighlighted(highlighted: false);
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.tag == 11){
            tf_password.becomeFirstResponder();
        }else{
            self.login();
        }
        return true;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginViewModel.init(self);
        
        btn_login.layer.cornerRadius = 20;
        
        tf_username.borderStyle = UITextField.BorderStyle.none;
        tf_username.layer.borderColor = UIColor.lightGray.cgColor;
        tf_username.layer.borderWidth = 0.3;
        tf_username.layer.cornerRadius = 20;
        tf_username.layer.masksToBounds = true;
        
        tf_password.borderStyle = UITextField.BorderStyle.none;
        tf_password.layer.borderColor = UIColor.lightGray.cgColor;
        tf_password.layer.borderWidth = 0.3;
        tf_password.layer.cornerRadius = 20;
        tf_password.layer.masksToBounds = true;
        
        let tap = UITapGestureRecognizer(target:self, action:#selector(viewTap));
        
        self.view.isUserInteractionEnabled = true;
        self.view.addGestureRecognizer(tap);
        
        if((viewModel?.isRememberMe())!){
            cb_rememberme.isSelected = true;
            let userInfo:UserModel? = viewModel?.getLoginInfo();
            if(userInfo != nil){
                tf_username.text = userInfo!.userName;
                tf_password.text = userInfo!.passWord;
            }
        }
        self.openEventServiceWithBolck(action: self.authorize);
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillChange),name: UIResponder.keyboardWillChangeFrameNotification, object: nil);
    }
    /**
     *键盘改变
     */
    @objc func keyboardWillChange(notification: NSNotification) {
        if let userInfo = notification.userInfo,
            let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            
            let frame = value.cgRectValue
            var intersection = frame.intersection(self.view.frame)
            
            //当键盘消失，让view回归原始位置
            if intersection.height == 0.0 {
                intersection = CGRect(x: intersection.origin.x, y: intersection.origin.y, width: intersection.width, height: 200)
            }
            UIView.animate(withDuration: duration, delay: 0.0,
                                       options: UIView.AnimationOptions(rawValue: curve), animations: {
                                        //改变下约束
                                        self.centerAnchor.constant = intersection.height
                                        self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc func viewTap(sender:UITapGestureRecognizer){
        if(sender.view!.tag != 11 && sender.view!.tag != 12){
            tf_username.resignFirstResponder();
            tf_password.resignFirstResponder();
        }
    }
    func setBtnLoginState(_ state:String){
        switch state {
        case "loading":
            btn_login.setTitle("登陆中", for: UIControl.State.disabled);
            btn_login.isEnabled = false;
            return;
        default:
            btn_login.setTitle("登陆", for: UIControl.State.normal);
            btn_login.isEnabled = true;
            return;
        }
    }
    func login(){
        viewModel!.login(username: tf_username.text, password: tf_password.text, isRemember: cb_rememberme.isSelected, disposeBag: disposeBag);
    }
    func toHomePage(){
        let isAllowedCamera = SPPermission.isAllowed(.camera);
        let isAllowedMicrophone = SPPermission.isAllowed(.microphone);
        let isAllowedPhoto = SPPermission.isAllowed(.photoLibrary);
        if(!isAllowedCamera || !isAllowedMicrophone || !isAllowedPhoto){
            SPPermission.Dialog.request(with: [.camera, .microphone, .photoLibrary], on: self, delegate: self, dataSource: self);
            return;
        }
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "homePage") as! HomePageController
        vc.modalPresentationStyle = .fullScreen
        //跳转
        self.present(vc, animated: true,completion: nil);
    }
}
extension LoginViewController:SPPermissionDialogDataSource,SPPermissionDialogDelegate{
    var dialogTitle: String { return "茄子直播需要获得以下授权" }
    var dialogSubtitle: String { return "获取权限" }
    var dialogComment: String { return "" }
    var allowTitle: String { return "允许" }
    var allowedTitle: String { return "已允许" }
    var bottomComment: String { return "" }
    var cancelTitle: String { return "取消" }
    var settingsTitle: String { return "前往设置" }
    var showCloseButton: Bool {return true}
    var dragEnabled: Bool {return false}
    var dragToDismiss: Bool {return false}
    func name(for permission: SPPermissionType) -> String? {
        switch permission {
        case .camera:
            return "相机"
        case .photoLibrary:
            return "相册"
        case .microphone:
            return "麦克风"
        default:
            return "无"
        }
    }
    func description(for permission: SPPermissionType) -> String? {
        switch permission {
        case .camera:
            return "允许使用相机"
        case .photoLibrary:
            return "允许访问相册"
        case .microphone:
            return "允许使用麦克风"
        default:
            return "无"
        }
    }
    func deniedTitle(for permission: SPPermissionType) -> String? {
        return "授权失败"
    }
    func deniedSubtitle(for permission: SPPermissionType) -> String? {
        switch permission {
        case .camera:
            return "请前往设置选择允许使用相机"
        case .photoLibrary:
            return "请前往设置选择允许访问相册"
        case .microphone:
            return "请前往设置选择允许使用麦克风"
        default:
            return "无"
        }
    }
    func didHide() {
        self.dismiss(animated: true, completion: nil);
    }
}
