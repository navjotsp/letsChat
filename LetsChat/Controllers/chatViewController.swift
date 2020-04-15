//
//  chatViewController.swift
//  LetsChat
//
//  Created by Ongraph on 05/12/17.
//  Copyright © 2017 Gulmohar Inc. All rights reserved.
//

import UIKit

class chatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, refreshUIDelegate, UITextViewDelegate {
    
    @IBOutlet weak var chatTv: UITableView!
    
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var msgTxtVw: UITextView!
    
    @IBOutlet weak var sendMsgBtn: UIButton!
    
    var chatArr = [chatDataModel]()
    
    var otherUserId:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.observeKeyboardNotification()
        
        self.setUpNavigationForBackBtn()
        
        self.setupMsgTxtView()
    }
    
    func setupMsgTxtView() {
        
        self.msgTxtVw.layer.cornerRadius = 16.5
        self.msgTxtVw.layer.borderColor = UIColor.lightText.cgColor
        self.msgTxtVw.layer.borderWidth = 1.0
        self.msgTxtVw.layer.masksToBounds = true
    }
    
    func setUpNavigationForBackBtn() {
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        self.navigationItem.title = otherUserId
    }
    
    @objc func back(sender: UIBarButtonItem) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sqliteManager.sharedInstance.delegate = self
        self.refreshUI(animated: false)
        self.sendMsgBtn.isEnabled = false
        self.msgTxtVw.layoutManager.allowsNonContiguousLayout = false
    }
    
    func refreshUI(animated:Bool) {
        self.chatArr = sqliteManager.sharedInstance.fetchAllMsg(fromId: otherUserId, toId: myUserId)
        self.chatTv.reloadData()
        self.scrollToBottom(animated: animated)
    }
    
    @IBAction func sendBtnTapped(_ sender: UIButton) {
        if let msg = self.msgTxtVw.text {
            
            if msg.count < 1 {
                self.sendMsgBtn.isEnabled = false
            } else {
                print(msg)
                self.msgTxtVw.text = ""
                //                self.msgTxtVw.resignFirstResponder()
                xmppManager.sharedInstance.xmppController.sendMessage(message: msg, toUserID: self.otherUserId)
            }
        }
    }
    
    func observeKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide) , name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    @objc func keyboardShow(_ notification:NSNotification){
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            //            let y:CGFloat = UIDevice.current.orientation.isLandscape ? 110 : 100
            
            self.viewBottomConstraint.constant = keyboardHeight
            self.view.layoutIfNeeded()
            self.scrollToBottom(animated: true)
            //            self.view.frame = CGRect(x: 0, y: -keyboardHeight, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
    }
    
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            
            self.viewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
            
            //            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.length == 1 && range.location == 0 {
            self.sendMsgBtn.isEnabled = false
        } else {
            self.sendMsgBtn.isEnabled = true
        }
        self.TextViewScrollRequired()
        return true
    }
    
    private func TextViewScrollRequired() {
        let fixedWidth = msgTxtVw.frame.size.width
        msgTxtVw.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = msgTxtVw.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        if newSize.height > 140 {
            self.msgTxtVw.isScrollEnabled = true
        } else {
            self.msgTxtVw.isScrollEnabled = false
        }
        //        var newFrame = msgTxtVw.frame
        //        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        //        textView.frame = newFrame
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let chatAtIndex = self.chatArr[indexPath.row]
        if let fromId = chatAtIndex.fromUser, let msg = chatAtIndex.msgBody, let timeStampStr = chatAtIndex.msgTime, let TimeStamp = Double(timeStampStr) {
            
            let msgTime = Date.init(timeIntervalSince1970: TimeStamp)
            
            if fromId == myUserId {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "senderCell") as! senderTableViewCell
                cell.msgLbl.text = msg
                cell.timeLbl.text = dateFormatter.string(from: msgTime)
                
                if let isReaded = chatAtIndex.isReaded, isReaded == true {
                    cell.statusImgVw.backgroundColor = .green
                } else if let isDelivered = chatAtIndex.isDelivered, isDelivered == true {
                    cell.statusImgVw.backgroundColor = .blue
                } else if let isSent = chatAtIndex.isSent, isSent == true {
                    cell.statusImgVw.backgroundColor = .yellow
                } else {
                    cell.statusImgVw.backgroundColor = .red
                }
                
                return cell
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "recieverCell") as! recieverTableViewCell
                cell.msgLbl.text = msg
                cell.timeLbl.text = dateFormatter.string(from: msgTime)
                
                if let isReaded = chatAtIndex.isReaded, isReaded == false, let msgId = chatAtIndex.msgId {
                    xmppManager.sharedInstance.xmppController.sendPresence(present: presenceType.read.rawValue, toUserID: self.otherUserId, msgId: msgId)
                }
                
                return cell
            }
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? senderTableViewCell {
            let chatAtIndex = self.chatArr[indexPath.row]
            if cell.statusImgVw.backgroundColor == .red {
                xmppManager.sharedInstance.xmppController.reSendMessage(data: chatAtIndex)
            } else {
                self.navigateToMessageDetailVC(messageData: chatAtIndex)
            }
        }
        self.view.endEditing(true)
    }
    
    private func navigateToMessageDetailVC(messageData:chatDataModel) {
        self.view.isUserInteractionEnabled = false
        
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "messageDetailViewController") as! messageDetailViewController
        destinationVC.messageData = messageData
        self.show(destinationVC, sender: self)
        
        self.view.isUserInteractionEnabled = true
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollToBottom(animated:Bool){
        DispatchQueue.main.async {
            if self.chatArr.count > 1 {
                let indexPath = IndexPath(row: self.chatArr.count - 1, section: 0)
                self.chatTv.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    @IBAction func disKey(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
