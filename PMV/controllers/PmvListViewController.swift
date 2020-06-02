//
//  PmvListViewController.swift
//  PMV
//
//  Created by AdaptME on 7/29/19.
//  Copyright © 2019 AdaptME. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
import iOSDropDown

class PmvListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tblPmvList: UITableView!
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var edtCustomer: DropDown!
    @IBOutlet weak var edtBranch: DropDown!
    
    @IBOutlet weak var edtEmirates: DropDown!
    
    @IBOutlet weak var edtStatus: DropDown!
    
    @IBOutlet weak var lblList: UILabel!
    var pmvList=List<Customer>()
    var selectedId:Int = -1
    var isFilterShow=true
    
    var realm:Realm!
    var notificationToken: NotificationToken? = nil
    var searchQuery=["","","",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblPmvList.delegate=self
        tblPmvList.dataSource=self
        initData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filerTapped))
        filerTapped()
        setupdropDown()
        setFilter()
        // Do any additional setup after loading the view.
    }
    func initData(){
        do{
            //dummy not done
            let cus=Customer()
            cus.name="UNB"
            cus.branch="Abu Dhabi"
            cus.isCompleted=notDone
            realm=try Realm()
        
            let data = realm.objects(Customer.self).filter("isCompleted !=  4").sorted(byKeyPath: "isCompleted", ascending: true)
            for customer in data {
                pmvList.append(customer)
            }
            pmvList.append(cus)
            
            notificationToken = realm.observe { _,_ in
                guard let tableView = self.tblPmvList else { return }
                tableView.reloadData()
            }

        }catch{
            print(error)
        }
        
    }
    deinit {
        notificationToken?.invalidate()
    }
    
    func setupdropDown(){
        edtCustomer.optionArray=customerFilter
        edtBranch.optionArray=branchFilter
        edtEmirates.optionArray=["All","Dubai","Abu Dhabi"]
        edtStatus.optionArray=statusfilter
    }
    func setFilter(){
        edtCustomer.didSelect { (name, index, id) in
            if name != "All"{
                self.searchQuery[0]="name = '\(name)'"
            }else{
                self.searchQuery[0]=""
            }
            self.filter()
            
        }
        edtBranch.didSelect { (name, index, id) in
            if name != "All"{
                self.searchQuery[1]="branch = '\(name)'"
            }else{
                self.searchQuery[1]=""
            }
            self.filter()
        }
        edtEmirates.didSelect { (name, index, id) in
            if !name.isEmpty || name != "All"{
                
            }
        }
        edtStatus.didSelect { (name, index,id) in
            if name != "All"{
                self.searchQuery[3]="isCompleted = \(self.getCompletd(name: name))"
            }else{
                self.searchQuery[3]=""
            }
            self.filter()
        }
    }
    
    func filter(){
        var sq=""
        var sf=""
        for index in 0..<searchQuery.count{
            if !searchQuery[index].isEmpty{
                sf="\(sf) \(searchQuery[index].components(separatedBy: " ").first?.replacingOccurrences(of: "isCompleted", with: "Status").capitalized ?? "")"
                sq = "\(sq) \(searchQuery[index]) AND"
                
            }
        }
        sq=sq.components(separatedBy: " ").dropLast().joined(separator: " ")
        if !sf.isEmpty{
            lblList.text="Filter by \(sf)"
        }else{
            lblList.text="All List"
        }
        pmvList.removeAll()
        if !sq.isEmpty{
            let data = realm.objects(Customer.self).filter(sq).sorted(byKeyPath: "isCompleted", ascending: true)
            for customer in data {
                pmvList.append(customer)
            }
        }else{
            let data = realm.objects(Customer.self).sorted(byKeyPath: "isCompleted", ascending: true)
            for customer in data {
                pmvList.append(customer)
            }
        }
        tblPmvList.reloadData()
        
        
    }
    func getCompletd(name:String)->Int{
        if name=="InComplete"{
            return 0
        }else if name=="Completed"{
            return 1
        }else {
            return 2
        }
    }
    
    @objc func filerTapped(){
        if isFilterShow{
            UIView.transition(with: filterView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.filterView.isHidden=true
                self.filerViewHeight.constant=0
                self.view.layoutIfNeeded()
                self.filterView.setNeedsUpdateConstraints()
                self.isFilterShow=false
            }, completion: nil)
            
        }else{
            UIView.transition(with: filterView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.filterView.isHidden=false
                self.filerViewHeight.constant=105
                self.view.layoutIfNeeded()
                self.filterView.setNeedsUpdateConstraints()
                self.isFilterShow=true
            }, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pmvList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "pmvCell") as! PmvListTableViewCell
        let data = pmvList[indexPath.row]
        cell.lblCustomerName.text=data.name
        cell.lblBranchName.text=data.branch
        if data.isCompleted==completed{
            cell.lblIsComplete.text="Completed"
            cell.lblIsComplete.textColor = .green
        }else if data.isCompleted==inComplete{
            cell.lblIsComplete.text="InCompleted"
            cell.lblIsComplete.textColor = .red
        }else{
            cell.lblIsComplete.text="Not Done"
            cell.lblIsComplete.textColor = .gray
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = pmvList[indexPath.row]
        self.selectedId=data.id
        if data.isCompleted==inComplete || data.isCompleted==notDone{
            performSegue(withIdentifier: "gotoCustomer", sender: self)
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CustomerViewController
        vc.selectedId=selectedId
    }
    

}
