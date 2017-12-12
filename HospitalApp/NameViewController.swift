//
//  NameViewController.swift
//  HospitalApp
//
//  Created by Robert on 11/12/17.
//  Copyright © 2017 Robert González. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class NameViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var lastnameTextField: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var userSignInLabel: UILabel!
    
    
    //Variable for saveData
    var ref: DatabaseReference!
    var userSignIn = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //check if the user is online
        
        Auth.auth().addStateDidChangeListener { auth, user in
                if let user = user {
                
                    print("User is signed in.")
                
                    self.userSignInLabel.text = user.email
                
                    self.userSignIn = user.email!
                
                } else {
                self.userSignInLabel.text = "no user online"
                }// Endif let user = user
            }//End Auth
    } //End viewDidLoad

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: nextButtonAction
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        
        activityIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        nextButton.isEnabled = false

        saveData(){ ready in
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            // send to the next NurseUIViewController
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NurseUITabBarController") as! NurseUITabBarController
                        
            self.present(nextViewController, animated:true, completion:nil)
            
        
        
        }//End SaveData Function
        
        
        
    }//End nextButtonAction
    
    
//MARK: function Save data
    func saveData(completion: @escaping (String) -> Void)  {
        
        guard let userNameTextSave = nameTextField.text, let userLastNameSave = lastnameTextField.text, userNameTextSave != "", userLastNameSave != "" else{
            
            alertGeneral(errorDescrip: "Fill all the Fields", information: "Information")
            return
        }// End guard let
        
        
        ref = Database.database().reference().child("Nurse")
        
        
        let key = ref.childByAutoId().key
        
        let userDetails = [
            "user" : userSignIn,
            "id":key,
            "name" : userNameTextSave,
            "lastName" : userLastNameSave,
            ]
        
        guard let userID = Auth.auth().currentUser?.uid else {
            
            return
        }// End guard let userID
        
        ref.child(userID).setValue(userDetails){ (error, ref) -> Void in
            
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
        
        
        self.nextButton.isEnabled = true
        
        self.activityIndicator.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let alertGeneral = UIAlertController(title: information, message: errorDescrip, preferredStyle: .alert)
        
        let aceptAction = UIAlertAction(title: "Ok", style: .default)
        
        alertGeneral.addAction(aceptAction)
        present(alertGeneral, animated: true)
        
        
    }
    
}// End ViewController
