//
//  Reportsvc.swift
//  tynorios
//
//  Created by Acxiom Consulting on 09/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation
import UIKit

class Reportsvc: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if  constant.onlyhidden
        {
            self.viewControllers![1].removeFromParentViewController()
            self.viewControllers![1].removeFromParentViewController()
            self.viewControllers![1].removeFromParentViewController()
        }
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "ArialHebrew", size: 12)!], for: .normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "ArialHebrew", size: 12)!], for: .selected)
    }
}
