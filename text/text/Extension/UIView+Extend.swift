//
//  CALayerExtension.swift
//  DeWallet
//
//  Created by apple on 2020/12/14.
//

import UIKit

//抖动方向枚举
public enum ShakeDirection: Int {
    case horizontal  //水平抖动
    case vertical  //垂直抖动
}
 
extension UIView {
     
    /**
     扩展UIView增加抖动方法
      
     @param direction：抖动方向（默认是水平方向）
     @param times：抖动次数（默认5次）
     @param interval：每次抖动时间（默认0.1秒）
     @param delta：抖动偏移量（默认2）
     @param completion：抖动动画结束后的回调
     */
    public func shake(direction: ShakeDirection = .horizontal, times: Int = 3,
                      interval: TimeInterval = 0.05, delta: CGFloat = 2,
                      completion: (() -> Void)? = nil) {
        //播放动画
        UIView.animate(withDuration: interval, animations: { () -> Void in
            switch direction {
            case .horizontal:
                self.layer.setAffineTransform( CGAffineTransform(translationX: delta, y: 0))
                break
            case .vertical:
                self.layer.setAffineTransform( CGAffineTransform(translationX: 0, y: delta))
                break
            }
        }) { (complete) -> Void in
            //如果当前是最后一次抖动，则将位置还原，并调用完成回调函数
            if (times == 0) {
                UIView.animate(withDuration: interval, animations: { () -> Void in
                    self.layer.setAffineTransform(CGAffineTransform.identity)
                }, completion: { (complete) -> Void in
                    completion?()
                })
            }
            //如果当前不是最后一次抖动，则继续播放动画（总次数减1，偏移位置变成相反的）
            else {
                self.shake(direction: direction, times: times - 1,  interval: interval,
                           delta: delta * -1, completion:completion)
            }
        }
    }
}

// MARK: - xib

extension UIView {
    
    @IBInspectable
    var IB_cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var IB_borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var IB_borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var IB_shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var IB_shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var IB_shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var IB_shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
}

// MARK: - rect

extension UIView {
    
    /// frame.origin.x
    var view_left: CGFloat {
        set { frame.origin.x = newValue }
        get { return frame.origin.x }
    }
    
    /// frame.origin.x + frame.size.width
    var view_right: CGFloat {
        set { frame.origin.x = newValue - frame.width }
        get { return frame.origin.x + frame.width }
    }
    
    /// frame.origin.y
    var view_top: CGFloat {
        set { frame.origin.y = newValue }
        get { return frame.origin.y }
    }
    
    /// frame.origin.y + frame.size.height
    var view_bottom: CGFloat {
        set { frame.origin.y = newValue - frame.height }
        get { return frame.origin.y + frame.height }
    }
    
    // frame.size.width
    var view_width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            var f = frame
            f.size.width = newValue
            frame = f
        }
    }
    // frame.size.height
    var view_height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            var f = frame
            f.size.height = newValue
            frame = f
        }
    }
    // frame.size
    var view_size: CGSize {
        get {
            return CGSize(width: view_width, height: view_height)
        }
        set {
            view_width = newValue.width
            view_height = newValue.height
        }
    }
    // center.x
    var view_centerX: CGFloat {
        get {
            return center.x
        }
        set {
            center = CGPoint(x: newValue, y: center.y)
        }
    }
    // center.y
    var view_centerY: CGFloat {
        get {
            return center.y
        }
        set {
            center = CGPoint(x: center.x, y: newValue)
        }
    }
    
    /// 返回当前transform scale x
    var view_scaleX: CGFloat {
        return transform.a
    }
    
    /// 返回当前transform scale
    var view_scaleY: CGFloat {
        return transform.b
    }
    
    /// 返回当前transform translation x
    var view_translationX: CGFloat {
        return transform.tx
    }
    
    /// 返回当前transform translation y
    var view_translationY: CGFloat {
        return transform.ty
    }
    
    func removeAllSubviews() {
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
    }
    
}

// MARK: - layer

extension UIView {
    
    /// 设置圆角
    func configRectCorner(corner: UIRectCorner, radii: CGSize) {
           
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corner, cornerRadii: radii)
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        
        self.layer.mask = maskLayer
    }
    
    /// 设置渐变色
    func configGradient(colors: [CGColor], startPoint: CGPoint, endPoint: CGPoint) {
        let bgLayer = CAGradientLayer()
        bgLayer.colors = colors
        bgLayer.locations = [0, 1]
        bgLayer.frame = self.bounds
        bgLayer.startPoint = startPoint
        bgLayer.endPoint = endPoint
        bgLayer.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(bgLayer, at: 0)
    }
    
    /// 截图
    func snapshot(scale:Bool = true) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, (scale ? UIScreen.main.scale : 2))
        
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return image
        }

        return nil
    }
    
    /// view所在控制器
    func currentViewController() -> UIViewController? {
        // 1.通过响应者链关系，取得此视图的下一个响应者
        var vc = next
        while vc != nil {
            // 2.判断响应者对象是否是视图控制器类型
            if vc is UIViewController {
                // 3.转换类型后 返回
                return vc as? UIViewController
            }
            vc = vc?.next
        }
        return nil
    }
    
    /// xib快捷初始化
    class func fromNib() -> Self {
        return Bundle.main.loadNibNamed(self.className, owner: nil, options: nil)?.first as! Self
    }
    
    class func cellFromNib() -> UINib {
        return UINib.init(nibName: self.className, bundle: nil)
    }
    
}

// MARK: - Actions

typealias TapViewClosure = (_ gesture: UITapGestureRecognizer) -> ()
private var View_TapKey: Void?

extension UIView {
    var tapViewClosure: TapViewClosure? {
        set {
            objc_setAssociatedObject(self, &View_TapKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            addViewTapClosure()
        }
        get {
            return objc_getAssociatedObject(self, &View_TapKey) as? TapViewClosure
        }
    }
    
    final private func addViewTapClosure() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        self.addGestureRecognizer(tap)
        // 为ture只响应优先级最高的事件，Button高于手势，textfield高于手势，textview高于手势，手势高于tableview。为no同时都响应，默认为ture
        tap.cancelsTouchesInView = true
    }
    
    @objc final private func tapped(_ sender: UITapGestureRecognizer) {
        guard let block = tapViewClosure else {
            return
        }
        block(sender)
    }
}
extension UISwitch {

    func set(offTint color: UIColor ) {
        let minSide = min(bounds.size.height, bounds.size.width)
        layer.cornerRadius = minSide / 2
        backgroundColor = color
        tintColor = color
    }
}
