//
//  AlertVC.swift
//  Gregarious
//
//  Created by Apple on 2021/3/25.
//

import UIKit
import HWPanModal

class AlertVC: UIViewController {
    typealias BlockWithNone = () -> ()
    /// 取消回调
    var cancelBlock: BlockWithNone?
    /// 确定回调
    var completeBlock: BlockWithNone?
    /// 隐藏动画结束后回调 
    var hideAnimateEndBlock: BlockWithNone?
    
    /// 蒙层按钮
    lazy var blankBtn: UIButton = {
        let btn = UIButton(frame: self.view.bounds)
        btn.addTarget(self, action: #selector(blankBtnClick), for: .touchUpInside)
        return btn
    }()
    
    /// 点击蒙层是否可以使视图消失
    var isClickBlankDisappear: Bool = false {
        didSet {
            if isClickBlankDisappear {
                self.view.addSubview(blankBtn)
                self.view.sendSubviewToBack(blankBtn)
            }
        }
    }
    
    /// 显示视图
    func show() {
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .custom
//        CommonUtil.getCurrentVC()?.present(self, animated: true, completion: nil)
    }
    
    /// 显示视图
    func showPan(vc: UIViewController) {
        vc.presentPanModal(self, completion: nil)
    }
    
    /// 隐藏视图
    func hide() {
        self.dismiss(animated: true) {
            self.hideAnimateEndBlock?()
        }
    }
    
    @objc func blankBtnClick() {
        hide()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    deinit {
        print("\(self.className) deinit")
    }
    
}
