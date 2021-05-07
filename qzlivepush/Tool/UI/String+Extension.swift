//
//  String+Extension.swift
//  qzlivepush
//
//  Created by 吴帆 on 2021/3/26.
//  Copyright © 2021 qiezizhibo. All rights reserved.
//

extension String{
/// 富文本设置 字体大小 行间距 字间距
    func attributedString(font: UIFont, textColor: UIColor, lineSpaceing: CGFloat, wordSpaceing: CGFloat, expansion: CGFloat) -> NSAttributedString {
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpaceing
        style.alignment = NSTextAlignment.center
        let attributes = [
                NSAttributedString.Key.expansion        : expansion,
                NSAttributedString.Key.font             : font,
                NSAttributedString.Key.foregroundColor  : textColor,
                NSAttributedString.Key.paragraphStyle   : style,
                NSAttributedString.Key.kern             : wordSpaceing]
            
            as [NSAttributedString.Key : Any]
        let attrStr = NSMutableAttributedString.init(string: self, attributes: attributes)
        
        return attrStr
    }
}
