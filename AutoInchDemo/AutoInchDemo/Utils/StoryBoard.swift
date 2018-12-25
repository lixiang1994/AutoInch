//
//  StoryBoard.swift
//  LiveTrivia
//
//  Created by 李响 on 2018/1/16.
//  Copyright © 2018年 LiveTrivia. All rights reserved.
//

import Foundation
import UIKit

enum StoryBoard: String {
    case main               = "Main"
    case tiktok             = "TikTok"
    
    var storyboard: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: nil)
    }
    
    func instance<T>() -> T {
        return storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
}

extension UIViewController {
    
    @IBAction func backAction() {
        view.endEditing(false)
        if
            let navigation = navigationController,
            navigation.viewControllers.first != self {
            navigation.popViewController(animated: true)
            
        } else {
            let presenting = presentingViewController ?? self
            presenting.dismiss(animated: true)
        }
    }
}
