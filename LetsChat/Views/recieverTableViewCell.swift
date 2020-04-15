//
//  recieverTableViewCell.swift
//  LetsChat
//
//  Created by Ongraph on 06/12/17.
//  Copyright © 2017 Gulmohar Inc. All rights reserved.
//

import UIKit

class recieverTableViewCell: UITableViewCell {
    
    @IBOutlet weak var msgLbl: UILabel!
    
    @IBOutlet weak var timeLbl: UILabel!
    
    
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
