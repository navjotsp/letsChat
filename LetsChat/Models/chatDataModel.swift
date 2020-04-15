//
//  chatDataModel.swift
//  LetsChat
//
//  Created by Ongraph on 05/12/17.
//  Copyright © 2017 Gulmohar Inc. All rights reserved.
//

import Foundation

open class chatDataModel {
    open var id : Int?
    open var fromUser : String?
    open var toUser : String?
    open var msgId : String?
    open var msgBody : String?
    open var msgTime : String?
    open var lastSeenTime : String?
    open var isSent : Bool?
    open var isDelivered : Bool?
    open var isReaded : Bool?
    open var deliveryTime : String?
    open var readTime : String?
    
    
    /*
     CREATE TABLE "chat" ("id" INTEGER PRIMARY KEY  NOT NULL ,"fromUser" VARCHAR,"toUser" VARCHAR,"msgID" VARCHAR,"msgBody" VARCHAR,"msgTime" VARCHAR,"lastSeenTime" VARCHAR,"sent" BOOL DEFAULT (null) ,"delivered" BOOL DEFAULT (null) , "read" BOOL, "deliveryTime" VARCHAR, "readTime" VARCHAR)
     
     */
    
    
    open class func modelsFromDictionaryArray(_ array:NSArray) -> [chatDataModel]
    {
        var models:[chatDataModel] = []
        for item in array
        {
            models.append(chatDataModel(dictionary: item as! NSArray)!)
        }
        return models
    }
    
    
    required public init?(dictionary: NSArray) {
        
        if let idStr = dictionary[0] as? String, let id = Int(idStr) {
            self.id = id
        }
        fromUser = dictionary[1] as? String
        toUser = dictionary[2] as? String
        msgId = dictionary[3] as? String
        msgBody = dictionary[4] as? String
        msgTime = dictionary[5] as? String
        lastSeenTime = dictionary[6] as? String
        
        if let sen = dictionary[7] as? NSNumber {
            isSent = Bool(sen)
        } else if let senStr = dictionary[7] as? String {
            isSent = NSString(string: senStr).boolValue
        } else {
            isSent = false
        }
        
        if let deliv = dictionary[8] as? NSNumber {
            isDelivered = Bool(deliv)
        } else if let delStr = dictionary[8] as? String {
            isDelivered = NSString(string: delStr).boolValue
        } else {
            isDelivered = false
        }
        
        if let read = dictionary[9] as? NSNumber {
            isReaded = Bool(read)
        } else if let readStr = dictionary[9] as? String {
            isReaded = NSString(string: readStr).boolValue
        } else {
            isReaded = false
        }
        
        deliveryTime = dictionary[10] as? String
        readTime = dictionary[11] as? String
    }
    
    open func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.id, forKey: kSqliteId)
        dictionary.setValue(self.fromUser, forKey: kSqliteFromUser)
        dictionary.setValue(self.toUser, forKey: kSqliteToUser)
        dictionary.setValue(self.msgId, forKey: kSqliteMsgId)
        dictionary.setValue(self.msgBody, forKey: kSqliteMsgBody)
        dictionary.setValue(self.msgTime, forKey: kSqliteMsgTime)
        dictionary.setValue(self.lastSeenTime, forKey: kSqliteLastSeenTime)
        dictionary.setValue(self.isDelivered, forKey: kSqliteIsDelivered)
        dictionary.setValue(self.isSent, forKey: kSqliteIsSent)
        dictionary.setValue(self.isReaded, forKey: kSqliteIsReaded)
        dictionary.setValue(self.deliveryTime, forKey: kSqliteDeliverytime)
        dictionary.setValue(self.readTime, forKey: kSqliteReadTime)
        
        return dictionary
    }
    
    
    
}
