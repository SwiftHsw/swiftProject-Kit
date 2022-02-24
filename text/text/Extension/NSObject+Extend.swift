//
//  AnyObject+Extansion.swift
//  DeWallet
//
//  Created by apple on 2020/12/11.
//

import Foundation
import UIKit
import CommonCrypto

extension NSObject {
    
    static var className: String {
        get {
            let name = self.classForCoder().description()
            if (name.contains(".")) {
                return name.components(separatedBy: ".")[1]
            } else {
                return name
            }
        }
    }
    
    var className: String {
        get {
            let name = type(of: self).description()
            if (name.contains(".")) {
                return name.components(separatedBy: ".")[1]
            } else {
                return name
            }
        }
    }
    
}
