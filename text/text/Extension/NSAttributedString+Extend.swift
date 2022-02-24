//
//  NSAttributedString+Extend.swift
//  Gregarious
//
//  Created by Apple on 2021/4/21.
//

import UIKit

extension NSAttributedString {
    
    func sizeFor(font: UIFont, size: CGSize) -> CGSize {
        let tempAttr = NSMutableAttributedString(attributedString: self)
        tempAttr.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, tempAttr.length))
        let rect = tempAttr.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return rect.size
    }
    
}
