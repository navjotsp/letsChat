//
//  xmppManager.swift
//  AllChat
//
//  Created by Ongraph on 24/11/17.
//  Copyright © 2017 Ongraph Technologies. All rights reserved.
//



import UIKit

class xmppManager: NSObject {
    
    var xmppController : XMPPController!
    
    class var sharedInstance: xmppManager {
        struct Static {
            static let instance = xmppManager()
        }
        return Static.instance
    }
    
    //ConnectWithXMpp
    func
        ConnectWithXmpp(JID:String, password: String, fromVC:UIViewController) {
        try! xmppController = XMPPController(hostName: serverName,
                                             userJIDString: (JID + "@" + serverName),
                                             password: password)
        xmppController.authorisationDelegate = fromVC as? xmppConnectionDelegate
        xmppController.connect()
    }
}
