//
//  Dictionary+Extend.swift
//  Gregarious
//
//  Created by Admin on 2021/3/25.
//

import UIKit


extension Dictionary {
    ///  返回两个Dictionary合并后的新Dictionary
    ///
    ///      let dict = ["key1": "value1"] + ["key2": "value2"]
    ///      print(dict) -> ["key1": "value1", "key2": "value2"]
    ///
    static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach { result[$0] = $1 }
        return result
    }

    /// 将Dictionary的key和value都添加到另一个Dictionary
    ///
    ///     var dict = ["key1": "value1"]
    ///     dict += ["key2": "value2"]
    ///     print(dict) -> ["key1": "value1", "key2": "value2"]
    ///
    static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach { lhs[$0] = $1}
    }

    /// 返回Dictionary移除指定的key后的新的Dictionary
    ///
    ///     let dict = ["key1": "value1", "key2": "value2", "key3": "value3"]
    ///     let result = dict - ["key1", "key2"]
    ///     print(result) -> ["key3": "value3"]
    ///
    static func - <S: Sequence>(lhs: [Key: Value], keys: S) -> [Key: Value] where S.Element == Key {
        var result = lhs
        result.dict_removeAll(keys: keys)
        return result
    }

    /// 移除指定的key
    ///
    ///     var dict = ["key1": "value1", "key2": "value2", "key3": "value3"]
    ///     dict -= ["key1", "key2"]
    ///     print(dict) -> ["key3": "value3"]
    ///
    static func -= <S: Sequence>(lhs: inout [Key: Value], keys: S) where S.Element == Key {
        lhs.dict_removeAll(keys: keys)
    }
    
    /// 从字典中删除keys参数中包含的所有键
    ///
    ///     var dict: [String: String] = ["key1" : "value1", "key2" : "value2", "key3" : "value3"]
    ///     dict.dict_removeAll(keys: ["key1", "key2"])
    ///     dict.keys.contains("key3") -> true
    ///     dict.keys.contains("key1") -> false
    ///     dict.keys.contains("key2") -> false
    ///
    mutating func dict_removeAll<S: Sequence>(keys: S) where S.Element == Key {
        keys.forEach { self.removeValue(forKey: $0) }
    }
}
