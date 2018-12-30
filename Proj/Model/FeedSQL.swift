//
//  FeedSQL.swift
//
//  Copyright © 2018 All rights reserved.
//
import Foundation

extension Feed{
    
    static func createTable(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS Feeds (FEED_ID TEXT PRIMARY KEY, USENAME TEXT, LIKES TEXT, TEXTFEED TEXT)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    static func drop(database: OpaquePointer?)  {
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "DROP TABLE Feeds;", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return
        }
    }
    
    static func getAll(database: OpaquePointer?)->[Feed]{
        var sqlite3_stmt: OpaquePointer? = nil
        var data = [Feed]()
        if (sqlite3_prepare_v2(database,"SELECT * from Feeds;",-1,&sqlite3_stmt,nil)
            == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let id = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                let username = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                let likes = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                let text = String(cString:sqlite3_column_text(sqlite3_stmt,3)!)
                data.append(Feed(_id: id, _username: username, _likes: likes, _text: text))
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return data
    }
    
    static func addNew(database: OpaquePointer?, feed:Feed){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO Feeds(FEED_ID, USERNAME, LIKES, TEXTFEED) VALUES (?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            let id = feed.id.cString(using: .utf8)
            let username = feed.username.cString(using: .utf8)
            let likes = feed.likes.cString(using: .utf8)
            let text = feed.text.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, username,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, likes,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, text,-1,nil);
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func get(database: OpaquePointer?, byId:String)->Feed?{
        return nil;
    }
    
    static func getLastUpdateDate(database: OpaquePointer?)->Double{
        return LastUpdateDates.get(database: database, tabeName: "students")
    }
    
    static func setLastUpdateDate(database: OpaquePointer?, date:Double){
        LastUpdateDates.set(database: database, tabeName: "students", date: date);
    }
}
