//
//  User_Manager_SQL.swift
//  Proj
//
//  Created by Darkidan on 30/12/2018.
//  Copyright © 2018 Darkidan. All rights reserved.
//

import Foundation

class User_Manager_SQL {
    var database: OpaquePointer? = nil
    
    init() {
        // initialize the DB
        let dbFileName = "feed.db"
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {
                print("Failed to open db file: \(path.absoluteString)")
                return
            }
            //dropTables()
            createTables()
        }
        
    }
    
    func createTables() {
        Feed.createTable(database: database)
        LastUpdateDates.createTable(database: database);
    }
    
    func dropTables(){
        Feed.drop(database: database)
        LastUpdateDates.drop(database: database)
    }
    
    
}





