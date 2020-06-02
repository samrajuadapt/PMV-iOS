//
//  HardwareCell.swift
//  PMV
//
//  Created by AdaptME on 7/24/19.
//  Copyright © 2019 AdaptME. All rights reserved.
//

import UIKit

class HardwareCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblVersionIP: UILabel!
    
    @IBOutlet weak var lblMacAddress: UILabel!
    
    @IBOutlet weak var lblFirmware: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblRemark: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
