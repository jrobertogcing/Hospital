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
    
    //variables
    var ref: DatabaseReference!
    var pickerSelected = ""

    var medicinesName = [String]()
    
    //variables received
    var nameReceived = ""
    var idPatientReceived = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
       
        
        // call infoMedicines
        infoMedicines()
        
        medicinePickerView.dataSource = self
        medicinePickerView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
      

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
        
        
        let scheduleSave = readTime()
        
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
            "priority": prioritySave,
            "schedule" : scheduleSave
            
            ] as [String : Any]
        
        
            guard let userID = Auth.auth().currentUser?.uid else {
            
            return
            }
        
            ref.child(userID).child("Patients").child(idPatientReceived).child("Medication").setValue(userDetails)

        }else {
        
        // Alert no medicine selected
        
        }
        
        
    }// End saveData Function
    
//MARK: infotable function
    
    func infoMedicines(){
        
        medicinesName.removeAll()
        
        dataBase(){ data in
            
            if data  == "ready" {
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                
            } else {print("No Medicines yet")
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                self.alertGeneral(errorDescrip: "No Medicines registered yet!", information: "Information")
                
            }// end IF
            
        }// End call dataBase function
        
    }//End func infoTable

    

//MARK: Function Read Data base Patients
    
    func dataBase(completion: @escaping (String) -> Void){
        
        //read Patient JSON
        let refPat = Database.database().reference().child("Medicines");
        
        
        refPat.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            guard let dataInJSON = snapshot.value as? NSDictionary  else {
                
                print("no data in daba base Patient")
                completion("NotFound")
                // by this part we know that doctor not exist so we send to Name VC
                
                
                return
            }
            
            
            for everyData in dataInJSON {
                
                guard let valuesKey = everyData.value as? NSDictionary else {
                    
                    return
                }
                
                
                guard let nameMedicine = valuesKey["name"] as? String else {
                    
                    return
                }
                //we add all the emails to Array
                self.medicinesName.append(nameMedicine)
                
                
            } //End for everyData in dataInJSON
            
            //check if the medicine exist and get its uid user ID
            
            completion("ready")
            
            
            
        }) { (error) in
            print(error.localizedDescription)
            
            self.alertGeneral(errorDescrip: error.localizedDescription, information: "Information")
            
        }// end json for Doctor
        
    }// end dataBase Function

    
    
    
 //MARK: readTime function
    func readTime()-> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let strTime = dateFormatter.string(from: scheduleDatePicker.date)
        
        
        return strTime
    }
    
//MARK: Picker View
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        
        return medicinesName.count
        
        
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
       
        
            return medicinesName[row]
        
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //  information to variable of the row selected
        pickerSelected = medicinesName[row]
        
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

