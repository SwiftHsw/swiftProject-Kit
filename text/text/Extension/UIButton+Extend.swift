//
//  UIButton+Extend.swift
//  Gregarious
//
//  Created by Admin on 2021/3/25.
//

import UIKit
import Kingfisher

extension UIButton {
    /// 对同时设置了Image和Title的场景时UIButton中的图片和文字的关系
    ///
    /// - left: 图片在左，文字在右，整体居中
    /// - right: 图片在右，文字在左，整体居中
    /// - top: 图片在上，文字在下，整体居中
    /// - bottom: 图片在下，文字在上，整体居中
    /// - centerTitleTop: 图片居中，文字在图片上面
    /// - centerTitleBottom: 图片居中，文字在图片下面
    enum ImagePosition: Int {
        case left, right, top, bottom, centerTitleTop, centerTitleBottom
    }
    
    /// 调整按钮的文本和image的布局，前提是title和image同时存在才会调整；padding是调整布局时整个按钮和图文的间隔
    func setupImagePosition(_ position: ImagePosition = ImagePosition.left, padding: CGFloat) {
        if self.imageView?.image == nil || self.titleLabel?.text == nil { return }
        self.titleEdgeInsets = UIEdgeInsets.zero
        self.imageEdgeInsets = UIEdgeInsets.zero
        
        let imageRect = self.imageView!.frame
        let titleRect = self.titleLabel!.frame
        let totalHeight = imageRect.height + titleRect.height + padding
        let height = self.frame.height
        let width = self.frame.width
        
        switch position {
        case .left: do {
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: padding / 2.0, bottom: 0, right: -padding / 2.0)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -padding / 2.0, bottom: 0, right: padding / 2.0)
            }
        case .right: do {
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageRect.width + padding / 2.0), bottom: 0, right: (imageRect.width + padding / 2.0))
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: (titleRect.width + padding / 2), bottom: 0, right: -(titleRect.width + padding / 2))
            }
        case .top: do {
            self.titleEdgeInsets = UIEdgeInsets(top: ((height - totalHeight) / 2.0 + imageRect.height + padding - titleRect.origin.y),
                                                left: (width / 2.0 - titleRect.origin.x - titleRect.width / 2.0) - (width - titleRect.width) / 2.0,
                                                bottom: -((height - totalHeight) / 2.0 + imageRect.height + padding - titleRect.origin.y),
                                                right: -(width / 2.0 - titleRect.origin.x - titleRect.width / 2.0) - (width - titleRect.width) / 2.0)
            self.imageEdgeInsets = UIEdgeInsets(top: ((height - totalHeight) / 2.0 - imageRect.origin.y),
                                                left: (width / 2.0 - imageRect.origin.x - imageRect.width / 2.0),
                                                bottom: -((height - totalHeight) / 2.0 - imageRect.origin.y),
                                                right: -(width / 2.0 - imageRect.origin.x - imageRect.width / 2.0))
            }
        case .bottom: do {
            self.titleEdgeInsets = UIEdgeInsets(top: ((height - totalHeight) / 2.0 - titleRect.origin.y),
                                                left: (width / 2.0 - titleRect.origin.x - titleRect.width / 2.0) - (width - titleRect.width) / 2.0,
                                                bottom: -((height - totalHeight) / 2.0 - titleRect.origin.y),
                                                right: -(width / 2.0 - titleRect.origin.x - titleRect.width / 2.0) - (width - titleRect.width) / 2.0)
            self.imageEdgeInsets = UIEdgeInsets(top: ((height - totalHeight) / 2.0 + titleRect.height + padding - imageRect.origin.y),
                                                left: (width / 2.0 - imageRect.origin.x - imageRect.width / 2.0),
                                                bottom: -((height - totalHeight) / 2.0 + titleRect.height + padding - imageRect.origin.y),
                                                right: -(width / 2.0 - imageRect.origin.x - imageRect.width / 2.0))
            }
        case .centerTitleTop: do {
            self.titleEdgeInsets = UIEdgeInsets(top: -(titleRect.origin.y + titleRect.height - imageRect.origin.y + padding),
                                                left: (width / 2.0 -  titleRect.origin.x - titleRect.width / 2.0) - (width - titleRect.width) / 2.0,
                                                bottom: (titleRect.origin.y + titleRect.height - imageRect.origin.y + padding),
                                                right: -(width / 2.0 -  titleRect.origin.x - titleRect.width / 2.0) - (width - titleRect.width) / 2.0)
            self.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                left: (width / 2.0 - imageRect.origin.x - imageRect.width / 2.0),
                                                bottom: 0,
                                                right: -(width / 2.0 - imageRect.origin.x - imageRect.width / 2.0))
            }
        case .centerTitleBottom: do {
            self.titleEdgeInsets = UIEdgeInsets(top: (imageRect.origin.y + imageRect.height - titleRect.origin.y + padding),
                                                left: (width / 2.0 -  titleRect.origin.x - titleRect.width / 2.0) - (width - titleRect.width) / 2.0,
                                                bottom: -(imageRect.origin.y + imageRect.height - titleRect.origin.y + padding),
                                                right: -(width / 2.0 -  titleRect.origin.x - titleRect.width / 2.0) - (width - titleRect.width) / 2.0)
            self.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                left: (width / 2.0 - imageRect.origin.x - imageRect.width / 2.0),
                                                bottom: 0,
                                                right: -(width / 2.0 - imageRect.origin.x - imageRect.width / 2.0))
            }
        }
    }
}


// MARK: - Images

extension UIButton {
    
    /// 通用图片
    func loadImage(urlStr: String, placeholder: String = "placeholder") {
        let url = URL(string: "OSSURL" + urlStr)
        self.kf.setImage(with: url, for: .normal, placeholder: UIImage(named: placeholder))
    }
    
}

// MARK: - Badge

private var UIButton_badgeLabelKey : Void?
private var UIButton_badgeBGColorKey : Void?
private var UIButton_badgeTextColorKey : Void?
private var UIButton_badgeFontKey : Void?
private var UIButton_badgePaddingKey : Void?
private var UIButton_badgeMinSizeKey : Void?
private var UIButton_badgeOriginXKey : Void?
private var UIButton_badgeOriginYKey : Void?
private var UIButton_shouldHideBadgeAtZeroKey : Void?
private var UIButton_shouldAnimateBadgeKey : Void?
private var UIButton_badgeValueKey : Void?

extension UIButton {
    
    fileprivate var badgeLabel: UILabel? {
        set {
            objc_setAssociatedObject(self, &UIButton_badgeLabelKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &UIButton_badgeLabelKey) as? UILabel
        }
    }
    
    /// 角标值
    public var badgeValue: String? {
        set {
            objc_setAssociatedObject(self, &UIButton_badgeValueKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if let badgeV = newValue {
                if badgeV.isEmpty || badgeV == "" || (badgeV == "" && shouldHideBadgeAtZero) {
                    removeBadge()
                }
                else if self.badgeLabel == nil {
                    self.badgeLabel = UILabel(frame: CGRect(x: self.badgeOriginX , y: self.badgeOriginY, width: 20, height: 20))
                    self.badgeLabel?.textColor = self.badgeTextColor
                    self.badgeLabel?.backgroundColor = self.badgeBGColor
                    self.badgeLabel?.font = self.badgeFont
                    self.badgeLabel?.textAlignment = .center
                    badgeInit()
                    addSubview(self.badgeLabel!)
                    updateBadgeValue(animated: false)
                }
                else {
                    updateBadgeValue(animated: true)
                }
            }
        }
        get {
            return objc_getAssociatedObject(self, &UIButton_badgeValueKey) as? String
        }
    }
    
    /// 角标背景色
    public var badgeBGColor: UIColor? {
        set {
            objc_setAssociatedObject(self, &UIButton_badgeBGColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.badgeLabel != nil { refreshBadge() }
        }
        get {
            return objc_getAssociatedObject(self, &UIButton_badgeBGColorKey) as? UIColor ?? .red
        }
    }
    
    /// 角标字体颜色
    public var badgeTextColor: UIColor? {
        set {
            objc_setAssociatedObject(self, &UIButton_badgeTextColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.badgeLabel != nil { refreshBadge() }
        }
        get {
            return objc_getAssociatedObject(self, &UIButton_badgeTextColorKey) as? UIColor ?? .white
        }
    }
    
    /// 角标字体大小
    public var badgeFont: UIFont? {
        set {
            objc_setAssociatedObject(self, &UIButton_badgeFontKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.badgeLabel != nil { refreshBadge() }
        }
        get {
            return objc_getAssociatedObject(self, &UIButton_badgeFontKey) as? UIFont ?? UIFont.systemFont(ofSize: 12)
        }
    }
    
    /// 角标值距离边上的间距
    public var badgePadding: CGFloat {
        set {
            objc_setAssociatedObject(self, &UIButton_badgePaddingKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.badgeLabel != nil { updateBadgeFrame() }
        }
        get {
            return  objc_getAssociatedObject(self, &UIButton_badgePaddingKey) as? CGFloat ?? 4
        }
    }
    
    /// badgeLabel 最小尺寸
    public var badgeMinSize: CGFloat {
        set {
            objc_setAssociatedObject(self, &UIButton_badgeMinSizeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.badgeLabel != nil { updateBadgeFrame() }
        }
        
        get {
            return objc_getAssociatedObject(self, &UIButton_badgeMinSizeKey) as? CGFloat ?? 8
        }
    }
    
    /// 原始x点
    public var badgeOriginX: CGFloat {
        set {
            objc_setAssociatedObject(self, &UIButton_badgeOriginXKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.badgeLabel != nil { updateBadgeFrame() }
        }
        get {
            return objc_getAssociatedObject(self, &UIButton_badgeOriginXKey) as? CGFloat ?? 0
        }
    }
    
    /// 原始y点
    public var badgeOriginY: CGFloat {
        set {
            objc_setAssociatedObject(self, &UIButton_badgeOriginYKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if self.badgeLabel != nil { updateBadgeFrame() }
        }
        get {
            return objc_getAssociatedObject(self, &UIButton_badgeOriginYKey) as? CGFloat ?? -6
        }
    }
    
    /// 当角标值为0，是否需要隐藏
    public var shouldHideBadgeAtZero: Bool {
        set {
            objc_setAssociatedObject(self, &UIButton_shouldHideBadgeAtZeroKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &UIButton_shouldHideBadgeAtZeroKey) as? Bool ?? true
        }
    }
    
    /// 是否需要动画
    public var shouldAnimateBadge: Bool {
        set {
            objc_setAssociatedObject(self, &UIButton_shouldAnimateBadgeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &UIButton_shouldAnimateBadgeKey) as? Bool ?? true
        }
    }
    
    fileprivate func badgeInit()  {
        if let label = self.badgeLabel {
            self.badgeOriginX = self.frame.size.width - label.frame.size.width * 0.5
        }
        self.clipsToBounds = false
    }
    
    // 刷新角标UI
    fileprivate func refreshBadge() {
        guard let tempLabel = self.badgeLabel else { return }
        tempLabel.textColor = self.badgeTextColor
        tempLabel.backgroundColor = self.badgeBGColor
        tempLabel.font = self.badgeFont
    }
    
    // 移除角标
    fileprivate func removeBadge() {
        UIView.animate(withDuration: 0.2, animations: {
            self.badgeLabel?.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        }) { (finished: Bool) in
            self.badgeLabel?.removeFromSuperview()
            if (self.badgeLabel != nil) { self.badgeLabel = nil }
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
        
        self.badgeLabel?.frame = CGRect(x: self.badgeOriginX, y: self.badgeOriginY, width: badgeWidth, height: badgeHeight)
        self.badgeLabel?.layer.cornerRadius = badgeHeight / 2
        self.badgeLabel?.layer.masksToBounds = true
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
