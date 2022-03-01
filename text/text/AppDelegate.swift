//
//  AppDelegate.swift
//  text
//
//  Created by 黄世文 on 2022/2/22.
//

import UIKit
import KakaJSON

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    typealias BlockWithNone = () -> ()
   var window: UIWindow?
 
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if #available(iOS 13.0, *){
            window?.overrideUserInterfaceStyle = .light
        }
     
        self.setupLocalDefaultConfig()
  
        
        //设置tabbar 为跟试图
        MainUtils.shareUtil.loadMainTabbar()
        
        
        let jsonDict:[String:Any] = [
            "nickname":"黄世文",
            "sex":"男",
            "age":"27",
            "user_Model":[
                "userName":"黄世文",
                "userSex":"男",
                "userAge":"27",
            ]
        ]
        
        
        
        let ArrayDict : [[String:Any]] = [
            ["name":"A","price":"100"],
            ["name":"B","price":"200"],
            ["name":"C","price":"300"],
        ]
        
        let model = jsonDict.kj.model(CostomModel.self)
        let arrays = ArrayDict.kj.modelArray(ArrayModel.self)
        
        
      
        
        print("\(model.nickname)")
        
        //全局配置驼峰写法
        ConvertibleConfig.setModelKey { property in
            property.name.kj.underlineCased()
        }
        
        
        for model:ArrayModel in arrays{
            print(model.price)
            
            //将model转为字典
            let dict = model.kj.JSONObject()
            
            let dictString = model.kj.JSONString()
            
            print("json字典\(dict)+json字符串\(dictString)")
            
            
        }
        
        
        
        let string : String? = "Hellow"
        let greenting = "World!"
        if let name = string {
            let allAtring = name + greenting
            print(allAtring)
        }
        
        
        
        
        print("==============我是分割线-开始练习WCDB.Swift===============")
        
        
        WCDBUtil.share.connectDataBase()
        
        
        return true
    }
  
    private func setupLocalDefaultConfig(){
        //设置一些键盘 属性的配置
        
    }

}

