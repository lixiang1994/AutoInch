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
        
        print("this is " + "default".screen
            .width(equalTo: 375, is: "宽度 等于 375")
            .width(lessThan: 414, is: "宽度 小于 414")
            .width(greaterThan: 414, is: "宽度 大于 414")
            .height(equalTo: 700, is: "高度 等于 375")
            .height(lessThan: 844, is: "高度 小于 844")
            .height(greaterThan: 844, is: "高度 大于 844")
            .inch(._4_7, is: "4.7 英寸")
            .inch(._5_8, is: "5.8 英寸")
            .inch(._6_5, is: "6.5 英寸")
            .level(.compact, is: "屏幕级别 紧凑屏 (4:3)")
            .level(.regular, is: "屏幕级别 常规屏 (16:9)")
            .level(.full, is: "屏幕级别 全面屏 (19.5:9)")
            .value
        )
        
        
        // 默认值 0 在3.5英寸的屏幕时返回1, 在4.0英寸的屏幕时返回2
        print(0.screen.inch(._3_5, is: 1).inch(._4_0, is: 2).value)
        // 默认值 0 在全面屏时返回1, 在6.1英寸的屏幕时返回2
        print(0.screen.level(.full, is: 1).inch(._6_1, is: 2).value)
        // 默认值 100 在宽度为375级别的屏幕时 正常返回120, 如果为缩放模式则返回110
        print(100.screen.width(equalTo: 375, is: 120, zoomed: 110).value)
        
        print("当前屏幕级别: \(Screen.Level.current)")
        print("是否为全面屏: \(Screen.isFull)")
        print("是否为缩放模式: \(Screen.isZoomedMode)")
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

