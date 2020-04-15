//
//  contactViewController.swift
//  LetsChat
//
//  Created by Ongraph on 05/12/17.
//  Copyright © 2017 Gulmohar Inc. All rights reserved.
//

import UIKit

class contactViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var contactTV: UITableView!
    
    var contactsArr = ["navjotsp", "navjotsp1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if contactsArr.contains(where: { (str) -> Bool in
            if str == myUserId {
                return true
            }
            return false
        }) {
            if let index = contactsArr.firstIndex(of: myUserId) {
                contactsArr.remove(at: index)
            }
        }
        
        contactTV.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let userAtindex = contactsArr[indexPath.row]
        cell.textLabel?.text = userAtindex
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let chatVC = segue.destination as? chatViewController, let indexPath = self.contactTV.indexPathForSelectedRow {
            
            let fromUserId = self.contactsArr[indexPath.row]
            chatVC.otherUserId = fromUserId
        }
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
