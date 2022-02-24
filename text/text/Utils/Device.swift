//
//  Device.swift
//  Gregarious
//
//  Created by Apple on 2021/3/25.
//

import UIKit

public let AppWindow = UIApplication.shared.windows.first!
public let ScreenWidth = UIScreen.main.bounds.size.width
public let ScreenHeight = UIScreen.main.bounds.size.height

public let StatusBarHeight: CGFloat = isIphoneX ? 44.0 : 20.0
public let NavigationBarHeight: CGFloat = 44.0
public let StatusBarAndNavigationBarHeight = NavigationBarHeight + StatusBarHeight
public let TabBarSafeBottomMargin: CGFloat = isIphoneX ? 34.0 : 0.0
public let TabBarHeight: CGFloat = 49
public let TabBarAndSafeBottomMargin = TabBarHeight + TabBarSafeBottomMargin

public var isIphoneX: Bool {
    if #available(iOS 11.0, *) {
        return AppWindow.safeAreaInsets.bottom > 0
    }
    return false
}

public var isIphone6: Bool {
    return ScreenWidth == 375.0 && ScreenHeight == 667.0
}

public var isIphone6Plus: Bool {
    return ScreenWidth == 414.0 && ScreenHeight == 736.0
}

/// app当前版本
public let AppCurrentVersion: String = {
    let appVersion = Bundle.main.infoDictionary? ["CFBundleShortVersionString"] as? String ?? "1.0.0"
    return appVersion
}()

/// app名称
public let AppCurrentName: String = {
    let appName = Bundle.main.infoDictionary? ["CFBundleDisplayName"] as? String ?? ""
    return appName
}()



