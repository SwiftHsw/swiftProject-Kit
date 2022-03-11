//
//  WMNavView.swift
//  text
//
//  Created by 黄世文 on 2022/3/10.
//

import UIKit
import AVFoundation


protocol WMNavViewDelegate : class{
    
    func cameraControlDidChangeCamera()
    func cameraControlDidExit()
    func flashLampBtnDidAction()
}


class WMNavView: UIView {

    //创建设备对象
    let device = AVCaptureDevice.default(for: .video)
    
    weak open var delegate: WMNavViewDelegate?
    
    //退出
    let exitButton = UIButton()
    
    //闪光灯
    let flashLampBtn = UIButton()
    
    //翻转摄像头
    let changeCameraButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
         
        
        
        exitButton.setImage(UIImage.wm_imageWithName_WMCameraResource(named: "arrow_down"), for: .normal)
        exitButton.frame = CGRect(x: 25, y: 5, width: 30, height: 30)
        exitButton.addTarget(self, action: #selector(exitButtonClick), for: .touchUpInside)
        self.addSubview(exitButton)
        
        
//        flashLampBtn.setImage(UIImage.wm_imageWithName_WMCameraResource(named: "arrow_down"), for: .normal)
        flashLampBtn.frame = CGRect(x: (self.wm_width - 30)/2, y: 5, width: 30, height: 30)
        flashLampBtn.addTarget(self, action: #selector(flashLampBtnClick(_ :)), for: .touchUpInside)
        flashLampBtn.backgroundColor = .yellow
        self.addSubview(flashLampBtn)
        
        
        
        changeCameraButton.setImage(UIImage.wm_imageWithName_WMCameraResource(named: "change_camera"), for: .normal)
        changeCameraButton.frame = CGRect(x: (self.wm_width - 55), y: 5, width: 30, height: 30)
        changeCameraButton.addTarget(self, action: #selector(changeCameraButtonClick), for: .touchUpInside)
        self.addSubview(changeCameraButton)
        
        
        
    }
    @objc func exitButtonClick() {
        guard let delegate = delegate else { return }
        delegate.cameraControlDidExit()
    }
    
    @objc func changeCameraButtonClick() {
        guard let delegate = delegate else { return }
        delegate.cameraControlDidChangeCamera()
    }
    
    
    @objc func flashLampBtnClick(_ sender:UIButton) {
        guard let delegate = delegate else { return }
        delegate.flashLampBtnDidAction()
        sender.isSelected = !sender.isSelected
        
        flashLight()
    }
    
    
    @objc func flashLight(){
        
        if device!.hasFlash && (device?.isTorchAvailable) != nil {
            
            //枷锁
            try? device?.lockForConfiguration()
            if device?.torchMode == .off{
                device?.torchMode = .on
            }else{
                device?.torchMode = .off
            }
            //解锁
            device?.unlockForConfiguration()
        }
        
        
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
