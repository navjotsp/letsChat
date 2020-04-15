//
//  sqliteManager.swift
//  LetsChat
//
//  Created by Ongraph on 05/12/17.
//  Copyright © 2017 Gulmohar Inc. All rights reserved.
//

protocol refreshUIDelegate:class {
    func refreshUI(animated:Bool)
}

class sqliteManager: NSObject {
    
    let db = DBManager.init(databaseFilename: "chatDb.sqlite")
    weak var delegate : refreshUIDelegate?
    
    class var sharedInstance: sqliteManager {
        struct Static {
            static let instance = sqliteManager()
        }
        return Static.instance
    }
    
    /*
     CREATE TABLE "chat" ("id" INTEGER PRIMARY KEY  NOT NULL ,"fromUser" VARCHAR,"toUser" VARCHAR,"msgID" VARCHAR,"msgBody" VARCHAR,"msgTime" VARCHAR,"lastSeenTime" VARCHAR,"sent" BOOL DEFAULT (null) ,"delivered" BOOL DEFAULT (null) , "read" BOOL, "deliveryTime" VARCHAR, "readTime" VARCHAR)
     */
    
    func saveMsg(fromUser:String, toUser: String, msgBody:String, msgId:String) {
        
        let timeStamp = Date().timeIntervalSince1970
        
        let saveQuery = "INSERT INTO chat ('fromUser', 'toUser', 'msgBody', 'msgTime', 'msgID', 'lastSeenTime', 'sent', 'delivered', 'read', 'deliveryTime', 'readTime') VALUES ('\(fromUser)', '\(toUser)', '\(msgBody)', '\(timeStamp)', '\(msgId)', '', '\(NSNumber.init(value: false))', '\(NSNumber.init(value: false))', '\(NSNumber.init(value: false))', '', '')"
        db?.executeQuery(saveQuery)
        delegate?.refreshUI(animated: true)
    }
    
    func fetchRecentMsgUerIds() -> [String]{
        
        let fetchQuery = "select fromUser, toUser from chat where id in (select max(id) from chat group by fromUser, toUser) order by msgTime desc"
        if let results = db?.loadData(fromDB: fetchQuery)
        {
            var recentChatUserArr = [String]()
            for result in results {
                if let result = result as? NSArray, let fromUser = result[0] as? String, let toUser = result[1] as? String {
                    if fromUser == myUserId {
                        if !recentChatUserArr.contains(toUser) {
                            recentChatUserArr.append(toUser)
                        }
                    } else {
                        if !recentChatUserArr.contains(fromUser) {
                            recentChatUserArr.append(fromUser)
                        }
                    }
                }
            }
            return recentChatUserArr
        }
        return []
    }
    
    func fetchAllMsg(fromId:String, toId: String) -> [chatDataModel] {
        let fetchQuery = "SELECT * FROM chat WHERE (fromUser = '\(fromId)' AND toUser = '\(toId)') OR (fromUser = '\(toId)' AND toUser = '\(fromId)')"
        if let results = db?.loadData(fromDB: fetchQuery)
        {
            return chatDataModel.modelsFromDictionaryArray(results as NSArray)
        }
        return []
    }
    
    func fetchLastMsgInChat(fromId:String) -> chatDataModel? {
        let fetchQuery = "SELECT * FROM chat WHERE ((fromUser = '\(fromId)' AND toUser = '\(myUserId)') OR (fromUser = '\(myUserId)' AND toUser = '\(fromId)')) ORDER BY msgTime DESC LIMIT 1"
        if let results = db?.loadData(fromDB: fetchQuery), results.count > 0
        {
            return chatDataModel.modelsFromDictionaryArray(results as NSArray).first!
        }
        return nil
    }
    
    func fetchMessageDetails(msgId: String) -> chatDataModel? {
        let fetchQuery = "select * from chat where msgID = '\(msgId)'"
        if let results = db?.loadData(fromDB: fetchQuery), results.count > 0
        {
            return chatDataModel.modelsFromDictionaryArray(results as NSArray).first!
        }
        return nil
    }
    
    func updateIsSent(msgId : String) {
        
        let timeStamp = Date().timeIntervalSince1970
        
        let updateQuery = "UPDATE chat SET sent = '\(NSNumber.init(value: true))', msgTime = '\(timeStamp)' WHERE msgID = '\(msgId)'"
        db?.executeQuery(updateQuery)
        delegate?.refreshUI(animated: true)
    }
    
    func updateIsDelivered(msgId : String) {
        
        let timeStamp = Date().timeIntervalSince1970
        
        let updateQuery = "UPDATE chat SET delivered = '\(NSNumber.init(value: true))', deliveryTime = '\(timeStamp)' WHERE msgID = '\(msgId)'"
        db?.executeQuery(updateQuery)
        delegate?.refreshUI(animated: true)
    }
    
    func updateIsRead(msgId: String) {
        
        let timeStamp = Date().timeIntervalSince1970
        
        let updateQuery = "UPDATE chat SET read = '\(NSNumber.init(value: true))', readTime = '\(timeStamp)' WHERE msgID = '\(msgId)'"
        db?.executeQuery(updateQuery)
        delegate?.refreshUI(animated: true)
    }
    
    func clearAllData() {
        let deleteQuery = "DELETE FROM chat"
        db?.executeQuery(deleteQuery)
    }
}
