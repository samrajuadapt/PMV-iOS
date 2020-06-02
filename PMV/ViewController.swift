//
//  ViewController.swift
//  PMV
//
//  Created by AdaptME on 7/23/19.
//  Copyright © 2019 AdaptME. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var scrollContainer: UIScrollView!
    @IBOutlet weak var edtUsername: UITextField!
    @IBOutlet weak var edtPassword: UITextField!
    @IBAction func btnLogin(_ sender: Any) {
        performSegue(withIdentifier: "login", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}

extension ViewController{
    func setupKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if (isLandscape){
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= (keyboardSize.height-250)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

