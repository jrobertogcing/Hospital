//
//  NurseViewController.swift
//  HospitalApp
//
//  Created by Robert on 11/12/17.
//  Copyright © 2017 Robert González. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class NurseViewController: UIViewController {

    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var numberPatientsLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var numberOfPatients = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        activityIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        dataBase() { ready in
            
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if ready == "No" {
                
                self.numberPatientsLabel.text = "0"
                
            }// End if data == No
        
        
        }// End dataBase Function
      
    }// End viewDidLoad

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // MARK: function Read Doctor name
    
    func dataBase(completion: @escaping (String) -> Void){
        
        
        
        guard let userID = Auth.auth().currentUser?.uid else {
            
            print("no user auth")
            
            return
        }
        
        
        // check in Json "Doctor"
        let ref = Database.database().reference().child("Nurse").child(userID);
        
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            // Get user value
            guard let dataInJSON = snapshot.value as? NSDictionary  else {
                
                print("no data in daba base Information")
                
                
                completion("No")
                
                return
            }
            
            
            
            guard let name = dataInJSON["name"]  else {
                
                completion("No")
                return
            }
            
            
            guard let lastName = dataInJSON["lastName"]  else {
                
                completion("No")
                return
            }
            
            
            let fullName = (name as! String) + " " + (lastName as! String)
            
            self.nameLabel.text = fullName
            
            
            
            // for number of patients
            
            
            guard let patients = dataInJSON["Patients"] as? NSDictionary else {
                
                completion("No")
                
                return
            }
            
            
            self.numberOfPatients = patients.count
            
           // print("patients count")
           // print(patients.count)
            
            self.numberPatientsLabel.text = String(patients.count)
            
            
            completion("Ready")
            
            
            
            
        }) { (error) in
            
            self.alertGeneral(errorDescrip: error.localizedDescription, information: "Information")
            
            
        }// end json for Doctor
        
    }

//MARK: Alerts
    
    
    
    func alertGeneral(errorDescrip:String, information: String) {
        
        activityIndicator.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
       // self.addButton.isEnabled = true
        activityIndicator.stopAnimating()
        
        self.view.isUserInteractionEnabled = true
        
        
        let alertGeneral = UIAlertController(title: information, message: errorDescrip, preferredStyle: .alert)
        
        let aceptAction = UIAlertAction(title: "Ok", style: .default)
        
        alertGeneral.addAction(aceptAction)
        present(alertGeneral, animated: true)
        
        
        
        
    }

}//End ViewController



