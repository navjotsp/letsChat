//
//  senderMessageDetailTableViewCell.swift
//  LetsChat
//
//  Created by Ongraph on 03/01/18.
//  Copyright © 2018 Gulmohar Inc. All rights reserved.
//

import UIKit

class senderMessageDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var msgLbl: UILabel!
    
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var statusImgVw: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
