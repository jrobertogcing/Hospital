//
//  DetailsPatientViewController.swift
//  HospitalApp
//
//  Created by Robert on 12/12/17.
//  Copyright © 2017 Robert González. All rights reserved.
//

import UIKit

class DetailsPatientViewController: UIViewController {
    
    
    @IBOutlet weak var patientNameLabel: UILabel!
    
    
    var namePatientReceived = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        
        patientNameLabel.text = namePatientReceived

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
