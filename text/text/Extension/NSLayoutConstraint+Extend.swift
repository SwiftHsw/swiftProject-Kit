//
//  NSLayoutConstraint+Extend.swift
//  Gregarious
//
//  Created by Admin on 2021/3/24.
//

import Foundation
import UIKit

private var adaptSafeAreaBottomKey: Void?
private var adaptSafeAreaTopKey: Void?

extension NSLayoutConstraint {
    
    
    @IBInspectable
    var inch35Constant: CGFloat {
        get { return constant }
        set {
            if ScreenWidth == 320 && ScreenHeight == 480 {
                self.constant = newValue
            }
        }
    }
    
    @IBInspectable
    var inch40Constant: CGFloat {
        get { return constant }
        set {
            if ScreenWidth == 320 && ScreenHeight == 568 {
                self.constant = newValue
            }
        }
    }
    
    @IBInspectable
    var inch47Constant: CGFloat {
        get { return constant }
        set {
            if ScreenWidth == 375 && ScreenHeight == 667 {
                self.constant = newValue
            }
        }
    }
    
    @IBInspectable
    var inch55Constant: CGFloat {
        get { return constant }
        set {
            if ScreenWidth == 414 && ScreenHeight == 736 {
                self.constant = newValue
            }
        }
    }
    
    @IBInspectable
    var inch58Constant: CGFloat {
        get { return constant }
        set {
            if ScreenWidth == 375 && ScreenHeight == 812 {
                self.constant = newValue
            }
        }
    }
    
    @IBInspectable
    var inch65Constant: CGFloat {
        get { return constant }
        set {
            if ScreenWidth == 414 && ScreenHeight == 896 {
                self.constant = newValue
            }
        }
    }
    
    @IBInspectable
    var adaptSafeAreaBottom: Bool {
        get { return objc_getAssociatedObject(self, &adaptSafeAreaBottomKey) as? Bool ?? false }
        set {
            objc_setAssociatedObject(self, &adaptSafeAreaBottomKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue == true {
                if #available(iOS 11.0, *) {
                    self.constant += UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
                }
            }
        }
    }
    
    @IBInspectable
    var adaptSafeAreaTop: Bool {
        get { return objc_getAssociatedObject(self, &adaptSafeAreaTopKey) as? Bool ?? false }
        set {
            objc_setAssociatedObject(self, &adaptSafeAreaTopKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue == true {
                if #available(iOS 11.0, *) {
                    self.constant += UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
                }
            }
        }
    }
    
}
