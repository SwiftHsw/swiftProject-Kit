//
//  WCDBUtil.swift
//  text
//
//  Created by 黄世文 on 2022/3/1.
//

import Foundation
import WCDBSwift
import PromiseKit


public let TABLENAME_sampleModel = "sampleModel"

class WCDBUtil{
    /// 单例
   static  let share = WCDBUtil()
    /// 数据库
    private(set) var database : Database?
    /// 数据库名称,每个用户一个数据库
    private var dbName : String{
        return "getAppModelUserID10086" + ".sqlite"
    }
    
    private init() {}
    
    
    //链接数据库
    public func connectDataBase(){
        if database != nil{
            closeDataBase()
        }
         
        //拼接文件路径
        guard let fileURL = try? FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(dbName) else { return }
        
        SLog("数据库路径：\(fileURL.path)")
        //初始化 数据库路径
        database = Database(withFileURL: fileURL)
        
        //创建数据库表
        creatTables()
        
    }
    //关闭数据库
    public func closeDataBase(){
          database?.close()
    }
    
    
    //创建表
    private func creatTables(){
        
      try? database?.create(table: TABLENAME_sampleModel, of: sampleModel.self)
   
           
    }
    
    
    
    
}

extension WCDBUtil{
    
    //新增一组数组数据到数据库
    /// objcets 插入的数组
    /// tableName 表名称
    func insertObject<T: TableCodable>(_ objcets:[T], tableName:String){
        try? database?.insert(objects: objcets, intoTable: tableName)
    }
 
    
    /// 删
    func deleteObject(
        _ tableName: String,
        where condition: Condition? = nil,
        orderBy orderList: [OrderBy]? = nil,
        limit: Limit? = nil,
        offset: Offset? = nil)
    {
        try? database?.delete(fromTable: tableName, where: condition, orderBy: orderList, limit: limit, offset: offset)
    }
    
    //查询表中所有数据
    func getObjects<T: TableCodable>(_ tableName:String,
                                     where condition:Condition? = nil,
                                     orderBy orderList:[OrderBy]? = nil,
                                     limit:Limit? = nil,
                                     offset:Offset? = nil) -> [T]?
    {
        let objects : [T]? =  try? database?.getObjects(fromTable: tableName, where: condition, orderBy: orderList, limit: limit, offset: offset)
        return objects
    }
    
  
}

 
