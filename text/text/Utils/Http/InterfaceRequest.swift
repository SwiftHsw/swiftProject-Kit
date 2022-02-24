//
//  InterfaceRequest.swift
//  text
//
//  Created by 黄世文 on 2022/2/24.
//

import Foundation
import PromiseKit


class InterfaceRequest{
    
    
    
    //模拟登录注册接口
    
    
    static public func userLogin(mobile:String,password:String) -> Promise<RequestResultModel<UserLoginModel>>{
        
        let parameters = [
            "mobile":mobile,
            "password":password
        ]
        return HttpRequestUntil.share.request(urlType: .main, url: "/user/login", parameters: parameters, method: .post)
         
    }
    
    
    //获取用户资料
    
    static public func getUserInfo() ->Promise<RequestResultModel<UserModel>>{
        return HttpRequestUntil.share.request(urlType: .main, url: "/user/getInfo")
    }
    
}



class UserLoginModel:BaseModel{
      
    /// 临时token
//    var refreshTokenVo: TempTokenModel?
    /// token
    var token = ""
    /// 用户id
    var userId = ""
    /// 用户昵称
    var nickname = ""
    /// 助记词
    var s = ""
    /// 判断节点
    var isAgency = ""
    /// 谷歌密钥
    var isGoogleVerify = false
}
  
 
