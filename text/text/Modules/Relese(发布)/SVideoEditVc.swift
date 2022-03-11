//
//  SVideoEditVc.swift
//  text
//
//  Created by 黄世文 on 2022/3/11.
//

import UIKit
import HEPhotoPicker
import Photos
import AVKit

class SVideoEditVc: SBaseVc {
    
    var playerLayer: AVPlayerLayer?
    
    var representedAssetIdentifier : String!
    ///视频首帧
    @IBOutlet weak var videoFistImage: UIImageView!
     
    var model : HEPhotoAsset!
    
    ///外部传入视频model数组
    public  var selectedModels : [HEPhotoAsset]!{
        didSet{
            let mediaModel = selectedModels!.first
            model = mediaModel
        }
    }
    
    ///拍摄的本地路径、可以直接播放
    public var locationPath : String = ""
    ///拍摄的本地路径取出来的第一桢
    public var fistIamge : UIImage?  
     
    ///内容输入框
    @IBOutlet weak var desContenTextF: UITextField!
    ///标题输入框
    @IBOutlet weak var titleTextF: UITextField!
    
    ///提示字符View
    @IBOutlet weak var tipView: UIView!
    ///隐藏时候为0
    @IBOutlet weak var tipViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var navTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

         title = "Post video"
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "close", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancleButtonAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Post", style: UIBarButtonItem.Style.plain, target: self, action: #selector(publicBUttonAction))
        
        titleTextF.placeholderColor = UIColor.gray
        titleTextF.delegate = self
        desContenTextF.delegate = self
        tipView.isHidden = true
        tipViewHeight.constant = 0
        
   
        self.videoFistImage.contentMode = .scaleAspectFill
        self.videoFistImage.backgroundColor = .black
        if (model != nil){
            let scale : CGFloat = 1.5
            //获取首贞图片
            self.representedAssetIdentifier = model?.asset.localIdentifier
            let   thumbnailSize = CGSize(width: ScreenWidth * scale, height: ScreenHeight  * scale )
            HETool.heRequestImage(for: model!.asset,
                                                  targetSize:thumbnailSize,
                                                  contentMode: .aspectFill) { (image, nil) in
                    DispatchQueue.main.async {
                            self.videoFistImage.image = image
                    }
            }
        }else{
            
            videoFistImage.image = fistIamge
           print("拍摄那边过来")
             
        }

    }

    
    override func loadView() {
        super.loadView()
        Bundle.main.loadNibNamed(self.className, owner: self, options: nil)
        navTop.constant = StatusBarAndNavigationBarHeight
    }
    

    
    @objc func cancleButtonAction(){
          
        guard  titleTextF.text?.count == 0 else {
             
            let alertView = UIAlertController.init(title: "提示", message: "还有未保存的内容，确定退出发布吗？", preferredStyle: .alert)

                let alert = UIAlertAction.init(title: "确定", style: .destructive) { (UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                }
                let cancleAlert = UIAlertAction.init(title: "取消", style: .cancel) { (UIAlertAction) in
                    
                    print("点击取消按钮")
                }
                alertView.addAction(cancleAlert)

                alertView.addAction(alert);

            self.present(alertView, animated: true, completion: nil)
            
            
            return
        }
        
         dismiss(animated: true, completion: nil)
    }
    
    @objc func publicBUttonAction(){
        
     
        guard titleTextF.text?.count ?? 0 >= 5 else {
        print("字符不够")
            tipView.isHidden = false
            tipViewHeight.constant = 40
          return
        }
        
        
         
        
        
        if locationPath.count > 0 {
            //直接把改路径上传
            
        }else{
            PHCachingImageManager().requestAVAsset(forVideo: model.asset, options:nil, resultHandler: { (asset, audioMix, info)in
                print("正在处理...")
                guard  let avAsset = asset as? AVURLAsset else {return}
                WMVideoTools.wm_compressVideoWithQuality(presetName: "AVAssetExportPresetHighestQuality", inputURL: avAsset.url) { outputUrl in
                    print("处理完成...上传中")
                    print("压缩后的路径即上传路径===\(outputUrl?.path)")
                    print("上传成功得到路径")
                    print("请求接口，传入视频线上路径")
                }
            })
        }
      
    }
    ///视频本地播放
    @IBAction func playAction(_ sender: UIButton) {
        if locationPath.count > 0 {
            //拍摄进来的直接播放本地
            let player = AVPlayer(url:URL(fileURLWithPath: locationPath))
                let  playerViewController = AVPlayerViewController()
                playerViewController.player = player
            self.present(playerViewController, animated: true)
            
        }else{
            //相册选择的直接播放本地，上传再压缩
            play(asset: model.asset, sender:sender)
        }
       
    }
    
    func play(asset:PHAsset, sender:UIButton) {
        
        PHCachingImageManager().requestAVAsset(forVideo: asset, options:nil, resultHandler: { (asset, audioMix, info)in
            guard  let avAsset = asset as? AVURLAsset else {return}
            print(avAsset.url)
            DispatchQueue.main.async {
                print("点击播放的是本地路径===\(avAsset.url)")
                let player = AVPlayer(url:avAsset.url )
                    let  playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                self.present(playerViewController, animated: true)
            }
        })
    }
}
 
extension SVideoEditVc: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == desContenTextF{
            let count = titleTextF.text?.count ?? 0
            if count < 5{
                tipView.isHidden = false
                tipViewHeight.constant = 40
            }
        }else{
            tipView.isHidden = true
            tipViewHeight.constant = 0
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing\(String(describing: textField.text))")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
              if textField == titleTextF {
                  tipView.isHidden = true
                  tipViewHeight.constant = 0
                return updatedText.count <= 200
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

