//
//  QRAnmitionVc.swift
//  text
//
//  Created by 黄世文 on 2022/3/4.
//

import UIKit
import AVFoundation
import PromiseKit

class QRAnmitionVc: SBaseVc {

    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var anmitionImageTopCons: NSLayoutConstraint!
    @IBOutlet weak var tipsLable: UILabel!
    @IBOutlet weak var anmitionImage: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    
    //扫描成功的回调
    public var scanSuccessBlock: BlockWithParameters<String>?
    
    //摄像头会话
    private lazy var session : AVCaptureSession = {
        let session = AVCaptureSession()
         if session.canSetSessionPreset(.high){
             session.sessionPreset = .high
        }
        return session
    }()
    
    //背景蒙版遮罩层
    private lazy var backgroundView : UIView = {
        let bgView = UIView(frame: self.view.bounds)
        bgView.backgroundColor = .black.withAlphaComponent(0.1)
        return bgView
    }()
    
    override func loadView() {
        super.loadView()
        view.addSubview(backgroundView)
        // 调整到父视图的最下面
        self.view.sendSubviewToBack(backgroundView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        creatMaskLayer()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isHiddenNavBar = true
        view.backgroundColor = .black
        //超出部分不显示
        centerView.layer.masksToBounds = true
        beginAnmitionToView()
        checkCameraAuth()
        centerView.backgroundColor = .clear
    }
    
    
    //添加遮罩层 并且扣出一部分
    func creatMaskLayer(){
         
        let maskLayer = CAShapeLayer()
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd // 显示规则

        let basicPath = UIBezierPath(rect: view.frame) //底层
        let maskPath = UIBezierPath(roundedRect: centerView.frame, cornerRadius: 40) //自定义抠出来框框出来
        basicPath.append(maskPath)

        maskLayer.path = basicPath.cgPath
        backgroundView.layer.mask = maskLayer
        
        
    }
    //开始从下往下无限动画
    func beginAnmitionToView(){
        //无限循环的动画
        anmitionImage.transform = .identity
        
        UIView.animate(withDuration: 2) {
            self.anmitionImage.transform = CGAffineTransform(translationX: 0, y: self.centerView.view_height - self.anmitionImageTopCons.constant)
             
        }completion: { [weak self] (falg)  in
            self?.beginAnmitionToView()
        }
         
        
    }
    //检查相机权限
   private func checkCameraAuth(){
       let status = AVCaptureDevice.authorizationStatus(for: .video)
       switch status {
       case .notDetermined:
           AVCaptureDevice.requestAccess(for: .video) { [weak self] (agree) in
               agree ? self?.loadSession() : nil
           }
       case .restricted:
           print("无法访问摄像头")
       case .denied:
            print("请到手机系统的\n【设置】->【隐私】->【相册】\n开启相册的访问权限")
       case .authorized:
           self.loadSession()
       default:break
       }
         
    }
    
    //加载摄像头
    private func loadSession(){
        
        DispatchQueue.global().async {
             
            // 捕捉设备
            guard let device = AVCaptureDevice.default(for: .video) else {
                print("捕捉设备失败")
                return
            }
            //输入
            guard let input = try? AVCaptureDeviceInput(device: device) else {
                print("输入设备失败")
                return
            }
            //输出
            let output:AVCaptureMetadataOutput = {
               let output = AVCaptureMetadataOutput()
                output.connection(with: .metadata)
                return output
            }()
            
            //设置代理
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // 捕捉会话加入input和output
            if self.session.canAddInput(input) && self.session.canAddOutput(output) {
                self.session.addInput(input)
                self.session.addOutput(output)
                // 设置元数据处理类型(注意, 一定要将设置元数据处理类型的代码添加到  会话添加输出之后)
                output.metadataObjectTypes = [.ean13, .ean8, .upce, .code39, .code93, .code128, .code39Mod43, .qr]
            }
            DispatchQueue.main.async {
                
                // 指定预览层的捕捉会话
                let preLayer = AVCaptureVideoPreviewLayer(session: self.session)
                preLayer.videoGravity = .resizeAspectFill
                preLayer.frame = self.view.bounds
                
                // 添加预览图层
                self.view.layer.insertSublayer(preLayer, at: 0)
                
                // 启动会话
                self.session.startRunning()
                
                // 3秒后更改提示
                after(seconds: 3).done{ [weak self] in
                    self?.tipsLable.text = "请对准二维码，耐心等待"
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        popAction()
    }
     
    @IBAction func openSystemPhotosAction(_ sender: Any) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return
        }
        
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true, completion: nil)
    }
}


extension QRAnmitionVc : AVCaptureMetadataOutputObjectsDelegate{
    
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
         
        guard let codeObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let resultStr = codeObject.stringValue else {
            return
        }
        
        //在这里做相对应的处理
        print("=======================识别出来的数据\(resultStr)============")
        
    }
    
    
}
// MARK: - UIImagePickerControllerDelegate

extension QRAnmitionVc: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        picker.dismiss(animated: true) { [weak self] in
            
            guard let resultStr = self?.detectorQrCode(image: image) else {
                print("图片无效")
                return
            }
            SLog(resultStr)
            self?.scanSuccessBlock?(resultStr)
        }
    }
    
    /// 识别图片二维码
     public func detectorQrCode(image: UIImage) -> String? {
        
        guard let ciImage = CIImage(image: image) else {
            return nil
        }
        
        guard let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow]) else {
            return nil
        }
        
        let results = detector.features(in: ciImage)
        
        guard let code = results.first as? CIQRCodeFeature else { return nil }
        
        return code.messageString
    }
}


