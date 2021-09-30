//
//  UIColor+.swift
//  qzlivepush
//
//  Created by 吴帆 on 2021/1/7.
//  Copyright © 2021 qiezizhibo. All rights reserved.
//

import UIKit
 
extension UIColor {
     
    // Hex String -> UIColor
    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
         
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
         
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
         
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
         
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
         
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
     
    // UIColor -> Hex String
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
         
        let multiplier = CGFloat(255.999999)
         
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
         
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
    func r() -> CGFloat {
        return self.cgColor.components![0];
    }
        
    func g() -> CGFloat {
        let count = self.cgColor.numberOfComponents;
        if (count == 2) {
            return self.cgColor.components![0];
        } else {
            return self.cgColor.components![1];
        }
    }
        
    func b() -> CGFloat {
        let count = self.cgColor.numberOfComponents;
        if (count == 2) {
            return self.cgColor.components![0];
        } else {
            return self.cgColor.components![2];
        }
    }
        
    func a() -> CGFloat {
        let count = self.cgColor.numberOfComponents;
        return self.cgColor.components![count - 1];
    }
    func y() -> CGFloat{
        return 0.299 * r() + 0.587 * g() + 0.114 * b();
    }
}
