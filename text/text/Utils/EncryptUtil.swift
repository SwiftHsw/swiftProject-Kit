//
//  EncryptUtil.swift
//  text
//
//  Created by 黄世文 on 2022/2/24.
//
//加密解密工具  
import Foundation
//import CryptoSwift

class EncryptUtil{
     
    static var MD5Key: String {
        get {
            switch HttpRequestUntil.share.environment {
            case .production: return "83d6ab63bffd3370c2835bb4d363461d"
            case .developer: return "83d6ab63bffd3370c2835bb4d363461d"
            case .local: return "83d6ab63bffd3370c2835bb4d363461d"
            }
        }
    }
    
}
