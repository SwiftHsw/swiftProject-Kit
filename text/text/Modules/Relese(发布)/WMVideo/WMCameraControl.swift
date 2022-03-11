//
//  WMCameraControl.swift
//  WMVideo
//
//  Created by wumeng on 2019/11/25.
//  Copyright © 2019 wumeng. All rights reserved.
//

import UIKit



enum WMLongPressState {
    case begin
    case end
}

protocol WMCameraControlDelegate: class {
    func cameraControlDidTakePhoto()
    func cameraControlBeginTakeVideo()
    func cameraControlEndTakeVideo()
    func cameraControlDidChangeFocus(focus: Double)
    func cameraControlDidChangeCamera()
    func cameraControlDidClickBack()
    func cameraControlDidExit()
    func cameraControlDidComplete()
}

class WMCameraControl: UIView {
    
    public var progressViewBlock : BlockWithParameters<Double>?
    
    weak open var delegate: WMCameraControlDelegate?
    // record video length
    var videoLength: Double = 10
    
    var recordTime: Double = 0
    
    var isStar = false
    
    public var anmitionTimeView = WMAnmitionTimeView()
    
    // input tupe
    var inputType:WMCameraType = WMCameraType.imageAndVideo
    
    let cameraButton = UIVisualEffectView(effect: UIBlurEffect.init(style: .extraLight))
    let centerView = UIView()
    let progressLayer = CAShapeLayer()
    let retakeButton = UIButton()
    let takeButton = UIButton()
    let exitButton = UIButton()
    let changeCameraButton = UIButton()
    
    var minute :Double =  0   // 分钟
    var second :Double = 0 // 秒
    var millisecond :Double = 0 // 毫秒 
    var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCameraButton()
        
        retakeButton.frame = cameraButton.frame
        retakeButton.isHidden = true
        retakeButton.setBackgroundImage(UIImage.wm_imageWithName_WMCameraResource(named: "icon_return"), for: .normal)
        retakeButton.addTarget(self, action: #selector(retakeButtonClick), for: .touchUpInside)
        self.addSubview(retakeButton)
        
        takeButton.frame = cameraButton.frame
        takeButton.isHidden = true
        takeButton.setBackgroundImage(UIImage.wm_imageWithName_WMCameraResource(named: "icon_finish"), for: .normal)
        takeButton.addTarget(self, action: #selector(takeButtonClick), for: .touchUpInside)
        self.addSubview(takeButton)
        
//        
//        exitButton.setImage(UIImage.wm_imageWithName_WMCameraResource(named: "arrow_down"), for: .normal)
//        exitButton.frame = CGRect(x: 50, y: self.wm_height * 0.5 - 20, width: 40, height: 40)
//        exitButton.addTarget(self, action: #selector(exitButtonClick), for: .touchUpInside)
//        self.addSubview(exitButton)
//        
        
//        changeCameraButton.setImage(UIImage.wm_imageWithName_WMCameraResource(named: "change_camera"), for: .normal)
//        changeCameraButton.frame = CGRect(x: self.wm_width - 50 - 40, y: self.wm_height * 0.5 - 20, width: 40, height: 40)
//        changeCameraButton.addTarget(self, action: #selector(changeCameraButtonClick), for: .touchUpInside)
//        self.addSubview(changeCameraButton)
        
        anmitionTimeView.frame = CGRect(x: 0, y: cameraButton.wm_y - 43, width: 150, height: 20)
        anmitionTimeView.isHidden = true
        anmitionTimeView.wm_centerX = self.wm_centerX
        self.addSubview(anmitionTimeView)
    }
    
    func setupCameraButton() {
        cameraButton.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        cameraButton.alpha = 1.0
        cameraButton.center = CGPoint(x: self.wm_width * 0.5, y: self.wm_height * 0.5)
        cameraButton.layer.cornerRadius = cameraButton.wm_width * 0.5
        cameraButton.layer.masksToBounds = true
        self.addSubview(cameraButton)
        
        centerView.frame = CGRect(x: 10, y: 10, width: cameraButton.wm_width - 20, height: cameraButton.wm_height - 20)
        centerView.layer.cornerRadius = centerView.wm_width * 0.5
        centerView.backgroundColor = .white
        cameraButton.contentView.addSubview(centerView)
        
        let center = cameraButton.wm_width * 0.5
        let radius = center - 2.5
        let path = UIBezierPath(arcCenter: CGPoint(x: center, y: center), radius: radius, startAngle: .pi * -0.5, endAngle: .pi * 1.5, clockwise: true)
        
        progressLayer.frame = cameraButton.bounds
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.black.cgColor
        progressLayer.lineCap = CAShapeLayerLineCap.square
        progressLayer.path = path.cgPath
        progressLayer.lineWidth = 5
        progressLayer.strokeEnd = 0
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = cameraButton.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor, #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.mask = progressLayer
        cameraButton.layer.addSublayer(gradientLayer)
       
        
        cameraButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didStarGesture)))
        
//        cameraButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGesture)))
//        cameraButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:))))
    }
    
    @objc func longPressGesture(_ res: UIGestureRecognizer) {
        
        guard self.inputType == .video || self.inputType == .imageAndVideo else {
            return
        }
        switch res.state {
        case .began:
            longPressBegin()
        case .changed:
            let pointY = res.location(in: self.cameraButton).y
            guard let delegate = delegate else { return }
            if pointY <= 0 {
                delegate.cameraControlDidChangeFocus(focus: Double(abs(pointY)))
            } else if pointY <= 10 {
                delegate.cameraControlDidChangeFocus(focus: 0)
            }
        default:
            longPressEnd()
        }
    }
    
    @objc func didStarGesture() {
        //开始录制换成单击 录制
        isStar = !isStar
         
        isStar ?  longPressBegin() : longPressEnd()
    }
    
    
    @objc func tapGesture() {
        guard self.inputType == .image || self.inputType == .imageAndVideo else {
            return
        }
        guard let delegate = delegate else { return }
        delegate.cameraControlDidTakePhoto()
        cameraButton.isHidden = true
        changeCameraButton.isHidden = true
        exitButton.isHidden = true
    }
    
    func longPressBegin() {
        guard let delegate = delegate else { return }
        delegate.cameraControlBeginTakeVideo()
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timeRecord), userInfo: nil, repeats: true)
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let `self` = self else { return }
            self.cameraButton.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
            self.centerView.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
        })
    }
    
    func longPressEnd() {
        guard let timer = timer else { return }
        timer.invalidate()
        self.timer = nil
        
        cameraButton.isHidden = true
        changeCameraButton.isHidden = true
        exitButton.isHidden = true
        cameraButton.transform = CGAffineTransform.identity
        centerView.transform = CGAffineTransform.identity
        progressLayer.strokeEnd = 0
        
        guard let delegate = delegate else { return }
        delegate.cameraControlEndTakeVideo()
        
        anmitionTimeView.isHidden = true
    }
    
    func showCompleteAnimation() {
        self.retakeButton.isHidden = false
        self.takeButton.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.retakeButton.wm_x = self.takeButton.wm_x + 100
//            self.takeButton.wm_x = self.wm_width - self.takeButton.wm_width - 50
        })
    }
    
    @objc func retakeButtonClick() {
         
        let alertView = UIAlertController.init(title: "提示", message: "确定删除上一段视频吗？", preferredStyle: .alert)

            let alert = UIAlertAction.init(title: "确定", style: .destructive) { (UIAlertAction) in
                self.sss()
            }
            let cancleAlert = UIAlertAction.init(title: "取消", style: .cancel) { (UIAlertAction) in
                
                print("点击取消按钮")
            }
            alertView.addAction(cancleAlert)

            alertView.addAction(alert);

        self.getCurrentVC()?.present(alertView, animated: true, completion: nil)
        
       
    }
    
    /// 获取当前VC
      public func getCurrentVC(base: UIViewController? = AppWindow.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getCurrentVC(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            return getCurrentVC(base: tab.selectedViewController)
        }
        
        if let presented = base?.presentedViewController {
            return getCurrentVC(base: presented)
        }
        
        if let split = base as? UISplitViewController {
            return getCurrentVC(base: split.presentingViewController)
        }
        
        return base
    }
    
    
    @objc func sss(){
        cameraButton.isHidden = false
        changeCameraButton.isHidden = false
        exitButton.isHidden = false
        retakeButton.isHidden = true
        takeButton.isHidden = true
        retakeButton.frame = cameraButton.frame
        takeButton.frame = cameraButton.frame
        recordTime = 0
        guard let delegate = delegate else { return }
        delegate.cameraControlDidClickBack()
    }
    
    @objc func exitButtonClick() {
        guard let delegate = delegate else { return }
        delegate.cameraControlDidExit()
    }
    
    @objc func takeButtonClick() {
        guard let delegate = delegate else { return }
        delegate.cameraControlDidComplete()
    }
    
    @objc func changeCameraButtonClick() {
        guard let delegate = delegate else { return }
        delegate.cameraControlDidChangeCamera()
    }
    
    
    @objc func timeFormatFormSeconds(_ currentTime:Double) -> String{
         
        if currentTime < 60 {
             return   String(format: "00:%.0f", currentTime)
          }else if currentTime < 3600 {
              let minutes = String(format: "%00d", Int(currentTime/60))
              let re = currentTime.truncatingRemainder(dividingBy: 60)
              let seconds = String(format: "%02.0f", re)
              return  minutes + ":" + seconds
          }else {
              let hours = String(format: "%00d", Int(currentTime/3600))
              let minutes = String(format: "%02d", (Int(currentTime/60)-(Int(currentTime/3600)*60)))
              let re = currentTime.truncatingRemainder(dividingBy: 60)
              let seconds = String(format: "%02.0f", re)
              return  hours + ":" + minutes + ":" + seconds
          }
        
    }
    @objc func timeRecord() {
        recordTime += 0.01
        setProgress(recordTime / videoLength)
        progressViewBlock?(recordTime / videoLength)
  
        let str = timeFormatFormSeconds(recordTime)
//         print(str)
        anmitionTimeView.timeLabel.text = str
    }
    
    func setProgress(_ p: Double) {
        if p > 1 {
            longPressEnd()
            return
        }
        progressLayer.strokeEnd = CGFloat(p)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class WMAnmitionTimeView: UIView{
    
    
    var timeLabel = UILabel()
    var anmitiV = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        
        
        timeLabel.frame = CGRect(x: 45, y: 0, width: 85, height: 20)
        timeLabel.text = "00:00"
        timeLabel.textAlignment = .center
        timeLabel.textColor = .white
        self.addSubview(timeLabel)
        
        
        anmitiV.frame = CGRect(x: 43, y: 7, width: 5, height: 5)
        anmitiV.backgroundColor = .red
        anmitiV.layer.cornerRadius = 2.5
        self.addSubview(anmitiV)
        
        
    }
    
    public  func benginAnmition(){
        anmitiV.alpha = 1
        UIView.animate(withDuration: 1) {
            self.anmitiV.alpha = 0
        }completion: { flag in
            self.benginAnmition()
        }
         
    }
    
    public func endAnmition(){
        
        anmitiV.layer.removeAllAnimations()
        
    }
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    

}
