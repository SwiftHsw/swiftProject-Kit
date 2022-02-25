//
//  CustomGifRefreshHeader.swift
//  text
//
//  Created by 黄世文 on 2022/2/25.
//

import UIKit
import MJRefresh

class CustomGifRefreshHeader: MJRefreshGifHeader {
 
    override func placeSubviews() {
        super.placeSubviews()
        
        self.gifView?.contentMode = .scaleAspectFill
        self.gifView?.frame = CGRect(x: (self.mj_w - 30) / 2, y: 18, width: 30, height: 30)
    }
    
    override func setImages(_ images: [Any], duration: TimeInterval, for state: MJRefreshState) {
        super.setImages(images, duration: duration, for: state)
        
        self.mj_h = 50
    }

}
