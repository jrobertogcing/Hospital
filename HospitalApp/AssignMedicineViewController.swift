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

class AssignMedicineViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var namePatientLabel: UILabel!
    
    @IBOutlet weak var medicinePickerView: UIPickerView!
    
    @IBOutlet weak var dosageTextField: UITextField!
    
    @IBOutlet weak var typeDosageSegmented: UISegmentedControl!
    
    @IBOutlet weak var pritoritySegmented: UISegmentedControl!
    
    @IBOutlet weak var scheduleDatePicker: UIDatePicker!
    
    
    @IBOutlet weak var assignMedicationButton: UIButton!
    
    
    var ref: DatabaseReference!
    var pickerArray = ["","High", "Medium", "Low"]
    var pickerSelected = ""


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.view.isUserInteractionEnabled = false
        
        //activityIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func assignButtonAction(_ sender: UIButton) {
        
       
        self.assignMedicationButton.isEnabled = false

        
        
    }//End assginButtonAction

    
    
//MARK: Save data Function
    
    func saveData()  {
        
        guard let dosageSave = dosageTextField.text
            else{
               
                // alert
                
        return
        }
        
        if pickerSelected != "" {

            let typeDosageSave = typeDosageSegmented.selectedSegmentIndex

            let prioritySave = pritoritySegmented.selectedSegmentIndex
        
        
            ref = Database.database().reference().child("Nurse")
        
        
            let userDetails = [
            "medicine" : pickerSelected,
            "dosage" : dosageSave,
            "typeDosage" : typeDosageSave,
            "priority": prioritySave
            //"schedule" : resultsSave,
            
            ] as [String : Any]
        
        
            guard let userID = Auth.auth().currentUser?.uid else {
            
            return
            }
        
            ref.child(userID).child("Aqui es el numero de paciente").child("Medication").setValue(userDetails)

        }else {
        
        // Alert no medicine selected
        
        }
        
        
    }// End saveData Function
    
    
    
//MARK :Picker View
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        return pickerArray.count
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerArray[row]
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //  information to variable of the row selected
        pickerSelected = pickerArray[row]
        
    }
    
//MARK : alertGeneral
    
    func alertGeneral(errorDescrip:String, information: String) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let alertGeneral = UIAlertController(title: information, message: errorDescrip, preferredStyle: .alert)
        
        let aceptAction = UIAlertAction(title: "Ok", style: .default)
        
        alertGeneral.addAction(aceptAction)
        present(alertGeneral, animated: true)
        
    }//End Alert General
    
    
   
}// End ViewController

