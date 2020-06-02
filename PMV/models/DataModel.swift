//
//  DataModel.swift
//  PMV
//
//  Created by AdaptME on 7/24/19.
//  Copyright © 2019 AdaptME. All rights reserved.
//

import Foundation
import UIKit



struct CellData {
    var section:String!
    var product:[Product]?
}
struct Product {
    var name:String?
}
struct HwProduct {
    var name:String?
    var status:Bool?
    var ipAddress:String?
    var remark:String?
}
struct SwProduct {
    var name:String?
    var status:Bool?
    var remark:String?
}

struct Customers {
    var name:String
    var branches:[String]
    
}


