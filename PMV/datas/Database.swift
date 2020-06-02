//
//  Database.swift
//  PMV
//
//  Created by AdaptME on 7/29/19.
//  Copyright © 2019 AdaptME. All rights reserved.
//

import Foundation
import Realm
import RealmSwift


class  CustomerList: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    let branchList=List<BranchList>()
    
    override class func primaryKey() -> String {
        return "id"
    }
}
class BranchList: Object {
    @objc dynamic var id = 0
    @objc dynamic var customerId = 0
    @objc dynamic var name = ""
    
    override class func primaryKey() -> String {
        return "id"
    }
}


class PmvList: Object {
    let list=List<Customer>()
}

class Customer:Object{
    @objc dynamic var id = 0
    @objc dynamic var name=""
    @objc dynamic var branch=""
    @objc dynamic var metWith=""
    @objc dynamic var designation=""
    @objc dynamic var contactNumber=""
    let hardwareList=List<Hardware>()
    let softwareList=List<Software>()
    @objc dynamic var feedback=""
    @objc dynamic var itContact=""
    @objc dynamic var suggestion=""
    @objc dynamic var staffId=""
    @objc dynamic var isCompleted=0
    
    override class func primaryKey() -> String {
        return "id"
    }
}

class Hardware: Object {
    @objc dynamic var id=0
    @objc dynamic var customerId=0
    @objc dynamic var name=""
    @objc dynamic var status=""
    @objc dynamic var ipOrSerial=""
    @objc dynamic var firmware=""
    @objc dynamic var macAddress=""
    @objc dynamic var remark=""
    
    override class func primaryKey() -> String {
        return "id"
    }
}
class Software: Object {
    @objc dynamic var id=0
    @objc dynamic var customerId=0
    @objc dynamic var name=""
    @objc dynamic var version=""
    @objc dynamic var status=""
    @objc dynamic var remark=""
    
    override class func primaryKey() -> String {
        return "id"
    }
}
class Feedback: Object {
    @objc dynamic var customerId=0
    @objc dynamic var feedback=""
    @objc dynamic var itContact=""
    @objc dynamic var suggestion=""
    @objc dynamic var staffId=""

}
