//
//  UIBarButtonItem+Extend.swift
//  Gregarious
//
//  Created by Jason on 2021/3/25.
//

import UIKit

extension UIBarButtonItem {
    
    class func imageBarButtonItem(imageName: String, size: CGSize, target: Any, action: Selector) -> UIBarButtonItem {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(origin: .zero, size: size)
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName), for: .selected)
        btn.addTarget(target, action: action, for: .touchUpInside)
        let item = UIBarButtonItem.init(customView: btn)
        return item
    }
    
    class func titleBarButtonItem(title: String, titleColor: UIColor =  UIColor("#EEEEEE"), size: CGSize, target: Any, action: Selector) -> UIBarButtonItem {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(origin: .zero, size: size)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(titleColor, for: .normal)
        btn.titleLabel?.font = UIFont.PingFangSCRegular(size: 15)
        btn.addTarget(target, action: action, for: .touchUpInside)
        let item = UIBarButtonItem.init(customView: btn)
        return item
    }
    
}


// MARK: - Badge

private var UIBarButtonItem_badgeLabelKey : Void?
private var UIBarButtonItem_badgeBGColorKey : Void?
private var UIBarButtonItem_badgeTextColorKey : Void?
private var UIBarButtonItem_badgeFontKey : Void?
private var UIBarButtonItem_badgePaddingKey : Void?
private var UIBarButtonItem_badgeMinSizeKey : Void?
private var UIBarButtonItem_badgeOriginXKey : Void?
private var UIBarButtonItem_badgeOriginYKey : Void?
private var UIBarButtonItem_shouldHideBadgeAtZeroKey : Void?
private var UIBarButtonItem_shouldAnimateBadgeKey : Void?
private var UIBarButtonItem_badgeValueKey : Void?


extension UIBarButtonItem {
    
    fileprivate var badgeLabel: UILabel? {
        set {
            objc_setAssociatedObject(self, &UIBarButtonItem_badgeLabelKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            var label = objc_getAssociatedObject(self, &UIBarButtonItem_badgeLabelKey) as? UILabel
            if label == nil {
                label = UILabel(frame: CGRect(x: self.badgeOriginX, y: self.badgeOriginY, width: 20, height: 20))
                objc_setAssociatedObject(self, &UIBarButtonItem_badgeLabelKey, label, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                label?.textAlignment = .center
                self.customView?.addSubview(label!)
                badgeInit()
            }
            return label
        }
    }
    
    /// 角标值
    public var badgeValue: String? {
        set {
            objc_setAssociatedObject(self, &UIBarButtonItem_badgeValueKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateBadgeValue(animated: true)
            refreshBadge()
        }
        get {
            return objc_getAssociatedObject(self, &UIBarButtonItem_badgeValueKey) as? String
        }
    }
    
    
    /// 角标背景色
    public var badgeBGColor: UIColor? {
        set {
            objc_setAssociatedObject(self, &UIBarButtonItem_badgeBGColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.badgeLabel != nil { refreshBadge() }
        }
        get {
            return objc_getAssociatedObject(self, &UIBarButtonItem_badgeBGColorKey) as? UIColor ?? .red
        }
    }
    
    /// 角标字体颜色
    public var badgeTextColor: UIColor? {
        set {
            objc_setAssociatedObject(self, &UIBarButtonItem_badgeTextColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.badgeLabel != nil { refreshBadge() }
        }
        get {
            return objc_getAssociatedObject(self, &UIBarButtonItem_badgeTextColorKey) as? UIColor ?? .white
        }
    }
    
    /// 角标字体大小
    public var badgeFont: UIFont? {
        set {
            objc_setAssociatedObject(self, &UIBarButtonItem_badgeFontKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.badgeLabel != nil { refreshBadge() }
        }
        get {
            return objc_getAssociatedObject(self, &UIBarButtonItem_badgeFontKey) as? UIFont ?? UIFont.systemFont(ofSize: 12)
        }
    }
    
    /// 角标值距离边上的间距
    public var badgePadding: CGFloat {
        set {
            objc_setAssociatedObject(self, &UIBarButtonItem_badgePaddingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.badgeLabel != nil { updateBadgeFrame() }
        }
        get {
            return  objc_getAssociatedObject(self, &UIBarButtonItem_badgePaddingKey) as? CGFloat ?? 4
        }
    }
    
    /// badgeLabel 最小尺寸
    public var badgeMinSize: CGFloat {
        set {
            objc_setAssociatedObject(self, &UIBarButtonItem_badgeMinSizeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.badgeLabel != nil { updateBadgeFrame() }
        }
        
        get {
            return objc_getAssociatedObject(self, &UIBarButtonItem_badgeMinSizeKey) as? CGFloat ?? 8
        }
    }
    
    /// 原始x点
    public var badgeOriginX: CGFloat {
        set {
            objc_setAssociatedObject(self, &UIBarButtonItem_badgeOriginXKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.badgeLabel != nil { updateBadgeFrame() }
        }
        get {
            return objc_getAssociatedObject(self, &UIBarButtonItem_badgeOriginXKey) as? CGFloat ?? 0
        }
    }
    
    /// 原始y点
    public var badgeOriginY: CGFloat {
        set {
            objc_setAssociatedObject(self, &UIBarButtonItem_badgeOriginYKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.badgeLabel != nil { updateBadgeFrame() }
        }
        get {
            return objc_getAssociatedObject(self, &UIBarButtonItem_badgeOriginYKey) as? CGFloat ?? -6
        }
    }
    
    /// 当角标值为0，是否需要隐藏
    public var shouldHideBadgeAtZero: Bool {
        set {
            objc_setAssociatedObject(self, &UIBarButtonItem_shouldHideBadgeAtZeroKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.badgeLabel != nil { refreshBadge() }
        }
        get {
            return objc_getAssociatedObject(self, &UIBarButtonItem_shouldHideBadgeAtZeroKey) as? Bool ?? true
        }
    }
    
    /// 是否需要动画
    public var shouldAnimateBadge: Bool {
        set {
            objc_setAssociatedObject(self, &UIBarButtonItem_shouldAnimateBadgeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.badgeLabel != nil { refreshBadge() }
        }
        get {
            return objc_getAssociatedObject(self, &UIBarButtonItem_shouldAnimateBadgeKey) as? Bool ?? true
        }
    }
    
    fileprivate func badgeInit()  {
        var superview: UIView? = nil
        var defaultOriginX: CGFloat = 0
        guard let sview = self.customView, let label = self.badgeLabel else {
            return
        }
        superview = sview
        defaultOriginX = sview.frame.size.width - label.frame.size.width / 2;
        superview?.clipsToBounds = false
        superview?.addSubview(label)
        self.badgeBGColor = .red
        self.badgeTextColor = .white
        self.badgeFont = UIFont.systemFont(ofSize: 12)
        self.badgePadding = 4
        self.badgeMinSize = 8
        self.badgeOriginX = defaultOriginX
        self.badgeOriginY = -4
        self.shouldHideBadgeAtZero = true
        self.shouldAnimateBadge = true
    }

    
    // 刷新角标UI
    fileprivate func refreshBadge() {
        guard let tempLabel = self.badgeLabel else { return }
        tempLabel.textColor = self.badgeTextColor
        tempLabel.backgroundColor = self.badgeBGColor
        tempLabel.font = self.badgeFont
        if self.badgeValue == nil || self.badgeValue == "" || (self.badgeValue == "0" && shouldHideBadgeAtZero) {
            tempLabel.isHidden = true
        }
        else {
            tempLabel.isHidden = false
            updateBadgeValue(animated: true)
        }
    }
    
    // 更新角标值
    fileprivate func updateBadgeValue(animated: Bool) {
        if animated && self.shouldAnimateBadge && !(self.badgeLabel?.text == self.badgeValue) {
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.fromValue = 1.5
            animation.toValue = 1
            animation.duration = 0.2
            animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 1.3, 1.0, 1.0)
            self.badgeLabel?.layer.add(animation, forKey: "bounceAnimation")
        }
        
        var badgeValue = 0
        if let badgeStr = self.badgeValue , let value = Int(badgeStr) {
            badgeValue = value
        }
        self.badgeLabel?.text = badgeValue >= 99 ? "99+" : self.badgeValue
//        self.badgeLabel?.text =  self.badgeValue
        let duration: TimeInterval = (animated && self.shouldAnimateBadge) ? 0.2 : 0
        UIView.animate(withDuration: duration, animations: {
            self.updateBadgeFrame()
        })
    }

    // 更新角标frame
    fileprivate  func updateBadgeFrame() {
        let expectedLabelSize: CGSize = badgeExpectedSize()
        var minHeight: CGFloat = expectedLabelSize.height
        minHeight = (minHeight < badgeMinSize) ? badgeMinSize : expectedLabelSize.height
        
        var minWidth: CGFloat = expectedLabelSize.width
        let padding = self.badgePadding
        minWidth = (minWidth < minHeight) ? minHeight : expectedLabelSize.width
        
        let badgeWidth = minWidth + padding
        let badgeHeight = minHeight + padding
        
        self.badgeLabel?.layer.masksToBounds = true
        self.badgeLabel?.frame = CGRect(x: self.badgeOriginX, y: self.badgeOriginY, width: badgeWidth, height: badgeHeight)
        self.badgeLabel?.layer.cornerRadius = badgeHeight / 2
        
    }
    
    
    fileprivate func badgeExpectedSize() -> CGSize {
        let frameLabel: UILabel = duplicate(self.badgeLabel)
        frameLabel.sizeToFit()
        let expectedLabelSize: CGSize = frameLabel.frame.size
        return expectedLabelSize
    }
    
    fileprivate func duplicate(_ labelToCopy: UILabel?) -> UILabel {
        guard let temp = labelToCopy else { fatalError("################### Label为空") }
        let duplicateLabel = UILabel(frame: temp.frame)
        duplicateLabel.text = temp.text
        duplicateLabel.font = temp.font
        return duplicateLabel
    }
    
}
