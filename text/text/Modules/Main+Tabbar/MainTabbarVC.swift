//
//  MainTabbarVC.swift
//  text
//
//  Created by 黄世文 on 2022/2/23.
//

import UIKit

class MainTabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupTabbar()
        
        setupViewControllers()
    }
    
    
    
    //适配系统版本的tabbar
    private func setupTabbar(){
        if #available(iOS 13.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.shadowImage = UIImage(color: UIColor("#FFFFFF"), size: CGSize(width: ScreenWidth, height: 1))
            tabBarAppearance.backgroundImage = nil
            tabBarAppearance.backgroundColor = UIColor.white
            tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor : ColorB5C8D8]
            tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor : Color3583E1]
            tabBar.standardAppearance = tabBarAppearance
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = tabBarAppearance
            }
           
        } else {
            //去掉黑色线条
            tabBar.shadowImage = UIImage()
            tabBar.backgroundImage = UIImage()
            tabBar.backgroundColor = UIColor.white
            tabBar.barTintColor = UIColor.white
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor : ColorB5C8D8], for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor : Color3583E1], for: .selected)
        }
    }
   
    private func  setupViewControllers(){
        
        let homeVc = ViewController.fromStoryboard(name: "Main")
        homeVc.title = "首页"
       setupChildController(childVC: homeVc, norImageName: "tabbar_wallet_normal", selectedImageName: "tabbar_wallet_selected", title: "首页")
         
        let homeVc1 = GoolegeVC.fromStoryboard(name: "Main")
       setupChildController(childVC: homeVc1, norImageName: "tabbar_btm_normal", selectedImageName: "tabbar_btm_selected", title: "谷歌")
         
        let homeVc2 = MeUserVc.fromStoryboard(name: "Main")
       setupChildController(childVC: homeVc2, norImageName: "tabbar_my_normal", selectedImageName: "tabbar_my_selected", title: "我的")
        
         
    }
    // addChild
    private func setupChildController(childVC: UIViewController, norImageName: String, selectedImageName: String, title: String) {
        childVC.tabBarItem.title = title
        childVC.tabBarItem.image = UIImage(named: norImageName)?.withRenderingMode(.alwaysOriginal)
        childVC.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(.alwaysOriginal)
        let nav = BaseNavigationController(rootViewController: childVC)
        addChild(nav)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
