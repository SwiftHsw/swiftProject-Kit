//
//  CostomModel.swift
//  text
//
//  Created by 黄世文 on 2022/2/24.
//

import UIKit
import KakaJSON

class CostomModel: BaseModel {
     
     
    var nickname = ""
    var age : Int = 0
    var sex = ""
    var userDict : [String:Any] = [:]
    var userModel : UserModel?
    
    
    //映射属性 userModel 为模型属性， user_Model 为后台json给的字段
    override func kj_modelKey(from property: Property) -> ModelPropertyKey {
        switch property.name{
        case "userModel": return "user_Model"
        default:return property.name
            
            /*
             驼峰 -> 下划线
             // 由于开发中可能经常遇到`驼峰`映射`下划线`的需求，KakaJSON已经内置了处理方法
                    // 直接调用字符串的underlineCased方法就可以从`驼峰`转为`下划线`
                    // `nickName` -> `nick_name`
                    return property.name.kj.underlineCased()
             */
            
            
            /*
             下划线 -> 驼峰
             // `nick_name` -> `nickName`
                    return property.name.kj.camelCased()
             */
            
        }
    }
}



class UserModel:BaseModel{
    
    var userName = ""
    var userAge : Int = 0
    var userSex = ""
    
}



class ArrayModel:BaseModel{
    
    var name:String = ""
    var price:String = ""
    
    
}

