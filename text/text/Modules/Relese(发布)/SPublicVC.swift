//
//  SPublicVC.swift
//  text
//
//  Created by 黄世文 on 2022/3/10.
//

import UIKit
import TZImagePickerController
import PromiseKit
import Photos
 import AVKit

class SPublicVC: SBaseVc ,UICollectionViewDelegate,UICollectionViewDataSource{

    @IBOutlet weak var pleacHold: UILabel!
    @IBOutlet weak var contentTextV: UITextView!
    
    @IBOutlet weak var textviewHieghtCons: NSLayoutConstraint!
    @IBOutlet weak var collotionV: UICollectionView!
    
    let itemWH = CGFloat((ScreenWidth - 40)/3)
    lazy var layout:UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom:10, right: 10)
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 0.0
        layout.scrollDirection = .vertical
         
        return layout
        
    }()
    
    var dataArray : [UIImage] = []
 
    var defultImage = UIImage.init(named: "scan_photo.png")
    
    //是否是选择了一个视频
    var isVideo : Bool = false
    //记录视频选中的PHAsset
    var pathPHAssest : PHAsset?
    
    
    @IBOutlet weak var videoFistImage: UIImageView!
    
    
    @IBOutlet weak var videoView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Post moment"
    }
 
    
    override func setupViews(){
        super.setupViews()
        view.backgroundColor = .white
         collotionV.collectionViewLayout =  layout
         collotionV.register(uploadImageCell.self)
         collotionV.register(addImageCell.self)
        
        collotionV.backgroundColor = UIColor.white
        //添加默认的图
        dataArray.append(defultImage!)
      
        
        // 设置返回按钮图片
        let backImage = UIImage(named: backBtnType.rawValue)?.withRenderingMode(.alwaysOriginal)
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.setImage(backImage, for: .normal)
        button.addTarget(self, action: #selector(dismis), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 0)
        let backBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Post", style: .plain, target: self, action: #selector(publickAction))
        contentTextV.delegate = self
        
        videoView.isHidden = true
    }
    
    
    @objc  func publickAction(){
         
        let vc = createVC(name: "Main", identifier: sVideoRecordingVc.className) as! sVideoRecordingVc
        //相册回调
        vc.selectVideoSucceeBlock = {[weak self] tuple in
            after(seconds: 1).done {
               let editVc = SVideoEditVc()
                editVc.selectedModels = tuple.0
               let navVc = BaseNavigationController.init(rootViewController: editVc)
                navVc.modalPresentationStyle = .fullScreen
                self?.present(navVc, animated: true)
            }
        }
        //本地录制回调
        vc.carmeVideoSucceeBlock = { [weak self] tuple in
            after(seconds: 1).done {
               let editVc = SVideoEditVc()
                editVc.fistIamge = tuple.1
                editVc.locationPath = tuple.0
               let navVc = BaseNavigationController.init(rootViewController: editVc)
                navVc.modalPresentationStyle = .fullScreen
                self?.present(navVc, animated: true)
            }
        }
        
       let nav = BaseNavigationController.init(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
       self.present(nav, animated: true, completion: nil )
        
    }
    
    
    @objc  func dismis(){
        self.dismiss(animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let image =  self.dataArray[indexPath.row];
        if image == self.defultImage{
            let cell = collotionV.dequeueReusableCell(withType: addImageCell.self, for: indexPath)
            cell.addImageV.image = image
            return cell
            
        }else{
            let cell = collotionV.dequeueReusableCell(withType: uploadImageCell.self, for: indexPath)
            cell.imageV.image = image
            cell.imageV.contentMode = .scaleAspectFill
            cell.clearBtn.tag = indexPath.row
            cell.clearBtn.addTarget(self, action: #selector(didClearBtnAction(_ :)), for: .touchUpInside)
            return cell
        }
         
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard self.dataArray.count < 10 else {
            print("最多上传九张图")
            return
        }
        let image =  self.dataArray[indexPath.row];
        if image == self.defultImage{
            print("打开相册")
            let index = 10 - self.dataArray.count
            print(index)
            let vc = TZImagePickerController.init(maxImagesCount: index, delegate: nil)
            vc?.allowPickingImage = true
            ///默认情况下/如果有选择几张图后又进去选择，这时候只能选择图片
             vc?.allowPickingVideo = self.dataArray.count == 1
             
            vc?.allowTakeVideo = false
            vc?.allowTakePicture = false
            vc?.allowCrop = false
            vc?.modalPresentationStyle = .fullScreen
            vc?.didFinishPickingPhotosHandle = { (photos, assets, _) in
                self.isVideo = false
                self.videoView.isHidden = true
                self.collotionV.isHidden = false
                for s in photos!{
                    print(s)
                    self.dataArray.insert(s, at: 0)
                }
                 //最多9张的时候吧最后一张删除了
                if (self.dataArray.count == 10) {
                    self.dataArray.removeLast()
                }
                
                self.collotionV.reloadData()
                  
            }
            vc?.didFinishPickingVideoHandle = { (image, asset) in
                self.isVideo = true
                self.videoView.isHidden = false
                self.collotionV.isHidden = true
                if let fistImage = image{
                    self.videoFistImage.image = fistImage
                    self.pathPHAssest = asset
                }
            }
            self.present(vc!, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func playVideo(_ sender: Any) {
        
        
        PHCachingImageManager().requestAVAsset(forVideo: self.pathPHAssest!, options:nil, resultHandler: { (asset, audioMix, info)in
            guard  let avAsset = asset as? AVURLAsset else {return}
            print(avAsset.url)
            DispatchQueue.main.async {
                let player = AVPlayer(url:avAsset.url )
                    let  playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                self.present(playerViewController, animated: true)
            }
        })
        
//        PHCachingImageManager().requestAVAsset(forVideo: pathPHAssest, options:nil, resultHandler: { (asset, audioMix, info)in
////            print("正在处理...")
////            guard  let avAsset = asset as? AVURLAsset else {return}
////            WMVideoTools.wm_compressVideoWithQuality(presetName: "AVAssetExportPresetHighestQuality", inputURL: avAsset.url) { outputUrl in
////                print("处理完成...上传中")
////                print("压缩后的路径即上传路径===\(outputUrl?.path)")
////                print("上传成功得到路径")
////                print("请求接口，传入视频线上路径")
////            }
//                //播放
//        })
        
    }
    
    @IBAction func deleateAction(_ sender: Any) {
        
        self.pathPHAssest = nil
        self.isVideo = false
        self.videoView.isHidden = true
        self.collotionV.isHidden = false
        
    }
    
    
    
    @objc func didClearBtnAction(_ sender:UIButton){
        
        if self.dataArray.count == 9,!self.dataArray.contains(defultImage!){
            //已经有9张了 并且不存在这个图片，直接插入一个默认按钮到最后
            self.dataArray.insert(defultImage!, at: self.dataArray.count)
        }
        self.dataArray.remove(at: sender.tag)
        self.collotionV.reloadData()
    }
}
 

extension SPublicVC:UITextViewDelegate{
     
    
    func textViewDidChange(_ textView: UITextView) {
        
        pleacHold.isHidden = textView.text.count > 0
        
        //获取frame值
        let constrainSize=CGSize(width:CGFloat(ScreenWidth - 30),height:CGFloat(MAXFLOAT))
        let size = textView.sizeThatFits(constrainSize)
        
         var max : CGFloat = 100
        if size.height > 100, size.height<130{
            max = size.height
        }else if size.height > 130 {
            max = 130
        }
        textviewHieghtCons.constant = max;
        
    }
    
    
}
