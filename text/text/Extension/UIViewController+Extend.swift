//
//  UIViewController+Extend.swift
//  Gregarious
//
//  Created by Apple on 2021/3/25.
//

import UIKit

extension UIViewController {
    
    /// Storyboard视图控制器快捷初始化
    class func fromStoryboard(name: String) -> Self {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: self.className)
        return vc as! Self
    }
    
    /// xib视图控制器快捷初始化
    class func fromXib() -> Self {
        return Bundle.main.loadNibNamed(self.className, owner: nil, options: nil)?.first as! Self
    }
    
    /// 屏幕上最前端的控制器
    static func topViewController(_ viewController: UIViewController? = nil) -> UIViewController? {
        let viewController = viewController ?? UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = viewController as? UINavigationController, !navigationController.viewControllers.isEmpty {
            return self.topViewController(navigationController.viewControllers.last)
            
        }
        else if let tabBarController = viewController as? UITabBarController, let selectedController = tabBarController.selectedViewController {
            return self.topViewController(selectedController)
            
        }
        else if let presentedController = viewController?.presentedViewController {
            return self.topViewController(presentedController)
        }
        
        return viewController
    }
    
    /// 跳转
    func pushViewController(vc: UIViewController, animate: Bool = true, isRemoveSelf: Bool = false) {
        // 是否需要移除自己
        if isRemoveSelf {
            guard var vcs = self.navigationController?.viewControllers else { return }
            if let index = vcs.lastIndex(of: self) {
                vcs.remove(at: index)
            }
            // 添加新视图
            vcs.append(vc)
            self.navigationController?.setViewControllers(vcs, animated: true)
            return
        }
        navigationController?.pushViewController(vc, animated: animate)
    }
    
    /// 返回
    func back(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    /// 返回到下标为index的控制器
    func popToViewController(index: Int, animated: Bool = true) {
        let viewControllers = navigationController?.viewControllers
        if let vcs = viewControllers {
            if vcs.count > index {
                let vc = vcs[index]
                navigationController?.popToViewController(vc, animated: animated)
            }
        }
    }
    
    /// 返回到根控制器
    func backToRoot(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
}
