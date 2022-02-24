//
//  UIFont+Extend.swift
//  Gregarious
//
//  Created by Jason on 2021/3/25.
//

import UIKit

extension UIFont {
    
    // MARK: - 苹方体
    
    class func PingFangSCMedium(size: CGFloat) -> UIFont{
        return UIFont(name: FontName.PingFangSCMedium, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func PingFangSCRegular(size: CGFloat) -> UIFont{
       return UIFont(name: FontName.PingFangSCRegular, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func PingFangSCBold(size: CGFloat) -> UIFont{
       return UIFont(name: FontName.PingFangSCSemibold, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    // MARK: - 阿里巴巴普惠体
    
    class func PUHUIMedium(size: CGFloat) -> UIFont{
        return UIFont(name: FontName.AlibabaPuHuiTiMedium, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func PUHUIRegular(size: CGFloat) -> UIFont{
       return UIFont(name: FontName.AlibabaPuHuiTiRegular, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func PUHUIBold(size: CGFloat) -> UIFont{
       return UIFont(name: FontName.AlibabaPuHuiTiBold, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func PUHUILight(size: CGFloat) -> UIFont{
       return UIFont(name: FontName.AlibabaPuHuiTiLight, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func PUHUIHeavy(size: CGFloat) -> UIFont{
       return UIFont(name: FontName.AlibabaPuHuiTiHeavy, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
}

public struct FontName {
    
    public static let PingFangSCRegular = FontName.fontName(fontName: "PingFangSC-Regular", osVersion: 9.0)
    public static let PingFangSCSemibold = FontName.fontName(fontName: "PingFangSC-Semibold", osVersion: 9.0)
    public static let PingFangSCMedium = FontName.fontName(fontName: "PingFangSC-Medium", osVersion: 9.0)
    
    public static let AlibabaPuHuiTiRegular = FontName.fontName(fontName: "AlibabaPuHuiTi-Regular")
    public static let AlibabaPuHuiTiLight = FontName.fontName(fontName: "AlibabaPuHuiTi-Light")
    public static let AlibabaPuHuiTiMedium = FontName.fontName(fontName: "AlibabaPuHuiTi-Medium")
    public static let AlibabaPuHuiTiBold = FontName.fontName(fontName: "AlibabaPuHuiTi-Bold")
    public static let AlibabaPuHuiTiHeavy = FontName.fontName(fontName: "AlibabaPuHuiTi-Heavy")
}

extension FontName {
    
    public static func fontNames() -> [String] {
        return [
            PingFangSCRegular,
            PingFangSCSemibold,
            PingFangSCMedium,
            AlibabaPuHuiTiRegular,
            AlibabaPuHuiTiBold,
            AlibabaPuHuiTiMedium,
            AlibabaPuHuiTiLight,
            AlibabaPuHuiTiHeavy
        ]
    }
    
}

extension FontName {
    
    fileprivate static func fontName(fontName name: String, osVersion version: Float? = nil) -> String {
        if let _ = version {}
        return name
    }
    
}
