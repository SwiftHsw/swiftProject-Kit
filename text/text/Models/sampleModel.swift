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
    }

 
