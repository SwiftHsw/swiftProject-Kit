//
//  ReleseVc.swift
//  text
//
//  Created by 黄世文 on 2022/3/9.
//

import UIKit
//import RZRichTextView
//import RZColorfulSwift

class ReleseVc: SBaseVc {
//    var textView: RZRichTextView?
    @IBOutlet weak var titleTextV: UITextField!
    @IBOutlet weak var textSuperView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isHiddenNavBar = true
        
//        /// 自定义一个option，也可以用init, 用init，可自己实现一些自定义的配置
//        let options = RZRichTextViewOptions.shared
//        /// 因为大部分字体不支持中文斜体，所以如果要让斜体生效，就自己选一个支持中文斜体的字体
//        options.obliqueFont = UIFont.init(name: "XinYuGongHeXieSong-L-Light", size: 17) ?? .italicSystemFont(ofSize: 17) // 斜体
//        options.boldObliqueFont = .init(name: "XinYuGongHeXieSong-B-Bold", size: 17) ?? .boldSystemFont(ofSize: 17)  // 粗斜体
//        /// 对要插入的图片进行处理，比如加水印等等
//        options.willInsetImage = { image in
//            return image
//        }
//        /// 插入了一个图片或视频，这里返回附件
//        options.didInsetAttachment = { attahcment in
////            attahcment.image
////            attahcment.asset
//            // 这是图片上的蒙层，可以添加一些进度控件、删除控件等等
//            attahcment.rtInfo.maskView.backgroundColor = UIColor.init(red: 1, green: 0, blue: 0, alpha: 0.3)
//            // 也可以根据需要绑定上传
//        }
//        /// 移除了附件
//        options.didRemovedAttachment = { attachments in
//            print("移除了\(attachments.description)")
//        }
//
//        let textView = RZRichTextView.init(frame: textSuperView.bounds, options: options)
//        textSuperView.addSubview(textView)
//
//        textView.backgroundColor = .lightGray
//        self.textView = textView
        
    }
   
    
    // 完成
    @objc func finish() {
//        // 得到的是RZRichTextAttachment,里边有相应的数据
//        guard let textView = textView else {
//            return
//        }
//        let allAttach = textView.rt.richTextAttachments()
//        // 得到所有的图片(没有视频)
//        let attachments = textView.attributedText.rz.images()
//
//        print(attachments)
//        /// 在RZColorfulSwift 中提供几种转换成html的方式，如果有视频，可能需要参照codingToHtmlWithImagesURLSIfHad来实现视频的标签
//        let html1 = textView.attributedText.rz.codingToCompleteHtml()
//        let html2 = textView.attributedText.rz.codingToCompleteHtmlByWeb()
//        let html3 = textView.attributedText.rz.codingToHtmlWithImagesURLSIfHad(urls: [])
//        let html4 = textView.attributedText.rz.codingToHtmlByWebWithImagesURLSIfHad(urls: [])
    }
}
