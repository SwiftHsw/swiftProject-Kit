//
//  UIImageView+Extend.swift
//  Gregarious
//
//  Created by Apple on 2021/3/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    /// 通用图片
    func loadImage(urlStr: String, placeholder: String = "placeholder") {
        let url = URL(string: "OSSURL" + urlStr)
        self.kf.setImage(with: url, placeholder: UIImage(named: placeholder))
    }
    
}
