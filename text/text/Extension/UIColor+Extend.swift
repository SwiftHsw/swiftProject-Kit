//
//  UIColorExtension.swift
//  DeWallet
//
//  Created by apple on 2020/12/14.
//

import UIKit

extension UIColor {
    
    convenience init(_ hex: String, alpha: CGFloat = 1) {
        
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
         
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
         
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
         
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
         
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
         
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1) {
        
        let red   = r / 255.0
        let green = g / 255.0
        let blue  = b / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    // RGB16(0x5DAFFC)
    public static func RGB16(_ code: Int, alpha: CGFloat = 1) -> UIColor {
        let red = CGFloat(((code & 0xFF0000) >> 16)) / 255
        let green = CGFloat(((code & 0xFF00) >> 8)) / 255
        let blue = CGFloat((code & 0xFF)) / 255

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// 返回一个随机颜色
    static func randomColor(alpha: CGFloat = 1) -> UIColor {
        let redValue = arc4random() % 255
        let greenValue = arc4random() % 255
        let blueValue = arc4random() % 255
        return UIColor(red: CGFloat(redValue) / 255 , green: CGFloat(greenValue) / 255, blue: CGFloat(blueValue) / 255, alpha: alpha)
    }
    
    
}
