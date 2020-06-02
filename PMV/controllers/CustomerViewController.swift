//
//  CustomerViewController.swift
//  PMV
//
//  Created by AdaptME on 7/23/19.
//  Copyright © 2019 AdaptME. All rights reserved.
//

import UIKit
import iOSDropDown
import Realm
import RealmSwift
import Firebase
import FirebaseCore
import FirebaseFirestore

class CustomerViewController: UITableViewController{

    
    @IBOutlet weak var dropCustomer: DropDown!
    
    @IBOutlet weak var dropBranch: DropDown!
    @IBOutlet weak var edtMetName: UITextField!
    @IBOutlet weak var dropDesignation: DropDown!
    @IBOutlet weak var edtContactNumber: UITextField!
    
    @IBAction func btnProceed(_ sender: UIButton) {
        addCustomer()
    }
    
    var isCompleted:Bool=true
    var selectedId = -1
    var notificationToken: NotificationToken? = nil
    var name=""
    var branch=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDropdown()
        setupResetButton()
        initData()
        

        let collection = Firestore.firestore().collection("customers")
        
        collection.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    print("\(data["name"])")
                    
                    let branches  = data["branches"] as! NSArray
                    for b in branches{
                        print(b)
                    }

                }
            }
        }
        
    }
    
    func setupDropdown(){
        dropCustomer.optionArray=customerList
        dropBranch.optionArray=branchList
        dropDesignation.optionArray=designtions
    }
    func setupResetButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetTap))
    }
    @objc func resetTap(){
        dropCustomer.text=""
        dropBranch.text=""
        dropDesignation.text=""
        edtMetName.text=""
        edtContactNumber.text=""
    }
    
    
    func initData() {
        do{
            let db=try Realm()
            let results = db.objects(Customer.self)
        
            if selectedId != -1{
                let lastCustomer = results.filter("id == \(selectedId)").first
                self.isCompleted=false
                dropCustomer.text=lastCustomer?.name
                dropBranch.text=lastCustomer?.branch
                edtMetName.text=lastCustomer?.metWith
                dropDesignation.text=lastCustomer?.designation
                edtContactNumber.text=lastCustomer?.contactNumber
            }else{
                self.isCompleted=true
            }
            notificationToken=results.observe({ (changes) in
                switch changes{
                case .initial(_)://do something
                    break
                case .update(_, _,  _,  _):
                    self.isCompleted=false
                    break
                case .error(_)://do something
                    break
                }
            })
            
        }catch{
            
        }
    }
    deinit {
        notificationToken?.invalidate()
    }
    func addCustomer(){
        do{
            name=try dropCustomer.validatedText(validationType: .requiredField(field: "Customer Name"))
            branch=try dropBranch.validatedText(validationType: .requiredField(field: "Branch Name"))
            let metWith=try edtMetName.validatedText(validationType: .requiredField(field: "Met With"))
            let desi=try dropDesignation.validatedText(validationType: .requiredField(field: "Designation"))
            let contact=try edtContactNumber.validatedText(validationType: .requiredField(field: "Contact Number"))
            let customer=createCustomer(name: name, branch: branch, metWith: metWith, desi: desi, contact: contact)
            if isCompleted{
                saveData(cusromer: customer)
            }else{
                updateData(customer: customer)
            }
        }catch(let error){
            showAlert(for: (error as! ValidationError).message)
        }
    }
    func createCustomer(name:String,branch:String,metWith:String,desi:String,contact:String)->Customer{
        let customer = Customer()
        customer.name=name
        customer.branch=branch
        customer.metWith=metWith
        customer.designation=desi
        customer.contactNumber=contact
        return customer
    }
    
    func saveData(cusromer:Customer){
        print("add")
        do{
            let db = try Realm()
            var id = db.objects(Customer.self).map{$0.id}.max() ?? 0
            id = id + 1
            cusromer.id=id
            try db.write {
                db.add(cusromer)
            }
            self.performSegue(withIdentifier: "gotoProductView", sender: self)
        }catch{
            print(error)
        }
    }
    
    func updateData(customer:Customer){
        print("update")
        do{
            let realm = try Realm()
            let dbCust = realm.objects(Customer.self).filter("id == \(customer.id)").first
            try realm.write {
                dbCust?.name=customer.name
                 dbCust?.branch=customer.name
                 dbCust?.metWith=customer.metWith
                 dbCust?.designation=customer.designation
                 dbCust?.contactNumber=customer.contactNumber
                
            }
            self.performSegue(withIdentifier: "gotoProductView", sender: nil)
        }catch{
            print(error)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc=segue.destination as! ProductViewController
        vc.selectedId=selectedId
        vc.name=name
        vc.branch=branch
        
    }
    
    func showAlert(for alert: String) {
        let alertController = UIAlertController(title: nil, message: alert, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
}

