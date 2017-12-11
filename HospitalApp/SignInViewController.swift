//
//  SignInViewController.swift
//  HospitalApp
//
//  Created by Robert on 11/12/17.
//  Copyright © 2017 Robert González. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignInViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var newUserButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // If someOne is already SignIn, SignOut.
        try! Auth.auth().signOut()

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: Log in Button
    
    @IBAction func logInButtonAction(_ sender: UIButton){
        
        activityIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        logInButton.isEnabled = false
        newUserButton.isEnabled = false
        resetButton.isEnabled = false

        
        
        signInUser() { ready in
            
            
            // check if the user is registered
            // CHECK HERE IF THE EMAIL IS VERIFIED

            if ready == true {
            
            
                self.activityIndicator.stopAnimating()
                
                self.dataBaseNurse() { name, lastName in
                
                    if name != "" {
                    
                    self.sendToVCNurce()
                    
                    
                    } else {
                    
                    
                    self.alertGeneral(errorDescrip: "Not registered", information: "Information")
                    
                    
                    }
                
                
                }

            
            }
        
        
        }
    
    }// End logInButtonAction
    
//MARK: function SignUP
    
    func signInUser (completion: @escaping (Bool) -> Void ){
        
        
        guard let nameText = emailTextField.text, let passwordText = passwordTextField.text, nameText != "", passwordText != "" else {
            
            alertGeneral(errorDescrip: "Fill all the fields", information: "Information")
            
            completion(false)
            return
        }
        
        
    }// End func signInUser

    
//MARK: function search Nurse
    
    func dataBaseNurse(completion: @escaping (String, String) -> Void) {
        
        guard let userID = Auth.auth().currentUser?.uid else {
            
            print("no user auth")
            
            return
        }// End guard UserID
        
        
        // check in Json "Doctor"
        let ref = Database.database().reference().child("Nurce").child(userID);
        
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            // Get user value
            guard let dataInJSON = snapshot.value as? NSDictionary  else {
                
                print("no data in daba base Doctor")
                
                
                completion("No", "No")
                
                return
            }
            
            guard let name = dataInJSON["name"]  else {
                
                completion("No", "No")
                return
            }
            
            
            guard let lastName = dataInJSON["lastName"]  else {
                
                completion("No", "No")
                return
            }
            
            
            
            completion(name as! String, lastName as! String)
            
            
            
            
        }) { (error) in
            print(error.localizedDescription)
            
            self.alertGeneral(errorDescrip: error.localizedDescription, information: "Information")
            
            
            
        }// end json for Doctor
        
        
        
    }// End func dataBaseNurse

    
//MARK: Alert
    
    func alertGeneral(errorDescrip:String, information: String) {
            self.logInButton.isEnabled = true
            self.newUserButton.isEnabled = true
            self.resetButton.isEnabled = true
        
        
        self.activityIndicator.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let alertGeneral = UIAlertController(title: information, message: errorDescrip, preferredStyle: .alert)
        
        let aceptAction = UIAlertAction(title: "Ok", style: .default)
        
        alertGeneral.addAction(aceptAction)
        present(alertGeneral, animated: true)
        
        
    }

//MARK: function send to WELCOME NURSE ,
    
    func sendToVCNurce(){
        
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NurseUITabBarController") as! NurseUITabBarController
        self.present(nextViewController, animated:true, completion:nil)
        
        
    }
    

}// End ViewController











