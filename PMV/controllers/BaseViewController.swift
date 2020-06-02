//
//  BaseViewController.swift
//  PMV
//
//  Created by AdaptME on 8/1/19.
//  Copyright © 2019 AdaptME. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class BaseViewController: UIViewController {
    
    var realm:Realm!
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try!Realm()
    }
    

}
