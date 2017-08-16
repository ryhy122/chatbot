//
//  VocabularyTableViewCell.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/15.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import UIKit

class VocabularyTableViewCell: UITableViewCell {

    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var definition: UILabel!
    @IBOutlet weak var example: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
