//
//  messageDetailViewController.swift
//  LetsChat
//
//  Created by Ongraph on 03/01/18.
//  Copyright © 2018 Gulmohar Inc. All rights reserved.
//

import UIKit

class messageDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, refreshUIDelegate {
    
    var messageData : chatDataModel!
    @IBOutlet weak var myTV: UITableView!
    @IBOutlet weak var bckImgVwHeightConstant: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        sqliteManager.sharedInstance.delegate = self
        
    }
    
    func refreshUI(animated: Bool) {
        if let newData = sqliteManager.sharedInstance.fetchMessageDetails(msgId: messageData.msgId!) {
            messageData = newData
            self.myTV.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let msg = messageData.msgBody
        
        let sentTimeStampStr = messageData.msgTime!
        let sentTimeStamp = Double(sentTimeStampStr)!
        let sentMsgTime = Date.init(timeIntervalSince1970: sentTimeStamp)
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "senderCell") as! senderMessageDetailTableViewCell
            
            cell.msgLbl.text = msg
            cell.timeLbl.text = dateFormatter.string(from: sentMsgTime)
            
            if let isReaded = messageData.isReaded, isReaded == true {
                cell.statusImgVw.backgroundColor = .green
            } else if let isDelivered = messageData.isDelivered, isDelivered == true {
                cell.statusImgVw.backgroundColor = .blue
            } else if let isSent = messageData.isSent, isSent == true {
                cell.statusImgVw.backgroundColor = .yellow
            } else {
                cell.statusImgVw.backgroundColor = .red
            }
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            
            if indexPath.row == 1 {
                
                if let readTimeStampStr = messageData.readTime, let readTimeStamp = Double(readTimeStampStr) {
                    let readMsgTime = Date.init(timeIntervalSince1970: readTimeStamp)
                    
                    cell.detailTextLabel?.text = dateFormatter.string(from: readMsgTime)
                } else {
                    cell.detailTextLabel?.text = "***"
                }
                
                cell.textLabel?.text = "Read"
                
            } else {
                
                if let deliveredTimeStampStr = messageData.deliveryTime, let deliveredTimeStamp = Double(deliveredTimeStampStr) {
                    let deliveredMsgTime = Date.init(timeIntervalSince1970: deliveredTimeStamp)
                    cell.detailTextLabel?.text = dateFormatter.string(from: deliveredMsgTime)
                } else {
                    cell.detailTextLabel?.text = "***"
                }
                
                cell.textLabel?.text = "Delivered"
                
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.bckImgVwHeightConstant.constant = tableView.contentSize.height
        self.view.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
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
