//
//  ProductViewController.swift
//  PMV
//
//  Created by AdaptME on 7/24/19.
//  Copyright © 2019 AdaptME. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class ProductViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tblProduct: UITableView!
    
    @IBAction func btnProceed(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoFeedback", sender: self)
    }
    
    var effect:UIVisualEffect!
    var hwList=List<Hardware>()
    var swList=List<Software>()
    
    var notificationToken: NotificationToken? = nil
    var selectedId:Int = -1
    
    var realm:Realm!
    var customer:Customer?
    var lastCus:Customer?
    var name=""
    var branch=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblProduct.delegate=self
        tblProduct.dataSource=self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        initData()
        initNotification()
    }
    
    @objc func addTapped(){
        let vc=storyboard?.instantiateViewController(withIdentifier: "AddProductView")  as! AddProductViewController
        vc.selectedId=selectedId
        present(vc, animated: true, completion: nil)
    }
    
    
    func initData() {
        do{
            realm=try Realm()
            if selectedId != -1{
                customer = realm.objects(Customer.self).filter("id == \(selectedId)").first
            }else{
                customer = realm.objects(Customer.self).last
            }
            lastCus=realm.objects(Customer.self).filter("name = '\(name)' AND branch = '\(branch)' AND isCompleted = 1").last
            if lastCus != nil {
                try realm.write {
                    for hw in (lastCus?.hardwareList)!{
                        customer?.hardwareList.append(hw)
                    }
                    for sw in (lastCus?.softwareList)!{
                        customer?.softwareList.append(sw)
                    }
                    lastCus?.isCompleted = 4
                }
            }
            self.hwList=(customer?.hardwareList)!
            self.swList=(customer?.softwareList)!
            self.tblProduct.reloadData()
    
        }catch{
            
        }
    }
    
    func initNotification(){
        notificationToken = realm!.observe { _,_  in
            guard let tableView = self.tblProduct else { return }
            tableView.reloadData()
        }

    }
    deinit {
        notificationToken?.invalidate()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return hwList.count+1
        }
        return swList.count+1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var mainCell:UITableViewCell!
        if indexPath.section==0{
            let cell = Bundle.main.loadNibNamed("HardwareCell", owner: self, options: nil)?.first as! HardwareCell
            if indexPath.row==0{
                cell.selectionStyle = .none
                boldText(lblList: [cell.lblName,cell.lblStatus,cell.lblVersionIP,cell.lblMacAddress,cell.lblFirmware,cell.lblRemark])
                return cell
            }
            let hw=hwList[indexPath.row-1]
            cell.lblName.text=hw.name
            cell.lblStatus.text=hw.status
            cell.lblVersionIP.text=hw.ipOrSerial
            cell.lblMacAddress.text=hw.macAddress
            cell.lblFirmware.text=hw.firmware
            cell.lblRemark.text=hw.remark
            mainCell=cell
        }else{
            
            let cell = Bundle.main.loadNibNamed("SoftwareCell", owner: self, options: nil)?.first as! SoftwareCell
            if indexPath.row==0{
                cell.selectionStyle = .none
                boldText(lblList: [cell.lblName,cell.lblStatus,cell.lblVersion,cell.lblRemark])
                return cell
            }
            let sw=swList[indexPath.row-1]
            cell.lblName.text=sw.name
            cell.lblStatus.text=sw.status
            cell.lblVersion.text=sw.version
            cell.lblRemark.text=sw.remark
            mainCell=cell
        }
        
        return mainCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = Bundle.main.loadNibNamed("HeaderCell", owner: self, options: nil)?.first as! HeaderCell
        if section == 0{
            cell.lblHeader.text="Hardware Part"
            
        }else{
            cell.lblHeader.text="Software Part"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc=storyboard?.instantiateViewController(withIdentifier: "UpdateView") as! UpdateProductViewController
        if indexPath.section == 0{
            if indexPath.row==0{
                return
            }
            vc.isHardware=true
            vc.selectdId=hwList[indexPath.row-1].id
        }else{
            if indexPath.row==0{
                return
            }
            vc.isHardware=false
            vc.selectdId=swList[indexPath.row-1].id
        }
        present(vc, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func boldText(lblList:[UILabel]){
        for lbl in lblList {
            lbl.font=UIFont(name:"HelveticaNeue-Bold", size: 18.0)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc=segue.destination as! FeedbackViewController
        vc.selectedId=selectedId
    }

}
