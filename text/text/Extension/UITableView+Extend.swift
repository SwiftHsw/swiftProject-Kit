//
//  UITableView+Extend.swift
//  1xpocket
//
//  Created by Apple on 2021/5/8.
//

import UIKit

extension UITableView {
    
    func addBgView(color: UIColor) {
        let bgview = UIView(frame: CGRect(x: 0, y: -ScreenHeight, width: ScreenWidth, height: ScreenHeight))
        bgview.backgroundColor = color
        addSubview(bgview)
        sendSubviewToBack(bgview)
    }
    
}
