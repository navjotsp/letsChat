//
//  XMPPController.swift
//  LetsChat
//
//  Created by Ongraph on 05/12/17.
//  Copyright © 2017 Gulmohar Inc. All rights reserved.
//

import Foundation
import XMPPFramework

enum XMPPControllerError: Error {
    case wrongUserJID
}

enum presenceType: String {
    case read
}

protocol xmppConnectionDelegate: class {
    func gotXmppAuthorisation(value:Bool)
}

class XMPPController: NSObject, XMPPStreamDelegate {
    
    var xmppStream: XMPPStream
    
    let hostName: String
    let userJID: XMPPJID
    let hostPort: UInt16
    let password: String
    
    
    weak var authorisationDelegate:xmppConnectionDelegate?
    
    // Configure for Stream
    
    init(hostName: String, userJIDString: String, hostPort: UInt16 = 5222, password: String) throws {
        guard let userJID = XMPPJID(string: userJIDString) else {
            throw XMPPControllerError.wrongUserJID
        }
        
        self.hostName = hostName
        self.userJID = userJID
        self.hostPort = hostPort
        self.password = password
        
        // Stream Configuration
        self.xmppStream = XMPPStream()
        self.xmppStream.hostName = hostName
        self.xmppStream.hostPort = hostPort
        self.xmppStream.startTLSPolicy = XMPPStreamStartTLSPolicy.allowed
        self.xmppStream.myJID = userJID
        
        super.init()
        
        self.xmppStream.addDelegate(self, delegateQueue: DispatchQueue.main)
        
        let xmppMessageDeliveryReceipts = XMPPMessageDeliveryReceipts(dispatchQueue: DispatchQueue.main)
        xmppMessageDeliveryReceipts.autoSendMessageDeliveryReceipts = true
        xmppMessageDeliveryReceipts.autoSendMessageDeliveryRequests = true
        xmppMessageDeliveryReceipts.activate(self.xmppStream)
    }
    
    //Method for connection
    func disconnect() {
        self.xmppStream.disconnectAfterSending()
    }
    
    func connect() {
        if !self.xmppStream.isDisconnected{
            return
        }
        
        try! self.xmppStream.connect(withTimeout: XMPPStreamTimeoutNone)
    }
    
    func sendMessage(message:String, toUserID:String) {
        
        let jid = XMPPJID(string: toUserID + "@" + serverName)
        let uuid = xmppStream.generateUUID
        
        let messageToSend:XMPPMessage = XMPPMessage(type: "chat", to: jid, elementID: uuid)
        messageToSend.addBody(message)
        messageToSend.addReceiptRequest()
        xmppStream.send(messageToSend)
        sqliteManager.sharedInstance.saveMsg(fromUser: myUserId, toUser: toUserID, msgBody: message, msgId: uuid)
    }
    
    func reSendMessage(data:chatDataModel) {
        
        let jid = XMPPJID(string: data.toUser! + "@" + serverName)
        let uuid = data.msgId
        let message = data.msgBody!
        let messageToSend:XMPPMessage = XMPPMessage(type: "chat", to: jid, elementID: uuid!)
        messageToSend.addBody(message)
        messageToSend.addReceiptRequest()
        xmppStream.send(messageToSend)
    }
    
    func xmppStream(_ sender: XMPPStream, didSend message: XMPPMessage) {
        if let id = message.elementID {
            sqliteManager.sharedInstance.updateIsSent(msgId: id)
        }
    }
    
    func xmppStream(_ sender: XMPPStream, didReceive message: XMPPMessage) {
        
        if message.hasReceiptResponse {
            if let id = message.receiptResponseID {
                sqliteManager.sharedInstance.updateIsDelivered(msgId: id)
            }
        }
        
        if let body = message.body, let msgId = message.elementID {
            
            let fromId = getIdFromJID(jid: message.from!.description)
            let toId = getIdFromJID(jid: message.to!.description)
            sqliteManager.sharedInstance.saveMsg(fromUser: fromId, toUser: toId, msgBody: body, msgId: msgId)
        }
    }
    
    func sendPresence(present:String, toUserID:String, msgId: String) {
        let presence = XMPPPresence()
        let status: DDXMLElement = DDXMLElement(name: "status")
        
        status.stringValue = present + msgId
        let jid = XMPPJID(string: toUserID + "@" + serverName)
        presence.addAttribute(withName: "to", stringValue: (jid?.full)!)
        presence.addChild(status)
        xmppStream.send(presence)
    }
    
    func xmppStream(_ sender: XMPPStream, didSend presence: XMPPPresence) {
        if presence.status != nil{
            if let status = presence.status {
                
                if status.contains(presenceType.read.rawValue), let msgId = status.components(separatedBy: presenceType.read.rawValue).last {
                    sqliteManager.sharedInstance.updateIsRead(msgId: msgId)
                }
            }
        }
    }
    
    func xmppStream(_ sender: XMPPStream, didReceive presence: XMPPPresence) {
        print("\n\n\n\n presesence aya re")
        print(presence)
        
        if presence.status != nil{
            if let status = presence.status {
                
                if status.contains(presenceType.read.rawValue), let msgId = status.components(separatedBy: presenceType.read.rawValue).last {
                    sqliteManager.sharedInstance.updateIsRead(msgId: msgId)
                }                
            }
        }
        print("\n\n\n\n")
    }
    
    private func getIdFromJID(jid:String) -> String {
        let strArr = jid.components(separatedBy: "@")
        if strArr.count == 2, let id = strArr.first {
            return id
        }
        return ""
    }
    
    func xmppStreamDidConnect(_ stream: XMPPStream) {
        print("Stream: Connected")
        try! stream.authenticate(withPassword: self.password)
    }
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream) {
        self.xmppStream.send(XMPPPresence())
        print("Stream: Authenticated")
        authorisationDelegate?.gotXmppAuthorisation(value: true)
    }
    
    func xmppStream(_ sender: XMPPStream, didNotAuthenticate error: DDXMLElement) {
        print("Stream: Fail to Authenticate")
        authorisationDelegate?.gotXmppAuthorisation(value: false)
    }
}
