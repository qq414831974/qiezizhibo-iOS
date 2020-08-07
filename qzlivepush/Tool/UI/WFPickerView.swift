//
//  WFPickerView.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/7/1.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit

class WFPickerView: UIView {
    
    //typedef
    typealias SureBtnBlock=(_ dataArr:[String])->Void
    //声明闭包
    var sureBtnBlock:SureBtnBlock?
    var array:[Any] = []
    var titleArray:[String] = []
    
    static var shared:WFPickerView? = WFPickerView(){
        didSet{
            if shared == nil{
                shared = WFPickerView()
            }
        }
    }
    
    func show(dataArray:Array<Any>,width: CGFloat, height: CGFloat)  {
        
        self.array = dataArray
        
        self.titleArray.removeAll()
        for _ in 0...(self.array.count){
            self.titleArray.append("")
        }
        if dataArray.count > 0 {
            let arr:[Any] = dataArray[0] as! Array
            let t:String = arr[0] as! String
            self.titleArray[0] = t;
        }
        let pickView = UIPickerView.init()
        pickView.delegate = self
        pickView.dataSource = self
        
        let alertController:UIAlertController=UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.actionSheet);
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default){
            (alertAction)->Void in
            self.sureBtnBlock!(self.titleArray)
        });
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel,handler:nil));
        alertController.view.addSubview(pickView);
        alertController.show();
    }
}
extension WFPickerView:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.array.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let arr:[Any] = self.array[component] as! Array
        return arr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let arr:[Any] = self.array[component] as! Array
        let t:String = arr[row] as! String
        return t
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let arr:[Any] = self.array[component] as! Array
        let t:String = arr[row] as! String
        self.titleArray[component] = t
    }
    
}
