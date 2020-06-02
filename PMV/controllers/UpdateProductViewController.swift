//
//  UpdateProductViewController.swift
//  PMV
//
//  Created by AdaptME on 7/31/19.
//  Copyright © 2019 AdaptME. All rights reserved.
//

import UIKit
import iOSDropDown
import Realm
import RealmSwift

class UpdateProductViewController: UITableViewController {

    @IBOutlet weak var edtName: UITextField!
    @IBOutlet weak var edtStatus: DropDown!
    @IBOutlet weak var edtVerionIP: UITextField!
    @IBOutlet weak var edtMacAddress: UITextField!
    @IBOutlet weak var edtFirmware: UITextField!
    @IBOutlet weak var edtRemark: UITextField!
    @IBAction func btnUpdate(_ sender: UIButton) {
        updateData()
    }

    @IBAction func btnCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    var selectdId = -1
    var isHardware = true
    var realm:Realm!
    var hardware:Hardware?
    var software:Software?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        setupDropdown()
        toggleText()

    }
    func initData(){
        
        do{
            realm = try Realm()
            if isHardware{
                hardware = realm.objects(Hardware.self).filter("id == \(selectdId)").first
                setHwData(hardware: hardware!)
            }else{
                software = realm.objects(Software.self).filter("id == \(selectdId)").first
                setSwData(software: software!)
            }
            
        }catch{
            print(error)
        }
    }
    func setupDropdown(){
        edtStatus.optionArray=status
    }
    func toggleText(){
        edtVerionIP.placeholder = isHardware ? "IP / Serial Number" : "Version"
        edtMacAddress.isEnabled = isHardware
        edtFirmware.isEnabled = isHardware
    }
    
    func setHwData(hardware:Hardware){
        edtName.text=hardware.name
        edtStatus.text=hardware.status
        edtVerionIP.text=hardware.ipOrSerial
        edtMacAddress.text=hardware.macAddress
        edtFirmware.text=hardware.firmware
        edtRemark.text=hardware.remark
    }
    func setSwData(software:Software){
        edtName.text=software.name
        edtStatus.text=software.status
        edtVerionIP.text=software.version
        edtRemark.text=software.remark
    }
    
    func updateData(){
        let status=try! edtStatus.validatedText(validationType: .requiredField(field: "Status"))
        let ipver=edtVerionIP.text
        let firm=edtFirmware.text
        let mac=edtMacAddress.text
        let remark=edtRemark.text
        
        if isHardware{
            updateHw(status: status, ip: ipver ?? "", firm: firm ?? "", mac: mac ?? "", remark: remark ?? "")
        }else{
            updateSw(status: status, version: ipver ?? "", remark: remark ?? "")
        }
    }
    
    
    
    func updateHw(status:String,ip:String,firm:String,mac:String,remark:String){
        do{
            try realm.write {
                hardware?.status=status
                hardware?.ipOrSerial=ip
                hardware?.firmware=firm
                hardware?.macAddress=mac
                hardware?.remark=remark
            }
            dismiss(animated: true, completion: nil)
        }catch{
            print(error)
        }
        
    }
    func updateSw(status:String,version:String,remark:String){
        do{
            try realm.write {
                software?.status=status
                software?.version=version
                software?.remark=remark
            }
            dismiss(animated: true, completion: nil)
        }catch{
            print(error)
        }
    }
    

}
