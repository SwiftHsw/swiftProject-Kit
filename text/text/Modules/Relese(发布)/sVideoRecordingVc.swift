//
//  sVideoRecordingVc.swift
//  text
//
//  Created by 黄世文 on 2022/3/10.
//

import UIKit
import AVKit
import AVFoundation
import TZImagePickerController
import Photos
import HEPhotoPicker
import PromiseKit
import SwiftUI

class sVideoRecordingVc: SBaseVc{
  
    @IBOutlet weak var linView: UIView!
    @IBOutlet weak var bottomBar: UIView!
    
    @IBOutlet weak var selectVideoBtn: UIButton!
    @IBOutlet weak var takeBtn: UIButton!
    
    lazy var mainScolleView : UIScrollView = {
        let main  = UIScrollView.init()
        main.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        main.backgroundColor = .black
        main.isPagingEnabled = true
        main.bounces = false
        main.delegate = self
        main.showsHorizontalScrollIndicator = false
        main.contentSize = CGSize(width: CGFloat(2*ScreenWidth), height: 0)
        return main
    }()
    
    var pickerVc : HEPhotoPickerViewController!

    //相册选择回调
    var selectVideoSucceeBlock : BlockWithParameters<([HEPhotoAsset],[UIImage])>?
    //拍摄选择回调
    var carmeVideoSucceeBlock : BlockWithParameters<(String,UIImage)>?
    
    
    var selectedModel = [HEPhotoAsset]()
   
    var visibleImages = [UIImage](){
        didSet{
 
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.isHiddenNavBar = true
        view.backgroundColor = .black
        
        view.addSubview(mainScolleView)
        
        addChildView()
        
        setupCostomNavBar()
        
        view.bringSubviewToFront(bottomBar)
        
        NotificationCenter.default.addObserver(self, selector: #selector(successVideoPaly), name: NSNotification.Name("录制完成"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(benginPlay), name: NSNotification.Name("开始录制"), object: nil)
        
    }
    
    private   func addChildView(){
        ///视频拍摄
        let vc = WMCameraViewController()
        //最长录制5分钟视频
        vc.videoMaxLength = 60*5
        vc.inputType = .video
        vc.completeBlock = { url, type in
            print("url == \(url)")
            let image =  WMVideoTools.getVideoThumbnail(filePath: url)
            
            guard  url != nil, image != nil else{
                print("拍摄失败了")
                return
            }
            
             self.carmeVideoSucceeBlock?((url,image))
           
 
        }
        vc.view.backgroundColor = .black
        vc.view.frame = CGRect(x: 0, y: 0, width: CGFloat(ScreenWidth), height: CGFloat(ScreenHeight))
        mainScolleView.addSubview(vc.view)
        self.addChild(vc)
   
        ///本地相册选择
        let options = HEPickerOptions.init()
        options.ascendingOfCreationDateSort =  true
        options.singlePicture = false
        options.singleVideo = false
        options.mediaType = .video
        options.defaultSelections = selectedModel
        options.maxCountOfVideo = 1
        pickerVc = HEPhotoPickerViewController.init(delegate: self, options: options)
        ///由于外部引用，重新设置view、和集合视图的坐标
        pickerVc.view.frame = CGRect(x: CGFloat(ScreenWidth), y:StatusBarAndNavigationBarHeight, width: CGFloat(ScreenWidth), height: CGFloat(ScreenHeight-StatusBarAndNavigationBarHeight-100))
        mainScolleView.addSubview(pickerVc.view)
        for subs in pickerVc.view.subviews{
            if subs is UICollectionView {
                //设置collectionView的真实大小
                subs.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: CGFloat(ScreenHeight-StatusBarAndNavigationBarHeight-100))
                subs.backgroundColor = .black
            }
        }
        pickerVc.view.backgroundColor = .black
        self.addChild(pickerVc)
 
    }
    
    
    private func setupCostomNavBar(){
        
        ///自定义导航栏，只在视频选择界面显示
        let navView = UIView()
        navView.frame = CGRect(x: pickerVc.view.wm_x, y: 0, width: ScreenWidth, height: StatusBarAndNavigationBarHeight)
        navView.backgroundColor = .black
     
        //关闭
        let closeBtn = UIButton()
        closeBtn.frame = CGRect(x: 15, y: navView.wm_height - 38 , width: 30, height: 30)
        closeBtn.setBackgroundImage(UIImage.wm_imageWithName_WMCameraResource(named: "arrow_down"), for: .normal)
        closeBtn.addTarget(self, action: #selector(dismissVc), for: .touchUpInside)
        navView.addSubview(closeBtn)
        
        //标题
        let allTitle = UILabel()
        allTitle.frame = CGRect(x: (navView.wm_width - 100)/2, y:0  , width: 100, height: 20)
        allTitle.textColor = .white
        allTitle.text = "All Video"
        allTitle.textAlignment = .center
        navView.addSubview(allTitle)
        allTitle.wm_centerY = closeBtn.wm_centerY
        
        
        //确认
        let compleBtn = UIButton()
        compleBtn.frame = CGRect(x: navView.wm_width - 50, y: navView.wm_height - 38 , width: 40, height: 30)
        compleBtn.setTitle("完成", for: .normal)
        compleBtn.setTitleColor(.white, for: .normal)
        compleBtn.addTarget(self, action: #selector(compleBtnAction), for: .touchUpInside)
        navView.addSubview(compleBtn)
        
        mainScolleView.addSubview(navView)
        //插入在最上面 才可点击
        mainScolleView.bringSubviewToFront(navView)
    }
    
    @objc func dismissVc(){
        self.dismiss(animated: true, completion: nil)
    }
     
    @objc func compleBtnAction(){
        pickerVc?.nextBtnClick()
        print("从相册那边选择好了，到开始上传视频界面")
    }
    
    @objc func successVideoPaly(){
        self.bottomBar.isHidden = false
        mainScolleView.isUserInteractionEnabled = true
    }
    @objc func benginPlay(){
        self.bottomBar.isHidden = true
        mainScolleView.isUserInteractionEnabled = false
    }
     
    @IBAction func takeAction(_ sender: UIButton) {
        mainScolleView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        UIView.animate(withDuration: 0.5) {
            self.linView.wm_centerX = sender.wm_centerX
        }
    }
      
    @IBAction func sendVideoAction(_ sender: UIButton) {
        mainScolleView.setContentOffset(CGPoint(x: ScreenWidth, y: 0), animated: true)
        UIView.animate(withDuration: 0.5) {
            self.linView.wm_centerX = sender.wm_centerX
        }
    }
}

///底部动画
extension sVideoRecordingVc:UIScrollViewDelegate{
     
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = ScreenWidth
       let offsetX = scrollView.contentOffset.x
       let index = (offsetX/width)
        UIView.animate(withDuration: 0.5) {
            self.linView.wm_centerX = index == 0 ? self.takeBtn.wm_centerX : self.selectVideoBtn.wm_centerX
        }
         
    }
}

///相册选择完成回调
extension sVideoRecordingVc : HEPhotoPickerViewControllerDelegate{
    
    func pickerController(_ picker: UIViewController, didFinishPicking selectedImages: [UIImage],selectedModel:[HEPhotoAsset]) {
        // 实现多次累加选择时，需要把选中的模型保存起来，传给picker
        self.selectedModel = selectedModel
        self.visibleImages = selectedImages
        selectVideoSucceeBlock?((self.selectedModel,self.visibleImages))
    }
    func pickerControllerDidCancel(_ picker: UIViewController) {
        // 取消选择后的一些操作
    }
    
}
