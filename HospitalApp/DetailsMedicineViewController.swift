//
//  DetailsMedicineViewController.swift
//  HospitalApp
//
//  Created by Robert on 12/12/17.
//  Copyright © 2017 Robert González. All rights reserved.
//

import UIKit

class DetailsMedicineViewController: UIViewController {

    
    @IBOutlet weak var detailsMedicineTableView: UITableView!
    
    @IBOutlet weak var medicineNameLabel: UILabel!
    
    var nameMedicineReceived = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        medicineNameLabel.text = nameMedicineReceived

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
