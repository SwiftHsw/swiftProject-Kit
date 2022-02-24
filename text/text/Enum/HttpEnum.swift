//
//  HttpEnum.swift
//  text
//
//  Created by 黄世文 on 2022/2/24.
//

import Foundation

enum HttpEnvironment{
    case production
    case developer   //开发者
    case local //本地
}

enum HttpURLType{
    case main
    case assets
    
    
   //各个模块对应的地址
    var url : String{
        switch self {
        case .main:
            switch HttpRequestUntil.share.environment {
            case .production: return "http://chain.1xpocket.net"
            case .developer: return "http://1.14.239.189:7001"
            case .local: return "http://192.168.3.29:9001"
            }
        case .assets:
            switch HttpRequestUntil.share.environment {
            case .production: return "http://process.1xpocket.net"
            case .developer: return "http://1.14.239.189:7002"
            case .local: return "http://192.168.3.29:9002"
            }
        }
    }
   
    
}
/// 接口错误码
enum RequestErrorType: String {
    // 网络出错
    case network = "300"
    // 解析出错
    case parsing = "301"
    // socket超时
    case timeout = "302"
}
