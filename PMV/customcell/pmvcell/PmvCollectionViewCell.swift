//
//  PmvCollectionViewCell.swift
//  PMV
//
//  Created by AdaptME on 7/23/19.
//  Copyright © 2019 AdaptME. All rights reserved.
//

import UIKit

class PmvCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblCustomer: UILabel!
    @IBOutlet weak var lblBranch: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.backgroundColor = UIColor(hexString: "#C7D7FD").cgColor
        containerView.layer.cornerRadius = 10.0
//        containerView.layer.shadowColor = UIColor.darkGray.cgColor
//        containerView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
//        containerView.layer.shadowRadius = 2.0
//        containerView.layer.shadowOpacity = 0.2
    }

}
