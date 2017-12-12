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
        
        saveData() {  ready in
        
            self.activityIndicator.stopAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if  ready == "ready" {
            
                self.alertGeneral(errorDescrip: "You have added a new Patient", information: "Information")
            
            }
        
        }
        
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
                completion("ready")
            } else if let error = error  {
                
                // alert general.
                self.alertGeneral(errorDescrip: error.localizedDescription, information: "Information")
            }// End  if error == nil
        }// End ref.child
    }// End saveData Function

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
