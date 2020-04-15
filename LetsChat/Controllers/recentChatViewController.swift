//
//  chatViewController.swift
//  LetsChat
//
//  Created by Ongraph on 05/12/17.
//  Copyright © 2017 Gulmohar Inc. All rights reserved.
//

import UIKit

class recentChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, refreshUIDelegate {
    
    @IBOutlet weak var recentChatTV: UITableView!
    var chatListArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        navigationController?.navigationItem.title = "Chats"
        
//        let newBackButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(self.back(sender:)))
//        self.navigationItem.rightBarButtonItem = newBackButton
//    }
//
//    @objc func back(sender: UIBarButtonItem) {
//        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sqliteManager.sharedInstance.delegate = self
        self.refreshUI(animated: false)
    }
    
    func refreshUI(animated:Bool) {
        self.chatListArr = sqliteManager.sharedInstance.fetchRecentMsgUerIds()
        self.recentChatTV.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let fromUser = self.chatListArr[indexPath.row]
        
        cell.textLabel?.text = fromUser
        
        if let chatAtIndex = sqliteManager.sharedInstance.fetchLastMsgInChat(fromId: fromUser), let msg = chatAtIndex.msgBody {
            
            cell.detailTextLabel?.text = msg
            
        }
        
        //        if let fromUserId = chatAtIndex.fromUser, let msg = chatAtIndex.msgBody {
        //            
        //            cell.detailTextLabel?.text = msg
        //            
        //            if fromUserId != myUserId {
        //                cell.textLabel?.text = fromUserId
        //            } else if let toUserId = chatAtIndex.toUser {
        //                cell.textLabel?.text = toUserId
        //            }
        //        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let chatVC = segue.destination as? chatViewController, let indexPath = self.recentChatTV.indexPathForSelectedRow {
            
            let chatUserAtIndex = self.chatListArr[indexPath.row]
            chatVC.otherUserId = chatUserAtIndex
            
            //            if let fromUserId = chatAtIndex.fromUser {
            //                if fromUserId != myUserId {
            //                    chatVC.otherUserId = fromUserId
            //                } else if let toUserId = chatAtIndex.toUser {
            //                    chatVC.otherUserId = toUserId
            //                }
            //            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
