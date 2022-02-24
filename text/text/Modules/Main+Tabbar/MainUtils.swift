//
//  MainUtils.swift
//  text
//
//  Created by 黄世文 on 2022/2/23.
//

import UIKit
import Foundation


class MainUtils: NSObject {
 
    //单例
    static let shareUtil = MainUtils()
    
    //公开方法设置根目录
    public func loadMainTabbar(selectIndex:Int = 0){
        
//        let isUser = true
//        if isUser{
            let mainTC = MainTabbarVC()
            mainTC.delegate = self
            mainTC.selectedIndex = selectIndex
            AppWindow.rootViewController = mainTC
//        }else{
//            AppWindow.rootViewController = BaseNavigationController(rootViewController: ViewController.init())
//        }
       
    }
    
}


extension MainUtils:UITabBarControllerDelegate{
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
     
}
