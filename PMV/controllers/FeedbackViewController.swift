//
//  FeedbackViewController.swift
//  PMV
//
//  Created by AdaptME on 7/29/19.
//  Copyright © 2019 AdaptME. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class FeedbackViewController: UITableViewController {

    @IBOutlet weak var btnHappy: UIButton!
    @IBOutlet weak var btnConfus: UIButton!
    @IBOutlet weak var btnSad: UIButton!
    
    
    @IBAction func btnHappy(_ sender: UIButton) {
        seletedbutton=0
        toggleButton()
    }
    @IBAction func btnConfus(_ sender: UIButton) {
        seletedbutton=1
        toggleButton()
    }
    @IBAction func btnSad(_ sender: UIButton) {
        seletedbutton=2
        toggleButton()
    }
    
    
    @IBOutlet weak var edtSuggestion: UITextView!
    @IBOutlet weak var edtStaffId: UITextField!
    @IBOutlet weak var edtItContact: UITextField!
    @IBAction func btnSubmit(_ sender: UIButton) {
       submitData(true)
    }
    
    
    var seletedbutton=0
    var isCompleted=false
    var selectedId:Int = -1
    var realm:Realm!
    var lastCustomer:Customer?

    override func viewDidLoad() {
        super.viewDidLoad()
        toggleButton()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        initData()
    }
    
    func toggleButton(){
        if seletedbutton==0{
            btnHappy.isHighlighted=false
            btnConfus.isHighlighted=true
            btnSad.isHighlighted=true
        }else if seletedbutton==1{
            btnHappy.isHighlighted=true
            btnConfus.isHighlighted=false
            btnSad.isHighlighted=true
        }else{
            btnHappy.isHighlighted=true
            btnConfus.isHighlighted=true
            btnSad.isHighlighted=false
        }
        
    }
    func initData() {
        do{
            realm=try Realm()
            print(selectedId)
            if selectedId != -1{
                lastCustomer = realm.objects(Customer.self).filter("id == \(selectedId)").first
            }else{
                lastCustomer = realm.objects(Customer.self).last
            }
            
            seletedbutton = getFeedback(lastCustomer?.feedback ?? "Happy")
            toggleButton()
            edtSuggestion.text=lastCustomer?.suggestion
            edtStaffId.text=lastCustomer?.staffId
            edtItContact.text=lastCustomer?.itContact
            
        }catch{
            
        }
    }
    
    var feeback:String{
        if seletedbutton==0 {
            return "Happy"
        }else if seletedbutton==1{
            return "Satisfied"
        }else{
            return "Not satisfied"
        }
        
    }
    func getFeedback(_ feedback:String)->Int{
        if feedback=="Happy" {
            return 0
        }else if feedback=="Satisfied"{
            return 1
        }else if feedback=="Not satisfied"{
            return 2
        }else{
            return 0
        }
    }
    @objc func save(){
        submitData(false)
    }
    
    func submitData(_ isSubmit:Bool){
        do{
            let suggestion=edtSuggestion.text
            let staffid=try edtStaffId.validatedText(validationType: .requiredField(field: "Name"))
            let itcontact=try edtItContact.validatedText(validationType: .requiredField(field: "Status"))
            let feedback=createFeedback(feedback: feeback, suggestion: suggestion ?? "", staffId: staffid, itContact: itcontact)
            saveData(feedback: feedback,isSubmit)
            
        }catch(let error){
            showAlert(for: (error as! ValidationError).message)
        }
    }
    
    func createFeedback(feedback:String,suggestion:String,staffId:String,itContact:String)->Feedback{
        let feed=Feedback()
        feed.feedback=feedback
        feed.suggestion=suggestion
        feed.staffId=staffId
        feed.itContact=itContact
        return feed
        
    }
    
    func saveData(feedback:Feedback,_ isSubmit:Bool){
        do{
            
            try realm.write {
                lastCustomer?.feedback=feedback.feedback
                lastCustomer?.suggestion=feedback.suggestion
                lastCustomer?.itContact=feedback.itContact
                lastCustomer?.staffId=feedback.staffId
                lastCustomer?.isCompleted=isSubmit ? 1 : 0
            }
            gotoHome()
        }catch{
            print(error)
        }
    }
    func gotoHome(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "rootNav") as! UINavigationController
        present(vc, animated: true, completion: nil)
    }
   
    
    func showAlert(for alert: String) {
        let alertController = UIAlertController(title: nil, message: alert, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    

}
