//
//  UIScrollView+Extend.swift
//  text
//
//  Created by 黄世文 on 2022/2/25.
//

import Foundation
import UIKit
import MJRefresh


public extension UIScrollView{
    
    
    /// 返回UIScrollView内容的区域，在iOS11以后需要用到adjustedContentInset，而在iOS11以前只需要用contentInset
    var sp_contentInset: UIEdgeInsets {
        if #available(iOS 11, *) { return self.adjustedContentInset }
        else { return self.contentInset }
    }
    
    /// 设置contentSize的width值
    var sp_contentWidth: CGFloat {
        set {
            var size = self.contentSize
            size.width = newValue
            self.contentSize = size
        }
        get { return self.contentSize.width }
    }
    
    /// 设置contentSize的height值
    var sp_contentHeight: CGFloat {
        set {
            var size = self.contentSize
            size.height = newValue
            self.contentSize = size
        }
        get { return self.contentSize.height }
    }
    
    /// 返回UIScrollView当前的可见区域
    var sp_visibleRect: CGRect {
        return CGRect(x: self.contentOffset.x, y: self.contentOffset.y, width: self.bounds.width, height: self.bounds.height)
    }
    
    /// 判断是否已经处于顶部(当UIScrollView内容不够多不可滚动时，也认为是在顶部)
    var sp_alreadyAtTop: Bool {
        if Int(self.contentOffset.y) == -Int(self.sp_contentInset.top) { return true }
        return false
    }
    
    /// 判断是否已经处于底部(当UIScrollView内容不够多不可滚动时，也认为是在底部)
    var sp_alreadyAtBottom: Bool {
        if !self.sp_canScroll { return true }
        if Int(self.contentOffset.y) == Int(self.contentSize.height + self.sp_contentInset.bottom - self.bounds.height) { return true }
        return false
    }
    
    /// 判断scrollView内容是否足够滚动
    var sp_canScroll: Bool {
        if self.bounds.width <= 0 || self.bounds.height <= 0 { return false }
        let canVerticalScroll = self.contentSize.height + (self.sp_contentInset.top + self.sp_contentInset.bottom) > self.bounds.height
        let canHorizontalScoll = self.contentSize.width + (self.sp_contentInset.left + self.sp_contentInset.right) > self.bounds.width
        return canVerticalScroll || canHorizontalScoll
    }
    
    /// 返回ScrollView的截图，不是当前屏幕的尺寸，而是contentSize的尺寸
    var sp_snapshotScrollImage: UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.contentSize, self.isOpaque, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        let previousFrame = self.frame
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.contentSize.width, height: self.contentSize.height)
        self.layer.render(in: context)
        let snap = UIGraphicsGetImageFromCurrentImageContext()
        self.frame = previousFrame
        return snap
    }
    
    /// 以动画的形式修改 contentInset
    /// - Parameters:
    ///   - contentInset: 要修改为的 contentInset
    ///   - animated: 是否要使用动画修改
    func sp_setContentInset(_ contentInset: UIEdgeInsets, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: [AnimationOptions(rawValue: 7), AnimationOptions(rawValue: 16)], animations: {
                self.contentInset = contentInset
            }, completion: nil)
        } else {
            self.contentInset = contentInset
        }
    }
    
}
public extension UIScrollView {
    
    /// 立即停止滚动，用于那种手指已经离开屏幕但列表还在滚动的情况
    func sp_stopDeceleratingIfNeeded() {
        if self.isDecelerating {
            self.setContentOffset(self.contentOffset, animated: false)
        }
    }
    
    /// 滚动到顶部
    func sp_scrollToTop(animated: Bool = true) {
        var off = self.contentOffset
        off.y = 0 - self.sp_contentInset.top
        self.setContentOffset(off, animated: animated)
    }
    
    /// 滚动到底部
    func sp_scrollToBottom(animated: Bool = true) {
        var off = self.contentOffset
        off.y = self.contentSize.height - self.bounds.height + self.sp_contentInset.bottom
        self.setContentOffset(off, animated: animated)
    }
    
    /// 滚动到左部
    func sp_scrollToLeft(animated: Bool = true) {
        var off = self.contentOffset
        off.x = 0 - self.sp_contentInset.left
        self.setContentOffset(off, animated: animated)
    }
    
    /// 滚动到右部
    func sp_scrollToRight(animated: Bool = true) {
        var off = self.contentOffset
        off.x = self.contentSize.width - self.bounds.width + self.sp_contentInset.right
        self.setContentOffset(off, animated: animated)
    }
}

// MARK: - 下拉刷新, 上拉加载更多

public let pageSize : Int = 20

extension UIScrollView {
    
    public func setupFoot(data: Array<Any>) {
        if data.count < pageSize {
            self.mj_footer?.endRefreshingWithNoMoreData()
        } else {
            self.mj_footer?.endRefreshing()
        }
    }
    
    class func addHeaderRefresh(refreshingBlock: @escaping BlockWithNone) -> MJRefreshNormalHeader {
        let header = MJRefreshNormalHeader(refreshingBlock: refreshingBlock)
        header.setTitle("下拉可以刷新", for: .idle)
        header.setTitle("松开立即刷新", for: .pulling)
        header.setTitle("正在刷新数据中...", for: .refreshing)
        header.stateLabel?.textColor = Color7C90B3
        header.stateLabel?.font = UIFont.PingFangSCRegular(size: 14)
        
        header.lastUpdatedTimeLabel?.isHidden = true
        return header
    }
    
    class func addCustomHeaderRefresh(refreshingBlock: @escaping BlockWithNone) -> CustomRefreshHeader {
        return CustomRefreshHeader(refreshingBlock: refreshingBlock)
    }
    
    class func addGifHeaderRefresh(refreshingBlock: @escaping BlockWithNone) -> CustomGifRefreshHeader {
        let header = CustomGifRefreshHeader(refreshingBlock: refreshingBlock)
        var images: [UIImage] = []
        for i in 0...64 {
            let suffix = i < 10 ? "0\(i)" : "\(i)"
            if let img = UIImage(named: "x_000\(suffix)") {
                images.append(img)
            }
        }
        header.lastUpdatedTimeLabel?.isHidden = true
        header.stateLabel?.isHidden = true
        header.setImages(images, duration: 2, for: .idle)
        header.setImages(images, duration: 2, for: .refreshing)
        return header
    }
    
    class func addFooterRefresh(refreshingBlock: @escaping BlockWithNone) -> MJRefreshAutoNormalFooter {
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: refreshingBlock)
        footer.setTitle("点击或上拉加载更多", for: .idle)
        footer.setTitle("松开立即加载更多", for: .pulling)
        footer.setTitle("正在加载更多的数据...", for: .refreshing)
        footer.setTitle("已加载全部内容", for: .noMoreData)
        
        footer.stateLabel?.textColor = UIColor("#BED0DE")
        footer.stateLabel?.font = UIFont.PingFangSCRegular(size: 14)
        
        return footer
    }
}
