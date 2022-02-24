//
//  HttpRequestModel.swift
//  DeWallet
//
//  Created by apple on 2020/12/11.
//

import Foundation
import KakaJSON

class RequestError: Error {
    
    var code = ""
    var data = ""
    var message = ""
    
    init(code: String, data: String, message: String) {
        self.code = code
        self.data = data
        self.message = message
    }
    
}

class RequestResultModel<T: Convertible>: BaseModel {
    
    var code = ""
    /// 解密后的json, 如果T是RequestStringModel则是后台返回的参数
    var data = ""
    var msg = ""
    var sign = ""
    
    // MARK: - 本地使用
    
    /// 解析数据格式[key: value]
    var model: T?
    /// 解析数据格式[[key: value]]
    var modelArray: [T]?
    
    /// 是否请求成功
    var isSuccess: Bool {
        get {
            return code == "200"
        }
    }
    
    /// 重登
    var isExit: Bool {
        get {
            return self.code == "-6"
        }
    }
    
    /// 禁止国内ip访问
    var isBanRequest: Bool {
        get {
            return self.code == "0"
        }
    }
    
    /// 临时token 超时
    var isTokenTimeout: Bool {
        get {
            return self.code == "-5"
        }
    }
    
    /// 把json解析成model
    func pasringModel() {
        // RequestStringModel 字符串数据不必再解析, 数据在data
        guard !stringIsEmpty(string: data),
              T.self != RequestStringModel.self else {
            return
        }
        // 解析model或者modelArray
        let obj = jsonObject(json: data)
        if obj is [String: Any] {
            model = data.kj.model(T.self)
        } else if obj is [[String: Any]] {
            modelArray = data.kj.modelArray(T.self)
        }
    }
    
}

/// 不需要解析数据 或者 需要解析的数据是字符串 用这个model
class RequestStringModel: BaseModel {
    
}
