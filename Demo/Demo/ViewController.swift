//
//  ViewController.swift
//  Demo
//
//  Created by 李响 on 2018/11/3.
//  Copyright © 2018 swift. All rights reserved.
//

import UIKit
import AutoInch

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(
            "this is " +
                "default".screen
                .set("宽度 320", for: .width(._320))
                .set("宽度 375", for: .width(._375))
                .set("高度 844", for: .height(._844))
                .set("高度 812", for: .height(._812))
                .set("4.7 英寸", for: .inch(._4_7))
                .set("5.8 英寸", for: .inch(._5_8))
                .set("6.5 英寸", for: .inch(._6_5))
                .set("屏幕级别 紧凑屏", for: .level(.compact))
                .set("屏幕级别 常规屏", for: .level(.regular))
                .set("屏幕级别 全面屏", for: .level(.full))
                .value
        )
        0.screen.set(1, for: .inch(._3_5)).set(2, for: .inch(._4_0)).value
        print(0.screen.set(1, for: .level(.full)).set(2, for: .inch(._6_1)).value)
        
        print("当前屏幕级别: \(Screen.Level.current)")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}

