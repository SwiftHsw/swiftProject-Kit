//
//  SBaseVc.swift
//  text
//
//  Created by 黄世文 on 2022/3/3.
//

import UIKit
import PromiseKit

class SBaseVc: UIViewController , BaseNavigationControllerDelegate {
    
    
    ///是否隐藏导航栏
    var isHiddenNavBar = false
    
    ///是否设置背景透明
    var isBackgroundClear = false
    
    ///返回按钮的颜色
    var backBtnType: NavBackBtnType{
        return .black
    }
    
    
    ///导航栏背景颜色
    var barTintColor : UIColor{
        return  .white
    }
    
    /// 导航栏按钮颜色
    var tintColor : UIColor{
        return Color18282D
    }
    
    /// 导航栏标题颜色
    var titleTineColor : UIColor{
        return Color18282D
    }
    ///暂无数据
    lazy var noDataView : NoDataView = {
         let noDataView = NoDataView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 0))
        return noDataView
    }()
    
    
    ///重写statusBar 相关
    override var preferredStatusBarStyle : UIStatusBarStyle{
        return .default
    }
    
    
    override func loadView() {
        super.loadView()
        //设置代理
        if let nav = self.navigationController as? BaseNavigationController{
            nav.baseDelegate = self
        }
    }
    
    func popAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = ColorF6FAFD
        setupViews()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //设置导航栏配置
        setNavConfig()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //关闭所有键盘
        view.endEditing(true)
        //设置导航栏配置
        setNavConfig()
    }
    
    // MARK: - Override
    //提供给子类重写 专门负责UI
    func setupViews() {
        
    }
    
    func setNavConfig(){
        
        self.navigationController?.setNavigationBarHidden(isHiddenNavBar, animated: true)
        
        if isHiddenNavBar == false {
            let image = isBackgroundClear ? UIImage() : nil
            self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
              
            //设置默认颜色
             setBarTintColor(barTintColor)
             setTitleTintColor(titleTineColor)
             setTintColor(tintColor)
            
        }
        
        
    }
  
    // MARK: - Public
    // 显示占位图
    func showNoDataView(superView:UIView = AppWindow ,imageName:String = "",title:String = "暂无数据",topMargin:CGFloat = 0){
        
        noDataView.setupData(imageName: imageName, title: title)
        
        
        guard topMargin == 0 else {
            noDataView.frame = CGRect(x: 0, y: topMargin, width: noDataView.view_width, height: noDataView.view_height)
            superView.addSubview(noDataView)
            return
        }
        noDataView.center = superView.center
        superView.addSubview(noDataView)
    }
    
    // 隐藏占位图
     
    func hiddenNoDataView(){
        noDataView.removeFromSuperview()
    }
    
    
    /// 从导航控制器移除自己
    private func removeSelf(_ vc: UIViewController) {
        guard var vcs = self.navigationController?.viewControllers else { return }
        if let index = vcs.lastIndex(of: self) {
            vcs.remove(at: index)
        }
        // 添加新视图
        vcs.append(vc)
        self.navigationController?.setViewControllers(vcs, animated: true)
    }
    
    deinit{
        SLog("====>  \(self.className) deinit   <=====")
    }
}


///导航栏设置
extension SBaseVc {
     
    /// 设置导航栏按钮颜色
    func setTintColor(_ color: UIColor) {
        self.navigationController?.navigationBar.tintColor = color
    }
    
    
    /// 设置导航栏背景颜色
    func setBarTintColor(_ color: UIColor) {
        if #available(iOS 15.0, *) {
            self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = color
            self.navigationController?.navigationBar.standardAppearance.backgroundColor = color
        } else {
            let image = UIImage(color: color, size: CGSize(width: ScreenWidth, height: StatusBarAndNavigationBarHeight))
            self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        }
    }
    
    
    /// 设置导航栏标题颜色
    func setTitleTintColor(_ color: UIColor) {
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor : color,
            .font : UIFont.systemFont(ofSize: 18, weight: .medium)
        ]
    }
    
}


/// 转场方法

extension SBaseVc{
    
    func sPush(_ vc:SBaseVc, isRemoverSelf : Bool = false,vcBlock: BlockWithParameters<SBaseVc>? = nil){
      
        if isRemoverSelf{
            removeSelf(vc)
        }
      
        vcBlock?(vc)
         
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    ///跳转到指定界面，不返回VC
    func sPush(name:String,identifer:String,isRemoveSelf:Bool = false){
        
        //根据SB创建视图
        let vc = createVC(name: name, identifier: identifer)
        //是否移除自己
        guard !isRemoveSelf else{
            removeSelf(vc)
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
  
    ///跳转到指定界面，返回VC
    
    func sPush<T>(name:String,identifer:String,isRemoveSelf:Bool = false, vcBlock:BlockWithParameters<T>? = nil) {
        
        //根据SB创建视图
        let vc = createVC(name: name, identifier: identifer)
         
        //闭包传参
        if vc is T{
            vcBlock?(vc as! T)
        }
        
        //是否移除自己
        guard !isRemoveSelf else{
            removeSelf(vc)
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    /// 弹出界面, 不返回vc
    func sPresent(name: String, identifier: String, style: UIModalPresentationStyle = .fullScreen) {
        let vc =  createVC(name: name, identifier: identifier)
        vc.modalPresentationStyle = style
        self.present(vc, animated: true, completion: nil)
    }
    
    /// 弹出界面, 返回vc
    func sPresent<T>(name: String, identifier: String, style: UIModalPresentationStyle = .fullScreen, vcBlock: BlockWithParameters<T>? = nil) {
        let vc =  createVC(name: name, identifier: identifier)
        vc.modalPresentationStyle = style
        // ViewController创建完后回调, 可用于参数传递
        if vc is T {
            vcBlock?(vc as! T)
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    /// 返回到指定界面
    func popTo(type: AnyClass, animated: Bool = true) {
        guard let vcs = self.navigationController?.viewControllers else { return }
        for vc in vcs {
            if vc.classForCoder == type {
                self.navigationController?.popToViewController(vc, animated: animated)
                break
            }
        }
    }
    /// 返回到根视图
    func popToRootVC(animated: Bool = true) {
        self.navigationController?.popToRootViewController(animated: animated)
    }
    
    
    
    
    /// 创建Storyboard视图控制器
    public func createVC(name: String, identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        return vc
    }
    
    
}

