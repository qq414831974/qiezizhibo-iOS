//
//  UIImage+SVG+Extension.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/6/17.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit
import SVGKit
extension UIImage{
    static func svg(named: String, size: CGSize) -> UIImage{
        let svgImg:SVGKImage = SVGKImage.init(named: named,in: nil)
        svgImg.size = size;
        return svgImg.uiImage;
    }
}
