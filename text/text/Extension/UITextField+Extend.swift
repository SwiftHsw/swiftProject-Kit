//
//  UITextField+Extend.swift
//  Gregarious
//
//  Created by Apple on 2021/3/24.
//

import UIKit

extension UITextField {
    
    private struct PlaceholderColorKey {
        static var identifier:String = "PlaceholderCplorKey"
    }
    
    var placeholderColor: UIColor {
        get {
            guard let color = objc_getAssociatedObject(self, &PlaceholderColorKey.identifier) as? UIColor else {
                return UIColor.clear
            }
            return color
        }
        set(newColor) {
            objc_setAssociatedObject(self, &PlaceholderColorKey.identifier, newColor, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            let attrString = NSMutableAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor:newColor,NSAttributedString.Key.font:self.font ?? UIFont.systemFont(ofSize: 15)])
            self.attributedPlaceholder = attrString
        }
    }
    
    @IBInspectable
    var placeholderColorKey: UIColor {
        set { placeholderColor = newValue }
        get { return placeholderColor }
    }
}
