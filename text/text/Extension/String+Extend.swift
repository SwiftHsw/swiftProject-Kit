//
//  String+Extend.swift
//  Gregarious
//
//  Created by Apple on 2021/3/24.
//

import UIKit

extension String {
    
 
    /// 字符串是否为空
    public func stringIsEmpty(str: String?) -> Bool {
        return str?.isEmpty ?? true
    }

    /// 数组是否为空
    public func arrayIsEmpty(arr: Array<Any>?) -> Bool {
        return arr?.isEmpty ?? true
    }

    /// 字典是否为空
    public func dicIsEmpty(dic: [AnyHashable : Any]?) -> Bool {
        return dic?.isEmpty ?? true
    }
    
    /// 字符串截取
    func subString(to index: Int) -> String {
        if index >= self.count {
            return String(self[..<self.index(self.startIndex, offsetBy: self.count)])
        }
        return String(self[..<self.index(self.startIndex, offsetBy: index)])
    }
    /// 字符串截取
    func subString(from index: Int) -> String {
        if index >= self.count {
            return String(self[self.index(self.startIndex, offsetBy: self.count)...])
        }
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
    /// 字符串截取
    func subString(from index: Int, offSet: Int) -> String {
        let begin = self.subString(from: index)
        let str = begin.subString(to: offSet)
        return str
    }
    
    /// 返回指定范围的字符串
    func substring(of range: NSRange) -> String? {
        let end = NSMaxRange(range)
        if end > self.count { return nil }
        let startIndex = self.index(self.startIndex, offsetBy: range.location)
        let endIndex = self.index(self.startIndex, offsetBy: end)
        return String(self[startIndex..<endIndex])
    }
    
    /// range转换为NSRange
    func range(from range: Range<String.Index>) -> NSRange? {
        let utf16view = self.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
        }
        return nil
    }
    
    /// 返回所有与searchString匹配的位置(NSRange)
    func rangeOfString(_ searchString: String) -> [NSRange]? {
        if searchString.count == 0 { return nil }
        var ranges: [NSRange] = []
        
        if let regularExpression = try? NSRegularExpression(pattern: searchString, options: []) {
            regularExpression.enumerateMatches(in: self, range: NSRange(location: 0, length: count)) { (result, flags, stop) in
                if let range = result?.range {
                    ranges.append(range)
                }
            }
        }
        return ranges
    }
    
    func ranges(of str: String) -> [NSRange] {
        
        var ranges: [NSRange] = []
        let tempStr = NSString(string: self)
        
        var range = tempStr.range(of: str, range: NSMakeRange(0, tempStr.length))
        while range.location != NSNotFound {
            ranges.append(range)
            let loc = range.location + range.length
            let searchRange = NSMakeRange(loc, tempStr.length - loc)
            range = tempStr.range(of: str, range: searchRange)
        }
        
        return ranges
    }
    
    func size(size: CGSize, font: UIFont) -> CGSize {
        
        guard !stringIsEmpty(str: self) else {
            return .zero
        }
        
        let str = self as NSString
        let rect = str.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return rect.size
    }
    
    func widthForText(fontSize: CGFloat, height: CGFloat = 15) -> CGFloat {
        
        let font = UIFont.systemFont(ofSize: fontSize)
        var width: CGFloat = 0
        
        let rect = self.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        width = ceil(rect.width)
        
        return width
    }
    
    func widthForText(font: UIFont, height: CGFloat = 15) -> CGFloat {
        
        var width: CGFloat = 0
        let rect = self.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        width = ceil(rect.width)
        
        return width
    }
    
    func heightForText(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        
        let font = UIFont.systemFont(ofSize: fontSize)
        var height: CGFloat = 0
        
        let rect = self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        height = ceil(rect.height)
        
        return height
    }
    
    func heightForPUHUIText(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        
        let font = UIFont.PUHUIRegular(size: fontSize)
        var height: CGFloat = 0
        
        let rect = self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        height = ceil(rect.height)
        
        return height
    }
    
    func heightForText(font: UIFont, width: CGFloat) -> CGFloat {
        
        var height: CGFloat = 0
        let rect = self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        height = ceil(rect.height)
        
        return height
    }
    
    func heightForText(fontSize: CGFloat, width: CGFloat, maxHeight: CGFloat) -> CGFloat {
        
        let font = UIFont.systemFont(ofSize: fontSize)
        var height: CGFloat = 0
        
        let rect = self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        height = ceil(rect.height)
        
        return height > maxHeight ? maxHeight : height
    }
    
    func clearRedundantZero() -> String {
        
        let array = self.components(separatedBy: ".")
        guard array.count > 1 else {
            return self
        }
        
        var str = array.last!
        while str.hasSuffix("0") {
            str.removeLast()
        }
        
        return array.first! + "." + str
    }
    
    func clearFristRedundantZero() -> String {
        
        let array = self.components(separatedBy: ".")

        var str = array.first!
        while str.hasPrefix("0") {
            str.removeFirst()
        }
        guard array.count > 1 else {
            return str
        }
        if str == "" {
            str = "0"
        }
        return str + "." + array.last!
    }
    
    /// 检查数字是否符合前几位后几位
    func vaildAmount(prefixDecimal: Int, suffixDecimal: Int) -> Bool {
        
        let arr = self.components(separatedBy: ".")
        if arr.count == 1 {
            return self.count <= prefixDecimal
        } else if arr.count == 2 {
            return arr.first!.count <= prefixDecimal && arr.last!.count <= suffixDecimal
        } else {
            return false
        }
    }
    /// 判断是不是Emoji
    func containsEmoji()->Bool{
         for scalar in unicodeScalars {
             switch scalar.value {
             case 0x1F600...0x1F64F,
                  0x1F300...0x1F5FF,
                  0x1F680...0x1F6FF,
                  0x2600...0x26FF,
                  0x2700...0x27BF,
                  0xFE00...0xFE0F:
                 return true
             default:
                 continue
             }
         }

         return false
     }

    /// 判断是不是Emoji
    ///
    /// - Returns: true false
    func hasEmoji()->Bool {
        let pattern = "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"
        let pred = NSPredicate(format: "SELF MATCHES %@",pattern)
        return pred.evaluate(with: self)
    }
    
    func isInputRuleNotBlank() -> Bool {
        let pattern = "^[➋➌➍➎➏➐➑➒]*$"
        let pred = NSPredicate(format: "SELF MATCHES %@",pattern)
        return pred.evaluate(with: self)
    }
    
    func walletAddressFormat(prefix: Int = 10, suffix: Int = 10) -> String {
        
        guard self.count > prefix + suffix else {
            return self
        }
        
        let prefixStr = self.prefix(prefix)
        let suffixStr = self.suffix(suffix)
        return String(prefixStr + "..." + suffixStr)
    }
}

extension String {
    
    /// 将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
     
    /// 将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
    
    /// 删除空格前缀
    func removePrefixSpace() -> String {
        var temp = self
        while temp.hasPrefix(" ") {
            temp = "\(temp.removeFirst())"
        }
        return temp
    }
    
}
