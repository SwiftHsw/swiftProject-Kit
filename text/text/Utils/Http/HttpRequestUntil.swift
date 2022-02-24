//
//  HttpRequestUntil.swift
//  text
//
//  Created by 黄世文 on 2022/2/24.
//

import Foundation
import sqlcipher
import Alamofire
import PromiseKit
import KakaJSON

class HttpRequestUntil{
    
    //初始化单例
    static let share = HttpRequestUntil()
    
    
    ///判断是否有网络
    public var hasNetWorking : Bool = false
    
    ///环境
    public var environment : HttpEnvironment = .developer
    
    /// App版本
    public var platformVersion : String{
        get {
            /**
             2位 应用ID -> 01
             2位 平台 20=IOS普通包 10=ANDROID普通包 -> 10
             4位 版本
             4位 渠道号 -> 0001
             */
            var version = AppCurrentVersion
            version = version.replacingOccurrences(of: ".", with: "")
            if version.count <= 3 {
                version = "0" + version
            }
            return "0120\(version)0001"
        }
    }
    
    
    ///请求头head
    private lazy var headers : HTTPHeaders = {
        return [
            "h": platformVersion,
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }()
    
    
    ///网络监听管理器
    private var networkReachabilityManager : NetworkReachabilityManager?
    
    ///请求会话manager
    private var AFSession : Session!
    
    
    ///初始化 网络请求
    private init(){
        
        
        let manager = ServerTrustManager.init(allHostsMustBeEvaluated: true, evaluators: [:])
        let configuration : URLSessionConfiguration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 15
        AFSession  = Session(configuration: configuration, serverTrustManager: manager)
        // 监听网络
        networkReachabilityManager = NetworkReachabilityManager()
        networkReachabilityManager?.startListening { status in
            debugPrint("网络状态: ", status)
            switch status {
            case .notReachable:
                self.hasNetWorking = false
            case .reachable(_), .unknown:
                self.hasNetWorking = true
            }
        }
        
        
    }
    
    
    //MARK -- public
    ///更新head头部信息
    public func updataHeaders(name:String, value:String){
        
        headers.update(name:name,value: value)
        
    }
    
    ///删除头部信息
    public func deleteHeaders(name:String){
        headers.remove(name: name)
        
    }
    
    ///http请求 默认POST，参数格式【key：value】
    ///urlType
    ///url
    ///parameters
    ///method
    ///返回一个处理好的数据 Promise<RequestResultModel<T>>
    public func request<T:Convertible>(urlType:HttpURLType,url:String,parameters:[String: Any]? = nil,method:HTTPMethod = .post) -> Promise<RequestResultModel<T>>
    {
        //如果是get 或者 delete  请求必须要加密
        let isURLEncoding = (method == .get || method == .delete)
        
        //拼接服务器前缀 + 接口地址
        let urlStr = urlType.url + url
        isURLEncoding ? parametersEncrypt(parameters: parameters) : nil
        let parameters = isURLEncoding ? parameters : paramsEncrypt(parameters)

        //执行分解Promise
        return Promise<RequestResultModel<T>> { resolver in
            //编码方式
            let encoding : ParameterEncoding = isURLEncoding ? URLEncoding.default :JSONEncoding.default
            //开始请求
            AFSession.request(urlStr, method: method, parameters: parameters, encoding:encoding ,headers: headers).responseJSON { response in
                
                switch response.result{
                case .success:
                    // 请求成功->解析数据
                    guard let json = response.value as? [String: Any] else {
                        resolver.reject(RequestError(code: RequestErrorType.parsing.rawValue, data: "", message: "数据解析错误"))
                        return
                    }
                    // 解析json
                    let resultModel: RequestResultModel<T> = self.parsingJson(json)
                    // 后台code!=200, 走错误处理
                    guard resultModel.isSuccess else {
                        self.handleFail(urlStr: urlStr, resultModel: resultModel, resolver: resolver)
                        return
                    }
                    // 返回model
                    resolver.fulfill(resultModel)
                case let .failure(error):
                    
                    //请求失败
                    
                    debugPrint(error)
                    resolver.reject(RequestError(code: RequestErrorType.network.rawValue, data: "", message: "网络错误，请稍后重试"))
                    
                }
            }
        }
         
    }
    
    /// HTTP请求, HTTPMethod默认POST, GET不可用, 参数格式[[Key: Value]] 数组类型
    public func request<T: Convertible, Parameters: Encodable>(urlType: HttpURLType, url: String, parameters: Parameters? = nil) -> Promise<RequestResultModel<T>> {
        
        let urlStr = urlType.url + url
        let parameters = paramsEncrypt(parameters)
        
        return Promise<RequestResultModel<T>> { resolver in
            // 开始HTTP请求
            AFSession.request(urlStr, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).responseJSON { response in
                debugPrint(response)
                switch response.result {
                case .success:
                    // 解析数据
                    guard let json = response.value as? [String: Any] else {
                        resolver.reject(RequestError(code: RequestErrorType.parsing.rawValue, data: "", message: "数据解析错误"))
                        return
                    }
                    // 解析json
                    let resultModel: RequestResultModel<T> = self.parsingJson(json)
                    // 后台code!=200, 走错误处理
                    guard resultModel.isSuccess else {
                        self.handleFail(urlStr: urlStr, resultModel: resultModel, resolver: resolver)
                        return
                    }
                    // 返回model
                    resolver.fulfill(resultModel)
                case let .failure(error):
                    debugPrint(error)
                    resolver.reject(RequestError(code: RequestErrorType.network.rawValue, data: "", message: "网络错误，请稍后重试"))
                }
            }
        }
    }
    
    
    
     
    //参数加密  MD5加密
    private func parametersEncrypt(parameters:[String : Any]? = nil ){
        
        guard !dictIsEmpty(dict: parameters) else{ return }
        
        // MD5加密
        var str = ""
        let keys = parameters!.keys.sorted()
        for key in keys {
            guard var value = parameters?[key] else { continue }
            if let string = value as? String {
                if stringIsEmpty(string: string) {
                    continue
                }
            }
            stringIsEmpty(string: str) ? nil : (str += "&")
            if let valueStr = value as? String {
                value = valueStr
            }
            str += "\(key)=\(value)"
        }
        let md5Str = str + "&" + EncryptUtil.MD5Key
        //加密后的参数放在请求头
        // md5Str.md5()
        updataHeaders(name: "sign", value: md5Str)
        
        
    }
    
    /// 参数加密
    private func paramsEncrypt(_ parameters: Any? = nil) -> [String: String]? {
        
        deleteHeaders(name: "sign")
        
        // rsa加密
        if let params = parameters,
           let jsonStr = jsonStr(obj: params){
            return ["sign": jsonStr]
        }
            
//           let encryptStr = EncryptUtil.encryptTrusteeshipRSA(str: jsonStr) { return ["sign": encryptStr]  }
           
//            return  ["sign": jsonStr]
            
        return nil
    }
    
    /// 解析json
    private func parsingJson<T: Convertible>(_ json: [String: Any]) -> RequestResultModel<T> {
        
        let resultModel = json.kj.model(RequestResultModel<T>.self)
        if stringIsEmpty(string: resultModel.data) {
            return resultModel
        }
        
        // 解密
//        let key = EncryptUtil.decryptAES128(str: resultModel.sign) ?? ""
//        var decryptStr = EncryptUtil.decryptDES(str: resultModel.data, key: key) ?? ""
//        if decryptStr.hasPrefix("\"") && decryptStr.hasSuffix("\"") {
//            if let i = decryptStr.firstIndex(of: "\"") {
//                decryptStr.remove(at: i)
//            }
//            if let i = decryptStr.lastIndex(of: "\"") {
//                decryptStr.remove(at: i)
//            }
//        }
        
//        resultModel.data = decryptStr
        resultModel.pasringModel()
        
        #if DEBUG
//        if let obj = jsonObject(json: decryptStr) {
//            SLog(obj)
//        }
        #endif
        
        return resultModel
    }
    
    
    
    /// 处理接口请求错误
    private func handleFail<T: Convertible>(urlStr: String, resultModel: RequestResultModel<T>, resolver: Resolver<RequestResultModel<T>>) {
        
        if resultModel.isExit {
            // 重登
//            UserUtil.share.logout()
//            CommonUtil.setupRootVC()
//            if !self.isHasExitWindow {
//                self.pushLoginWallet(msg: resultModel.msg)
//            }
        } else if resultModel.isBanRequest {
            // 是否是配置接口请求
//            let isConf = urlStr.contains("/common/conf")
//            let isRefreshToken = urlStr.contains("common/refresh/token")
//            // 配置接口弹窗不一样 另做处理
//            if !(isConf || isRefreshToken) {
//                // 禁止国内ip访问
//                if !self.isHasAnnouncementWindow {
//                    self.isHasAnnouncementWindow = true
//                    WidgetUtil.showActionAnnouncement()
//                    resolver.reject(RequestError(code: resultModel.code, data: resultModel.data, message: ""))
//                    return
//                }
//            }
        } else if resultModel.isTokenTimeout {
            // 临时token超时
//            resolver.reject(RequestError(code: RequestErrorType.network.rawValue, data: "", message: "网络错误，请稍后重试"))
            return
        }
        
        resolver.reject(RequestError(code: resultModel.code, data: resultModel.data, message: resultModel.msg))
    }
    
}
