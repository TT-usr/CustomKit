//
//  CMDBManager.swift
//  CMDBManager
//
//  Created by 姚天成 on 2022/4/18.
//

import Foundation
import WCDBSwift

class DBmanager {

    static let basePath =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/DB/wcdb.db"
    
    static let share = DBmanager.init()
    var db: Database?
    
    init() {
        db = createDB()
    }
    
    private func createDB(path: String = DBmanager.basePath) -> Database {
        return Database(withPath: path)
    }
    
    /// 数据库与表的初始化
    private func createTable<T: TableDecodable>(cls: T, tableName: String) {
        do {
           try db?.run(transaction: {
               createTable(table: tableName, modelType: T.self)
            })
         
        } catch let error {
            print("初始化数据库及ORM对应关系建立失败\(error.localizedDescription)")
        }
    }

    ///创建表
    private func createTable<T: TableDecodable>(table: String, modelType: T.Type) {
        do {
            try db?.create(table: table, of: modelType)
        }catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    /// 设置加密, 如需要在使用数据库之前设置
    public func setCipher(key: String) {
        db?.setCipher(key: key.data(using: .utf8))
    }
    
    ///插入数据
    public func inser<T: TableEncodable>(objects:[T], intoTable table: String){
        do {
            try db?.insert(objects: objects, intoTable: table)
        }catch let error {
            debugPrint(error.localizedDescription)
        }
    }

    ///修改
    public func update<T: TableEncodable>(fromTable table: String, on propertys:[PropertyConvertible], itemModel object:T,where condition: Condition? = nil){
        do {
            try db?.update(table: table, on: propertys, with: object, where: condition)
        } catch let error {
            debugPrint(" update obj error \(error.localizedDescription)")
        }
    }

    ///删除
    public func deleteFromDb(fromTable table: String, where condition: Condition? = nil){
        do {
            try db?.delete(fromTable: table, where:condition)
        } catch let error {
            debugPrint("delete error \(error.localizedDescription)")
        }
    }

    ///查询
    public func qurey<T: TableDecodable>(fromTable table: String, where condition: Condition? = nil, orderBy orderList:[OrderBy]? = nil) -> [T]? {
        do {
            let allObjects: [T] = try (db?.getObjects(fromTable: table, where:condition, orderBy:orderList))!
            debugPrint("\(allObjects)");
            return allObjects
        } catch let error {
            debugPrint("no data find \(error.localizedDescription)")
        }
        return nil
    }
    
    ///删除数据表
    func dropTable(table: String) -> Void {
        do {
            try db?.drop(table: table)
        } catch let error {
            debugPrint("drop table error \(error)")
        }
    }
    
    /// 删除所有与该数据库相关的文件
    func removeDbFile() -> Void {
        do {
            try db?.close(onClosed: {
                try db?.removeFiles()
            })
        } catch let error {
            debugPrint("not close db \(error)")
        }
        
    }
   
}
