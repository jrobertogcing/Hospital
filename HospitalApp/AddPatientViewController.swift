//
//  AddPatientViewController.swift
//  HospitalApp
//
//  Created by Robert on 11/12/17.
//  Copyright © 2017 Robert González. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddPatientViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var lastnameTextField: UITextField!
    
    @IBOutlet weak var telephoneTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var addPatientButton: UIButton!
    
    //Variable for saveData
    var ref: DatabaseReference!
    
    var allNurseKeys = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPatientButtonAction(_ sender: UIButton) {
       
        activityIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        addPatientButton.isEnabled = false
        // check first if the patient is registered
        
        checkPatientDataBase(){ data in
            
            if data == "NotFound" {
                self.saveData() {  ready in
        
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
                    if  ready == "ready" {
            
                        self.alertGeneral(errorDescrip: "You have added a new Patient", information: "Information")
            
                    }//End if  ready == "ready"
                }//End saveData Function
            }else if data == "Found"{
            
                self.alertGeneral(errorDescrip: "This patient is already register", information: "Information")
                
            }//End if if data == "NotFound"
        }// End checkPatientDataBase Function
        
    }//End addPatientButtonAction

//MARK: function Save data
    func saveData(completion: @escaping (String) -> Void)  {
        
        guard let userNameTextSave = nameTextField.text, let userLastNameSave = lastnameTextField.text,  let userTelephoneTextSave = telephoneTextField.text,  let userEmailTextSave = emailTextField.text, userNameTextSave != "", userLastNameSave != "" , userTelephoneTextSave != "", userEmailTextSave != "" else{
            
            alertGeneral(errorDescrip: "Fill all the Fields", information: "Information")
            return
        }// End guard let
        
        guard let userID = Auth.auth().currentUser?.uid else {
            
            print("no user auth")
            
            return
        }

        ref = Database.database().reference().child("Nurse").child(userID)
        
        let key = ref.childByAutoId().key
        
        let userDetails = [
            "id":key,
            "name" : userNameTextSave,
            "lastName" : userLastNameSave,
            "telehpone" : userTelephoneTextSave,
            "email": userEmailTextSave
            ]
       // ref.setValue(userDetails)

        ref.child("Patients").child(key).setValue(userDetails){ (error, ref) -> Void in
            
            if error == nil {
                //completion("ready")
            } else if let error = error  {
                
                // alert general.
                self.alertGeneral(errorDescrip: error.localizedDescription, information: "Information")
            }// End  if error == nil
        }// End ref.child
        
        
        // save also in Patients
        
        ref = Database.database().reference().child("Patients")
        
        let userDetails2 = [
            
            "email": userEmailTextSave
        ]
        // ref.setValue(userDetails)
        
        ref.child(userID).child(key).setValue(userDetails2){ (error, ref) -> Void in
            
            if error == nil {
                completion("ready")
            } else if let error = error  {
                
                // alert general.
                self.alertGeneral(errorDescrip: error.localizedDescription, information: "Information")
            }// End  if error == nil
        }// End ref.child

    }// End saveData Function

    
//MARK: Function check patients registered
    
    func checkPatientDataBase(completion: @escaping (String) -> Void)  {
        
        
        guard let userNameTextSave = nameTextField.text, let userLastNameSave = lastnameTextField.text,  let userTelephoneTextSave = telephoneTextField.text,  let userEmailTextSave = emailTextField.text, userNameTextSave != "", userLastNameSave != "" , userTelephoneTextSave != "", userEmailTextSave != "" else{
            
            alertGeneral(errorDescrip: "Fill all the Fields", information: "Information")
            return
        }// End guard let
            
        //read Patient JSON
            let refPat = Database.database().reference().child("Patients");
            
            
            refPat.observeSingleEvent(of: .value, with: { (snapshot) in
                
                // Get user value
                guard let dataInJSON = snapshot.value as? NSDictionary  else {
                    
                    print("no data in daba base Patient")
                    completion("NotFound")
                    // by this part we know that doctor not exist so we send to Name VC
                    
                    
                    return
                }
                
                
                
                for everyData in dataInJSON {
                    
                   // guard let uidKey = everyData.key as? String else {
                        
                     //   return
                   // }
                    
                   // self.allNurseKeys.append(uidKey)
                    
                    
                    
                    guard let valuesKey = everyData.value as? NSDictionary else {
                        
                        return
                    }
                    
                    print("here1")
                    print(valuesKey)
                    
                    for everyData2  in valuesKey {
                        guard let values2 = everyData2.value as? NSDictionary else {
                    
                            return
                        }
                        
                        guard let userEmail = values2["email"] as? String else {
                            
                            return
                        }

                        //check if the user exist and get its uid user ID
                        if userEmail == userEmailTextSave {
                            
                            
                            completion("Found")
                            
                        }
                    }

                   
                    
                    
               }// END FOR 1
                
                
                
                completion("NotFound")
                
                
            }) { (error) in
                print(error.localizedDescription)
                self.alertGeneral(errorDescrip: error.localizedDescription, information: "Information")
                
            }// end json for Patient
            
        
    }// End func checkPatientDataBase

    
//MARK: Alert
    
    func alertGeneral(errorDescrip:String, information: String) {
        
        
        self.addPatientButton.isEnabled = true
        
        self.activityIndicator.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let alertGeneral = UIAlertController(title: information, message: errorDescrip, preferredStyle: .alert)
        
        let aceptAction = UIAlertAction(title: "Ok", style: .default)
        
        alertGeneral.addAction(aceptAction)
        present(alertGeneral, animated: true)
        
        
    }

}//End ViewController
