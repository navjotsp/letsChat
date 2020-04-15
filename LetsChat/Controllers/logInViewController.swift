//
//  ViewController.swift
//  LetsChat
//
//  Created by Ongraph on 29/11/17.
//  Copyright © 2017 Gulmohar Inc. All rights reserved.
//

import UIKit

var myUserId = ""

class logInViewController: UIViewController, xmppConnectionDelegate {
    
    @IBOutlet weak var userIDTxtFld: UITextField!
    
    @IBOutlet weak var passwrdTxtFld: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let previousUserId = UserDefaults.standard.getUserId(), let pass = UserDefaults.standard.getPass() {
            self.userIDTxtFld.text = previousUserId
            self.passwrdTxtFld.text = pass
            loginBtn.sendActions(for: .touchUpInside)
//        } else {
//            self.userIDTxtFld.text = "26661"
//            self.passwrdTxtFld.text = "26661"
        }
    }
    
    func gotXmppAuthorisation(value: Bool) {
        
        if value {
            if let userId = userIDTxtFld.text, let pass = passwrdTxtFld.text {
                
                if let previousUserId = UserDefaults.standard.getUserId(), previousUserId != userId {
                    sqliteManager.sharedInstance.clearAllData()
                }
                
                myUserId = userId
                UserDefaults.standard.setUserId(value: userId)
                UserDefaults.standard.setPass(value: pass)
                SVProgressHUD.dismiss()
                self.userIDTxtFld.text = ""
                self.passwrdTxtFld.text = ""
                self.performSegue(withIdentifier: "authenticationDone", sender: self)
            }
        } else {
            print("LogIn Fail")
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        self.userIDTxtFld.resignFirstResponder()
        self.passwrdTxtFld.resignFirstResponder()
        
        if identifier == "authenticationDone" {
            if let userId = userIDTxtFld.text, let pass = passwrdTxtFld.text {
                SVProgressHUD.show(withStatus: "Please wait...")
                xmppManager.sharedInstance.ConnectWithXmpp(JID: userId, password: pass, fromVC: self)
            }
            
            return false
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

