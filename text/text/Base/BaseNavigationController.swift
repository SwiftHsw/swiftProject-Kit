//
//  BaseNavigationController.swift
//  text
//
//  Created by 黄世文 on 2022/2/23.
//

import UIKit

//导航栏委托
protocol BaseNavigationControllerDelegate: NSObjectProtocol{
    
    ///返回按钮的颜色
    var backBtnType : NavBackBtnType { get }
    
    ///返回事件
    func popAction()
}


class BaseNavigationController: UINavigationController,UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    weak var baseDelegate:BaseNavigationControllerDelegate?
    
    
    override func loadView() {
        super.loadView()
        
        //适配iOS15 导航栏bug
        // 设置默认导航栏颜色
        if #available(iOS 15.0, *) {
            // UINavigationBarAppearance属性从iOS13开始
            let navBarAppearance = UINavigationBarAppearance()
            // 背景色
            navBarAppearance.backgroundColor = ColorF6FAFD
            // 去掉半透明效果
            navBarAppearance.backgroundEffect = nil
            // 去除导航栏阴影（如果不设置clear，导航栏底下会有一条阴影线）
            navBarAppearance.shadowColor = UIColor.clear
            // 字体颜色
            navBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: Color18282D
            ]
            self.navigationBar.standardAppearance = navBarAppearance
            self.navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            let navbar = UINavigationBar.appearance()
            navbar.barTintColor = ColorF6FAFD
            navbar.tintColor = Color18282D
            navbar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: Color18282D
            ]
            navbar.shadowImage = UIImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.delegate = self
        
        
    }
    
    
    /// 重写状态栏
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return self.topViewController?.preferredStatusBarStyle ?? .default
        }
    }
    
    /// 重写push
    ///
   
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
          //自定义返回按钮
        customsBackImageConfig(viewController)
        // 在push一个新的VC时，禁用滑动返回手势
        setPopGesture(false)
        super.pushViewController(viewController, animated: animated)
        
    }
  
    /// 重写setViewControllers
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        
        // 自定义返回按钮
        _ = viewControllers.map({ customsBackImageConfig($0) })
        // 在设置新的VC时，禁用滑动返回手势
        setPopGesture(false)
        
        super.setViewControllers(viewControllers, animated: true)
    }
    
    private func customsBackImageConfig(_ viewController: UIViewController){
        
        //判断是否第一个vc
        var isFirstVC = false
        if let index = self.viewControllers.firstIndex(of: viewController) {
            isFirstVC = index == 0
        } else {
            isFirstVC = self.viewControllers.count == 0
        }
        //是否隐藏tabar
        viewController.hidesBottomBarWhenPushed = !isFirstVC
        // 首页不显示返回按钮
        if viewController.navigationItem.leftBarButtonItem == nil && !isFirstVC {
            // 获取返回按钮类型
            var backBtnType: NavBackBtnType = .black
            if let vc = viewController as? BaseNavigationControllerDelegate {
                backBtnType = vc.backBtnType
            }
            // 设置返回按钮图片
            let backImage = UIImage(named: backBtnType.rawValue)?.withRenderingMode(.alwaysOriginal)
            
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            button.setImage(backImage, for: .normal)
            button.addTarget(self, action: #selector(popAction), for: .touchUpInside)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 0)
            let backBarButtonItem = UIBarButtonItem(customView: button)
            viewController.navigationItem.leftBarButtonItem = backBarButtonItem
        }
        
        
    }
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // 判断是否是根视图
        if navigationController.viewControllers.count == 1 {
            // 解决根试图左滑页面卡死
            setPopGesture(false)
        } else {
            // 完全展示出VC时，启用滑动返回手势
            setPopGesture(true)
        }
    }
    
    /// 设置滑动返回手势
    func setPopGesture(_ isEnabled: Bool) {
        self.interactivePopGestureRecognizer?.delegate = isEnabled ? self : nil
        self.interactivePopGestureRecognizer?.isEnabled = isEnabled
    }
    
    
    @objc func popAction(){
        if let topVc = self.topViewController as? BaseNavigationControllerDelegate{
            topVc.popAction()
        }
    }
   
    
    deinit{
        SLog("导航栏释放")
    }

}
