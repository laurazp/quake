//
//  TabBarController.swift
//  Quake
//
//  Created by Laura Zafra Prat on 13/6/22.
//

import UIKit

class TabBarController: UITabBarController {
    @IBInspectable var initialIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = initialIndex
    }
}
