//
//  AddProductViewController.swift
//  PMV
//
//  Created by AdaptME on 7/25/19.
//  Copyright © 2019 AdaptME. All rights reserved.
//

import UIKit
import iOSDropDown
import Realm
import RealmSwift

class AddProductViewController: UITableViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var edtType: DropDown!
    @IBOutlet weak var edtName: DropDown!
    @IBOutlet weak var edtStatus: DropDown!
    @IBOutlet weak var edtAddressVersion: UITextField!
    @IBOutlet weak var edtQty: DropDown!
    
    @IBOutlet weak var edtMacAddress: UITextField!
    
    @IBOutlet weak var edtFirmware: UITextField!
    @IBOutlet weak var edtRemark: UITextField!
    
    @IBAction func brnCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnAdd(_ sender: UIButton) {
        addItem()
    }
    
    var selectedType=""
    var selectedId:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setContainerView()
        setupDropdown()
        initData()
        toggleLabel()
    }
    func initData(){
        enableDisable(false,false)
    }
    func setupDropdown(){
        edtType.optionArray=selectType
        edtStatus.optionArray=status
        edtQty.optionArray=quantity
    }
    func toggleLabel(){
        edtType.didSelect { (selectedText, index, id) in
            self.selectedType=selectedText
            self.resetEdt()
            if self.isHardware{
                self.enableDisable(true,true)
                self.edtName.optionArray=hardnames
                self.edtAddressVersion.placeholder="IP Address / Serial Number"
            }
            else{
                self.enableDisable(true,false)
                self.edtName.optionArray=softnames
                self.edtAddressVersion.placeholder="Version"
            }
        }
    }
    var isHardware:Bool{
        return self.selectedType=="Hardware"
    }
    func resetEdt(){
        self.edtName.text=""
        self.edtStatus.text=""
        self.edtAddressVersion.text=""
        self.edtMacAddress.text=""
        self.edtRemark.text=""
    }
    func enableDisable(_ isEnable:Bool,_ isHardware:Bool){
        edtName.isEnabled=isEnable
        edtStatus.isEnabled=isEnable
        edtQty.isEnabled=isHardware
        edtFirmware.isEnabled=isHardware
        edtAddressVersion.isEnabled=isEnable
        edtMacAddress.isEnabled=isHardware
        edtRemark.isEnabled=isEnable
    }
    func setContainerView(){
        containerView.layer.cornerRadius = 20.0
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        containerView.layer.shadowRadius = 2.0
        containerView.layer.shadowOpacity = 0.2
    }
    
    func createaHardware(name:String,status:String,ip:String,firm:String,mac:String,remark:String)->Hardware{
        let hw=Hardware()
        hw.name=name
        hw.status=status
        hw.ipOrSerial=ip
        hw.firmware=firm
        hw.macAddress=mac
        hw.remark=remark
        return hw
    }
    func createSoftware(name:String,status:String,version:String,remark:String)->Software{
        let sw=Software()
        sw.name=name
        sw.status=status
        sw.version=version
        sw.remark=remark
        return sw
    }
    
    func addItem(){
        do{
            _=try edtType.validatedText(validationType: .requiredField(field: "Type"))
            let name=try edtName.validatedText(validationType: .requiredField(field: "Name"))
            let status=try edtStatus.validatedText(validationType: .requiredField(field: "Status"))
            let ipver=edtAddressVersion.text
            let firm=edtFirmware.text
            let mac=edtMacAddress.text
            let remark=edtRemark.text
            let qty=edtQty.text
            let hw=createaHardware(name: name, status: status, ip: ipver ?? "",firm: firm ?? "", mac: mac ?? "", remark: remark ?? "")
            let sw = createSoftware(name: name, status: status, version: ipver ?? "", remark: remark ?? "")
            saveData(hw: hw, sw: sw,qtyData: qty ?? "1")
            
        }catch(let error){
            showAlert(for: (error as! ValidationError).message)
        }
        
    }
    func showAlert(for alert: String) {
        let alertController = UIAlertController(title: nil, message: alert, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func saveData(hw:Hardware,sw:Software,qtyData:String){
        do{
            let db=try Realm()
            let lastCustomer:Customer?
            if selectedId != -1{
                lastCustomer = db.objects(Customer.self).filter("id == \(selectedId)").first
            }else{
                lastCustomer = db.objects(Customer.self).last
            }
            var hwId=db.objects(Hardware.self).map{$0.id}.max() ?? 0
            var swId=db.objects(Software.self).map{$0.id}.max() ?? 0
            
            var hwlist=[Hardware]()
            let qty:Int? = Int(qtyData)
            
            if qty==1 {
                hwId=hwId+1
                hw.id=hwId
                hw.customerId=(lastCustomer?.id)!
            }else{
                for index in 1...qty! {
                    let id=hwId+index
                    let hwI=Hardware()
                    hwI.id=id
                    hwI.customerId=(lastCustomer?.id)!
                    hwI.name="\(hw.name) - \(index)"
                    hwI.status=hw.status
                    hwlist.append(hwI)
                }
            }

            swId=swId+1
            sw.id=swId
            sw.customerId=(lastCustomer?.id)!
            try db.write {
                if self.isHardware{
                    if qty==1{
                        lastCustomer?.hardwareList.append(hw)
                    }else{
                        lastCustomer?.hardwareList.append(objectsIn: hwlist)
                    }
                }else{
                    lastCustomer?.softwareList.append(sw)
                }
            }
            dismiss(animated: true, completion: nil)
        }catch{
            
        }
    }
    
    


}
