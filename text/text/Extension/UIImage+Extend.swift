//
//  UIImage+Extend.swift
//  Gregarious
//
//  Created by Apple on 2021/3/30.
//

import UIKit

extension UIImage {
    
    /// 返回一张纯颜色的图像
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        if size.width <= 0 || size.height <= 0 { return nil }
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        self.init(cgImage: image.cgImage!, scale: 2, orientation: .up)
    }
    
    /// 压缩图片,单位M
    func compress(max: Int = 3) -> Data? {
        var compression: CGFloat = 1
        let maxLength = max * 1024
        guard var data = self.jpegData(compressionQuality: compression) else { return nil }
        // 开始压缩
        while (data.count / 1024) > maxLength {
            compression -= 0.2
            if compression == 0 {
                break
            }
            guard let compressData = self.jpegData(compressionQuality: compression) else { return nil }
            data = compressData
        }
        return data
    }
    
    func caculateThumbnailImageSize(imageSize: CGSize) -> CGSize {
        //图片消息最小值为 100 X 100，最大值为 240 X 240
        // 重新梳理规则，如下：
        // 1、宽高任意一边小于 100 时，如：20 X 40 ，则取最小边，按比例放大到 100 进行显示，如最大边超过240 时，居中截取 240
        // 进行显示
        // 2、宽高都小于 240 时，大于 100 时，如：120 X 140 ，则取最长边，按比例放大到 240 进行显示
        // 3、宽高任意一边大于240时，分两种情况：
        //(1）如果宽高比没有超过 2.4，等比压缩，取长边 240 进行显示。
        //(2）如果宽高比超过 2.4，等比缩放（压缩或者放大），取短边 100，长边居中截取 240 进行显示。
        let imageMaxLength = 120 as CGFloat;
        let imageMinLength = 50 as CGFloat;
        if (imageSize.width == 0 || imageSize.height == 0) {
            return CGSize(width: imageMaxLength, height: imageMinLength)
        }
        var imageWidth = 0 as CGFloat;
        var imageHeight = 0 as CGFloat;
        
        if (imageSize.width < imageMinLength || imageSize.height < imageMinLength) {
            if (imageSize.width < imageSize.height) {
                imageWidth = imageMinLength;
                imageHeight = imageMinLength * imageSize.height / imageSize.width;
                if (imageHeight > imageMaxLength) {
                    imageHeight = imageMaxLength;
                }
            } else {
                imageHeight = imageMinLength;
                imageWidth = imageMinLength * imageSize.width / imageSize.height;
                if (imageWidth > imageMaxLength) {
                    imageWidth = imageMaxLength;
                }
            }
        } else if (imageSize.width < imageMaxLength && imageSize.height < imageMaxLength &&
                    imageSize.width >= imageMinLength && imageSize.height >= imageMinLength) {
            if (imageSize.width > imageSize.height) {
                imageWidth = imageMaxLength;
                imageHeight = imageMaxLength * imageSize.height / imageSize.width;
            } else {
                imageHeight = imageMaxLength;
                imageWidth = imageMaxLength * imageSize.width / imageSize.height;
            }
        } else if (imageSize.width >= imageMaxLength || imageSize.height >= imageMaxLength) {
            if (imageSize.width > imageSize.height) {
                if (imageSize.width / imageSize.height < imageMaxLength / imageMinLength) {
                    imageWidth = imageMaxLength;
                    imageHeight = imageMaxLength * imageSize.height / imageSize.width;
                } else {
                    imageHeight = imageMinLength;
                    imageWidth = imageMinLength * imageSize.width / imageSize.height;
                    if (imageWidth > imageMaxLength) {
                        imageWidth = imageMaxLength;
                    }
                }
            } else {
                if (imageSize.height / imageSize.width < imageMaxLength / imageMinLength) {
                    imageHeight = imageMaxLength;
                    imageWidth = imageMaxLength * imageSize.width / imageSize.height;
                } else {
                    imageWidth = imageMinLength;
                    imageHeight = imageMinLength * imageSize.height / imageSize.width;
                    if (imageHeight > imageMaxLength) {
                        imageHeight = imageMaxLength;
                    }
                }
            }
        }
        return CGSize(width: imageWidth, height: imageHeight)
    }
    
}
