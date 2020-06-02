//
//  PmvTableViewCell.swift
//  PMV
//
//  Created by AdaptME on 7/30/19.
//  Copyright © 2019 AdaptME. All rights reserved.
//

import UIKit

class PmvTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCustomer: UILabel!
    @IBOutlet weak var lblCompleted: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
