//
//  HomeViewController.swift
//  PMV
//
//  Created by AdaptME on 7/23/19.
//  Copyright © 2019 AdaptME. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBAction func btnPmv(_ sender: UIButton) {
    }
    
    @IBAction func btnSupport(_ sender: UIButton) {
    }
    @IBOutlet weak var tblPmvList: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()

        // Do any additional setup after loading the view.
    }
    func setupCollectionView(){
        tblPmvList.delegate=self
        tblPmvList.dataSource=self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pmvCell") as! PmvTableViewCell
        
        return cell
    }
    
}

