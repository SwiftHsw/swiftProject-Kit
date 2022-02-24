//
//  ViewController.swift
//  text
//
//  Created by 黄世文 on 2022/2/22.
//

import UIKit
import Foundation
import SwiftUI
import WCDBSwift


class ViewController: UIViewController {
    
    @IBOutlet weak var allMoneyLable: UILabel!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var listTable: UITableView!
    
    @IBOutlet weak var welltColltion: UICollectionView!
    
    var isHiddenAction = false
    
    //声明block
    typealias BlockWithNone = () -> ()
    typealias dateBlock = (String,Int) -> ()
    
    typealias CustomBlock = (ViewController) ->()

    ///创建枚举
    enum NavBackBtnType: String {
        case white = "icon_back_white"
        case black = "icon_back_black"
    }
    
    var datePickBlock : dateBlock?
    
    //初始化一个bool
  var isHiddenNavBar = false
     
    //初始化一个type
    var btnType : NavBackBtnType {
        return .black
    }
    
    //初始化一个int 类型
   var index = 1
 

   var isImproWallet = false
  
    var isTrusteeshipWallet = false
     
    //初始化一个闭包属性
     var textBlock : BlockWithNone?
    
    //初始化一个数组 包 字符串
    let menus: [String] = ["11","22","33"]
    //可变数组的初始化
    var valMnemonics: [String] = []
    //可变的私有数组
    private var paths: [NSObject] = []
     
    //声明一个私有化 字符串
    private var address = ""
    
    //声明私有model接收
    private var lastModel: NSObject?
    
    var imageStrs: [String] = []
    
    //懒加载一个nodataView
    lazy var noDataView : UIImageView = {
        let Img = UIImageView()
        return Img
    }()
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
////        for循环view的子视图
//        let wordWitdh = (ScreenWidth - 48) / 3
//        let wordHeight : CGFloat = 56
//        for (i,subView) in view.subviews.enumerated(){
//            let x = CGFloat(i % 3) * wordWitdh
//            let y = CGFloat(i/3) * wordHeight
//            subView.frame = CGRect(x: x, y: y, width: wordWitdh, height: wordHeight)
//        }
//        //for循环0-10次
//        for _ in 0..<10 {
//            print("输出10次")
//        }
//
//        //.rawValue 取枚举里面的初始值
//
//        let whitespcesString = "    sffefsf   "
//        let whitNewtring   =   whitespcesString.trimmingCharacters(in: .whitespaces)
//        print("输出的除去多余空格的字符串 \(whitNewtring)")
//
//
//        if isImproWallet {
//            print("输入成功")
//        }else{
//
////            textBlock?()
//
//            showImageArr()
//
//            //可变的字典
//            var param : [String : Any] = [:]
//            param.updateValue("idStr", forKey: "id")
//
//            for _ in 0..<12 {
//                //for循环添加字符串
//                valMnemonics.append("")
//            }
//        }
        
 
        listTable.rowHeight = 80
        listTable.separatorColor = .clear
        welltColltion.reloadData()
        tableViewHeight.constant = 10*80
        
        
        //模拟请求接口
        
        InterfaceRequest.getUserInfo().done { model in
            
            SLog("============》成功")
            
        }.catch { error in
            
            SLog("============》失败")
            
        }.finally { [weak self] in
             
            SLog("结束")
        }
        
    }
    
    
    @IBAction func prentSeonVc(_ sender: Any) {
        
        let vc = secondViewC.fromStoryboard(name: "Main")
        vc.didselectBlock = { indexP in
            print("点击了\(indexP)")
        }
        vc.showPan(vc: self)
    }
    
    //开放模拟注册接口
    static public func registUser(UserModel: String) -> ([String : Any]){
        
        let parameters : [String : Any] = [
            "device" : UserModel,
            "s" : "24"
        ]
        
        return parameters
    }

    
    @IBAction func hiddenMoneyAction(_ sender: Any) {
        let btn = sender as? UIButton
        
        
        isHiddenAction = !isHiddenAction
        welltColltion.reloadData()
        
        //练习guard语法
        guard isHiddenAction else{
            SLog("此时应该否-未选中")
            btn?.setTitle("隐藏", for: .normal)
            self.allMoneyLable.text = "¥ 1000000000.00"
            return
        }
        btn?.setTitle("查看", for: .normal)
        self.allMoneyLable.text = "******"
        SLog("此时应该选中")
    }
    
    func showImageArr(){
        //初始化一个数组 装 NSObject
         var imags = [String]()
        for imageStr in imageStrs {
            let photo = imageStr
            imags.append(photo)
            
        }
        
    }
}


extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withType: HomeColletionCell.self, for: indexPath)
//        cell.contentView.backgroundColor = UIColor.randomColor()
        cell.moneyLable.text = isHiddenAction ? "******": "¥ 0.02"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 224, height: 127)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let btn = UIButton.init()
        prentSeonVc(btn)
    }
    
    
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableCell.className, for: indexPath)
        cell.selectionStyle = .none
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
     
    
    
}
