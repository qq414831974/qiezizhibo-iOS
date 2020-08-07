//
//  HomePageController.swift
//  qzlivepush
//
//  Created by 吴帆 on 2019/5/31.
//  Copyright © 2019 qiezizhibo. All rights reserved.
//

import UIKit
class HomePageController: UINavigationController{
    override func viewDidLoad() {
        super.viewDidLoad();
        self.openEventServiceWithBolck(action: self.authorize);
    }
}
