//
//  UILabel+Extend.swift
//  Gregarious
//
//  Created by Jason on 2021/3/30.
//

import UIKit

extension UILabel {
    var isTruncated : Bool {
        guard let labelText = text else {
            return false
        }
        
        guard let font = self.font else {
            return false
        }
        
        let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelTextSize = (labelText as NSString).boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil)
        
        let labelTextLines = Int(ceil(CGFloat(labelTextSize.height) / self.font.lineHeight))
        
        var labelShowLines = Int(ceil(CGFloat(bounds.size.height) / self.font.lineHeight))
        
        if self.numberOfLines != 0 {
            labelShowLines = min(labelShowLines, self.numberOfLines)
        }
        return labelTextLines > labelShowLines
    }
    
}

public protocol TruncatedText {
    var showInLabel : UILabel? { get }
}

extension TruncatedText {
    /// 设置查看全文的Label
    public func showTruncatedText(omit: String = "...", text: String = "全文  ", omitColor: UIColor? = UIColor.green, textColor: UIColor? = UIColor.green, backgroundColor: UIColor? = UIColor.red, target: Any?, action: Selector?) {
        
        guard let label = self.showInLabel else { return }
        
        let isTruncated = label.isTruncated
        
        if !isTruncated { return }
        
        let truncatedlabel = UILabel(frame:CGRect(x:0, y:0, width:0, height:0))
        
        let att1 = NSAttributedString(string: omit, attributes: [NSAttributedString.Key.foregroundColor : (omitColor ?? UIColor.blue), NSAttributedString.Key.font : label.font!])
        
        let att2 = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : (textColor ?? UIColor.blue), NSAttributedString.Key.font : label.font!])
        
        let att = NSMutableAttributedString()
        
        att.append(att1)
        
        att.append(att2)
        
        truncatedlabel.attributedText = att
        
        truncatedlabel.font = label.font
        
        truncatedlabel.textAlignment = .left
        
        label.addSubview(truncatedlabel)
        
        truncatedlabel.sizeToFit()
        
        truncatedlabel.view_bottom = label.view_height

        truncatedlabel.view_right = label.view_width
        
        truncatedlabel.backgroundColor = backgroundColor
        
        if let act = action {
            
            label.isUserInteractionEnabled = true
            
            truncatedlabel.isUserInteractionEnabled=true
            
            let tap = UITapGestureRecognizer(target: target, action: act)
            
            truncatedlabel.addGestureRecognizer(tap)
            
        }
        
    }
}
