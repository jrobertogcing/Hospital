//
//  AddMedicineViewController.swift
//  HospitalApp
//
//  Created by Robert on 12/12/17.
//  Copyright © 2017 Robert González. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddMedicineViewController: UIViewController {
    
    
    @IBOutlet weak var nameMedicineLabel: UITextField!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var addMedicineButton: UIButton!
    
    //Variable for saveData
    var ref: DatabaseReference!
    
    var allMedicinesName = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addMedicineButtonAction(_ sender: UIButton) {
        
        activityIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        addMedicineButton.isEnabled = false
        
        // check first if the patient is registered
        checkMedicineDataBase() {data in
            
            
            if data == "NotFound" {
                
                self.saveData() { ready in
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    if  ready == "ready" {
                        
                        guard let emailUser = self.nameMedicineLabel.text else {
                            return
                        }
                        self.alertGeneral(errorDescrip: "You have added a new Medicine: \(emailUser)", information: "Information")
                        self.nameMedicineLabel.text = ""
                       // self.lastnameTextField.text = ""
                       // self.telephoneTextField.text = ""
                       // self.emailTextField.text = ""
                        
                    }//End if  ready == "ready"
                    
                }//End saveData Function
                
            }else if data == "Found"{
            
            
            self.alertGeneral(errorDescrip: "This medicine is already register", information: "Information")
            
            }//End if data == "NotFound"
           
        }

        
    }// End addMedicineButtonAction
    
    //MARK: Function check patients registered
    
    func checkMedicineDataBase(completion: @escaping (String) -> Void)  {
        
        
        guard let medicineNameTextSave = nameMedicineLabel.text, medicineNameTextSave != "" else{
            
            alertGeneral(errorDescrip: "Fill all the Fields", information: "Information")
            return
        }// End guard let
        
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
                self.allMedicinesName.append(nameMedicine)

            
            } //End for everyData in dataInJSON
            
            //check if the medicine exist and get its uid user ID
            
            
                // Chek if the medicine exist, caseInsensitive
                let searchToSearch = medicineNameTextSave

                let itemExists = self.allMedicinesName.contains(where: {
                    $0.range(of: searchToSearch, options: .caseInsensitive) != nil
                })
                
            if itemExists == true {
                
                    completion("Found")
                
                
            } else {
                
                completion("NotFound")
                
            }// End if self.allMedicinesName.contains
            
            //test
            
           
        
        }) { (error) in
            print(error.localizedDescription)
            self.alertGeneral(errorDescrip: error.localizedDescription, information: "Information")
            
            }// end json for Patient
        
    }// End func checkPatientDataBase

    
//MARK: function Save data
    func saveData(completion: @escaping (String) -> Void)  {
        
       guard let medicineNameTextSave = nameMedicineLabel.text, medicineNameTextSave != "" else{
            
            alertGeneral(errorDescrip: "Fill all the Fields", information: "Information")
            return
        }// End guard let
        
        
        ref = Database.database().reference().child("Medicines")
        
        let key = ref.childByAutoId().key
        
        let userDetails = [
            "id":key,
            "name" : medicineNameTextSave
            
        ]
        // ref.setValue(userDetails)
        
        ref.child(key).setValue(userDetails){ (error, ref) -> Void in
            
            if error == nil {
                completion("ready")
            } else if let error = error  {
                
                // alert general.
                self.alertGeneral(errorDescrip: error.localizedDescription, information: "Information")
            }// End  if error == nil
        }// End ref.child
        
    }// End saveData Function
    
    
    //MARK: Alert
    
    func alertGeneral(errorDescrip:String, information: String) {
        
        
        self.addMedicineButton.isEnabled = true
        
        self.activityIndicator.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let alertGeneral = UIAlertController(title: information, message: errorDescrip, preferredStyle: .alert)
        
        let aceptAction = UIAlertAction(title: "Ok", style: .default)
        
        alertGeneral.addAction(aceptAction)
        present(alertGeneral, animated: true)
        
        
    }
    
    

   
}//End ViewController

