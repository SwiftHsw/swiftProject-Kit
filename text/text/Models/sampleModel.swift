//
//  sampleModel.swift
//  text
//
//  Created by 黄世文 on 2022/3/1.
//

import UIKit
import WCDBSwift

class sampleModel: BaseModel, TableCodable {
 
        var amount: String = "" // 金额
        var chainShortName: String = "" // 链类型简称
        var currencyShotName: String = "" // 币种简称
        var from: String = "" // 付款地址
        var id: String = "" // id
        var status = 0 // 状态(0失败, 1成功)
        var timestamp: TimeInterval = 0 // 成功时间
        var to: String = "" // 收款地址
        var type: Int = 0 // 类型(1收款, 2转账)
        // 本地使用
        var isRead: Bool = false
        
        enum CodingKeys: String, CodingTableKey {
            
            typealias Root = sampleModel
            static let objectRelationalMapping = TableBinding(CodingKeys.self)
            case amount
            case chainShortName
            case currencyShotName
            case from = "c_from" // 表from字段映射为 c_from
            case id
            case status
            case timestamp
            case to = "c_to" // 表to字段映射为 c_to
            case type
            case isRead
            
            static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
                return [
                    id: ColumnConstraintBinding(isPrimary: true, isUnique: true)
                ]
            }
        }
    
    
    //重载构造函数
    ///convenience ：便利，使用convenience 修饰的构造函数叫做 便利构造函数
    ///便利构造函数通常用于对系统的类进行构造函数的扩充时 使用。
    ///特点：
    ///1.构造函数通常都是写在 extension 里面
    ///2.init 前面需要加载 convenience
    ///3.便利构造函数中需要明确调用self.init() 才能使用当前属性
    ///
    convenience init(amount:String,from:String,type:Int){
        self.init()
        self.amount = amount
        self.from = from
        self.type = type
    }

//    override init(){
//        super.init()
//
//    }
    
//    required init() {
//        fatalError("init() has not been implemented")
//    }
  }

 
class homeGuideView : UIView{
    
    
    //初始化方法
    
    //只重写初始化一个frame
    override convenience init(frame:CGRect) {
    self.init(frame: frame)
    }
    
    //构造便利函数init
    init(frame:CGRect = UIScreen.main.bounds,scabRect:CGRect,assetRact:CGRect){
        super.init(frame: frame)
    }
    
    //必要初始化器，这种情况一般会出现在继承了遵守NSCoding protocol的类，比如UIView系列的类、UIViewController系列的类。
//    为什么一定要添加：
//    这是NSCoding protocol定义的，遵守了NSCoding protoaol的所有类必须继承。只是有的情况会隐式继承，而有的情况下需要显示实现。
//
//    什么情况下要显示添加：
//    当我们在子类定义了指定初始化器(包括自定义和重写父类指定初始化器)，那么必须显示实现required init?(coder aDecoder: NSCoder)，而其他情况下则会隐式继承，我们可以不用理会。
//
//    什么情况下会调用：
//    当我们使用storyboard实现界面的时候，程序会调用这个初始化器。

//    在obj-c中可以通过下面代码实现
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
            ////    注意要去掉fatalError，fatalError的意思是无条件停止执行并打印。 写了有些时候 会崩溃
//        fatalError("init(coder:) has not been implemented")
    }
    
    
}
