//
//  SoftwareCell.swift
//  PMV
//
//  Created by AdaptME on 7/25/19.
//  Copyright © 2019 AdaptME. All rights reserved.
//

import UIKit

class SoftwareCell: UITableViewCell {

    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblRemark: UILabel!
    
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
