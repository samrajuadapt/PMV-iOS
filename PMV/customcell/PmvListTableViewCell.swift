//
//  PmvListTableViewCell.swift
//  PMV
//
//  Created by AdaptME on 7/29/19.
//  Copyright © 2019 AdaptME. All rights reserved.
//

import UIKit

class PmvListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCustomerName: UILabel!
    
    @IBOutlet weak var lblBranchName: UILabel!
    
    @IBOutlet weak var lblIsComplete: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
