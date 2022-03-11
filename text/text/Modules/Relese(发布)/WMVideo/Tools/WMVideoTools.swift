//
//  WMVideoTools.swift
//  AVPlayerExample
//
//  Created by wumeng on 2019/11/21.
//  Copyright © 2019 Wu Meng. All rights reserved.
//

import UIKit
import AVFoundation

class WMVideoTools: NSObject {
    /// compressVideo
    ///
    /// - Parameters:
    ///   - presetName: AVAssetExportPresetLowQuality
    ///   - inputURL: input url
    ///   - maxFileSize: byte  eg: mb = assetExport.fileLengthLimit = 3 * 1024 * 1024
    ///   - completionHandler: (URL)->())
    ///
    class func wm_compressVideoWithQuality(presetName: String, inputURL:URL,outputFileType:AVFileType = AVFileType.mp4,maxFileSize:Int64 = 0, completionHandler:@escaping (_ outputUrl: URL?) -> ()) {
//        let videoFilePath = NSTemporaryDirectory().appendingFormat("/compressVideo.mp4")
        
        let videoFilePath =  WMCameraFileTools.wm_createFileUrl("MP4")
        
        if FileManager.default.fileExists(atPath: videoFilePath) {
            do {
                try FileManager.default.removeItem(atPath: videoFilePath)
            } catch  {
                fatalError("Unable to delete file: \(error) : \(#function).")
            }
        }
        let savePathUrl =  URL(fileURLWithPath: videoFilePath)
        let sourceAsset = AVURLAsset(url: inputURL, options: nil)
        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: sourceAsset, presetName: presetName)!
        if maxFileSize > 0{
            assetExport.fileLengthLimit = maxFileSize
        }
        assetExport.outputFileType = outputFileType
        assetExport.outputURL = savePathUrl
        assetExport.shouldOptimizeForNetworkUse = true
        assetExport.exportAsynchronously { () -> Void in
            switch assetExport.status {
            case AVAssetExportSession.Status.completed:
                DispatchQueue.main.async {
                    print("successfully exported at \(savePathUrl.path))")
                    completionHandler(savePathUrl)
                }
            case  AVAssetExportSession.Status.failed:
                print("failed \(String(describing: assetExport.error))")
                DispatchQueue.main.async {
                    print("successfully exported at \(savePathUrl.path))")
                    completionHandler(nil)
                }
            case AVAssetExportSession.Status.cancelled:
                print("cancelled \(String(describing: assetExport.error))")
                completionHandler(nil)
            default:
                print("complete")
                completionHandler(nil)
            }
        }
        
    }
    
    /// get file size
    ///
    /// - Parameter url: url
    /// - Returns: Double file size
    class func wm_getFileSize(_ url:String) -> Double {
        if let fileData:Data = try? Data.init(contentsOf: URL.init(fileURLWithPath: url)) {
            let size = Double(fileData.count) / (1024.00 * 1024.00)
            return size
        }
        return 0.00
    }

    
    ///获取第一桢
    class func getVideoThumbnail(filePath:String) -> UIImage{
        let sourcUrl : URL = URL(fileURLWithPath: filePath)
        let asset = AVAsset.init(url: sourcUrl)
        let imageGenerator = AVAssetImageGenerator.init(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        let  time = CMTimeMakeWithSeconds(0, preferredTimescale: 600)
        
        
        var actuaTime:CMTime = CMTime.init(value: 0, timescale: 0)
        
        let imageRef:CGImage = try! imageGenerator.copyCGImage(at: time, actualTime: &actuaTime)
         let  currentImage = UIImage(cgImage: imageRef)
         return currentImage
    }
 
    
}
