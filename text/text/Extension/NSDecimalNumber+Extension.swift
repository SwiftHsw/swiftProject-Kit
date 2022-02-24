//
//  NSDecimalNumber+Extension.swift
//  swiftTest
//
//  Created by Jason on 2021/7/14.
//

import Foundation
import UIKit

extension NSDecimalNumber {
    
    class func add(former: String, latter: String) -> String {
        let formerDeci = NSDecimalNumber.init(string: former)
        let latterDeci = NSDecimalNumber.init(string: latter)
        
        let hanle = NSDecimalNumberHandler.init(roundingMode: RoundingMode.down, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let sum = formerDeci.adding(latterDeci, withBehavior: hanle)
        return sum.stringValue
    }
    
    class func subtract(former: String, latter: String) ->String {
        let formerDeci = NSDecimalNumber.init(string: former)
        let latterDeci = NSDecimalNumber.init(string: latter)
        
        let hanle = NSDecimalNumberHandler.init(roundingMode: RoundingMode.down, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let value = formerDeci.subtracting(latterDeci, withBehavior: hanle)
        return value.stringValue
    }
    
    class func multiply(former: String, latter: String) -> String {
        
        let formerDeci = NSDecimalNumber.init(string: former)
        let latterDeci = NSDecimalNumber.init(string: latter)
        
        let hanle = NSDecimalNumberHandler.init(roundingMode: RoundingMode.down, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let value = formerDeci.multiplying(by: latterDeci, withBehavior: hanle)
        return value.stringValue
    }
    
    class func dividing(former: String, latter: String) ->String {
        let formerDeci = NSDecimalNumber.init(string: former)
        let latterDeci = NSDecimalNumber.init(string: latter)
        
        let hanle = NSDecimalNumberHandler.init(roundingMode: RoundingMode.down, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let value = formerDeci.dividing(by:latterDeci, withBehavior: hanle)
        return value.stringValue
    }
    
    /// 四舍五入
    class func rounding(number: String, scale: Int) -> String {
        let formerDeci = NSDecimalNumber.init(string: number)
        let latterDeci = NSDecimalNumber.init(string: "0.00")
        
        let hanle = NSDecimalNumberHandler.init(roundingMode: RoundingMode.bankers, scale: Int16(scale), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let value = formerDeci.adding(latterDeci, withBehavior: hanle)
        if scale == 0 {
            return String.init(format: "%.0f", value.doubleValue)
        } else {
            let value = value.doubleValue * Double(scale * 10)
            let intValue = Int(value) / Int(scale * 10)
            return String.init(format: "%f", intValue)
        }
    }
    
    /// 只舍不入
    class func abnegate(former: String, scale: Int) -> String {
        
        let formerDeci = NSDecimalNumber.init(string: former)
        let latterDeci = NSDecimalNumber.init(string: "0.00")
        
        let hanle = NSDecimalNumberHandler.init(roundingMode: RoundingMode.down, scale: Int16(scale), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let value = formerDeci.adding(latterDeci, withBehavior: hanle)
        if value.floatValue <= 0 {
            return "0.00"
        }
        return value.stringValue
    }
    /// 只入不舍
    class func intoOne(former: String, scale: Int) -> String {
        
        let formerDeci = NSDecimalNumber.init(string: former)
        let latterDeci = NSDecimalNumber.init(string: "0.00")
        
        let hanle = NSDecimalNumberHandler.init(roundingMode: RoundingMode.up, scale: Int16(scale), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let value = formerDeci.adding(latterDeci, withBehavior: hanle)
        return value.stringValue
    }
    
}
