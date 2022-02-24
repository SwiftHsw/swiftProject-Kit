//
//  Macro.swift
//  text
//
//  Created by 黄世文 on 2022/2/23.
//

import Foundation
import sqlcipher

//通用block 模版声明
typealias BlockWithNone = () -> ()
typealias BlockWithParameters<T> = (T) -> ()

// 自定义Log
public func SLog<T>(_ message: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
#if DEBUG
    let fileName = (file as NSString).lastPathComponent;
    print("🔨 [文件名：\(fileName)], [方法：\(funcName)], [行数：\(lineNum)]\n🔨 \(message)");
#endif
}

/// 字符串是否为空
public func stringIsEmpty(string:String?) -> Bool{
    return string?.isEmpty ?? true
}

/// 数组是否为空
public func arrayIsEmpty(arr: Array<Any>?) -> Bool{
    return arr?.isEmpty ?? true
}

//字典是否为空
public func dictIsEmpty(dict:[AnyHashable : Any]?) ->Bool{
    return dict?.isEmpty ?? true
}

/// json解析
 public func jsonData(data: Data) -> Any? {
    let object = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    return object
}

/// 解析json字符串
 public func jsonStr(obj: Any) -> String? {
    guard let data = try? JSONSerialization.data(withJSONObject: obj, options: []) else {
        return nil
    }
    let jsonStr = String(data: data, encoding: .utf8)
    return jsonStr
}

/// json解析
 public func jsonObject(json: String) -> Any? {
    guard let data = json.data(using: .utf8) else { return nil }
    let object = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    return object
}
