//
//  ColorPicker.swift
//  qzlivepush
//
//  Created by 吴帆 on 2021/1/7.
//  Copyright © 2021 qiezizhibo. All rights reserved.
//

import UIKit

class ColorPicker: UIView, UICollectionViewDelegate, UICollectionViewDataSource{
    @IBOutlet weak var collectionView: UICollectionView!
    public var delegate: ColorPickerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib();
        collectionView!.register(ColorPickerCell.self, forCellWithReuseIdentifier:"colorPickerCell")

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constant.COLOR_LIST.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ColorPickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorPickerCell",for: indexPath) as! ColorPickerCell;
        let index:Int = indexPath.row;
        let color:UIColor = UIColor(hexString: Constant.COLOR_LIST[index]);
        cell.backgroundColor = color;
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        
        cell.tag = index;
        
        let tap = UITapGestureRecognizer(target:self, action:#selector(showDialog));
        cell.isUserInteractionEnabled = true;
        cell.addGestureRecognizer(tap);
        
        return cell;
    }
    @objc func showDialog(sender: UITapGestureRecognizer){
        let colorIndex = sender.view!.tag;
        let color:UIColor = UIColor(hexString: Constant.COLOR_LIST[colorIndex]);
        if(self.delegate != nil){
            self.delegate!.onColorChange(color: color);
        }
    }
}
