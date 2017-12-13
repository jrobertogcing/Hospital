//
//  AssignMedicineViewController.swift
//  HospitalApp
//
//  Created by Robert on 12/12/17.
//  Copyright © 2017 Robert González. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AssignMedicineViewController: UIViewController {
    
    @IBOutlet weak var namePatientLabel: UILabel!
    
    @IBOutlet weak var medicinePickerView: UIPickerView!
    
    @IBOutlet weak var dosageTextField: UITextField!
    
    @IBOutlet weak var typeDosageSegmented: UISegmentedControl!
    
    @IBOutlet weak var pritoritySegmented: UISegmentedControl!
    
    @IBOutlet weak var scheduleDatePicker: UIDatePicker!
    
    
    @IBOutlet weak var assignMedicationButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func assignButtonAction(_ sender: UIButton) {
        
        
        
        
    }//End assginButtonAction
    
    
    
   
}// End ViewController

