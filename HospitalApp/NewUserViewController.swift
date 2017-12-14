//
//  NewUserViewController.swift
//  HospitalApp
//
//  Created by Robert on 11/12/17.
//  Copyright © 2017 Robert González. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class NewUserViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var repeatPassTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailTextField.delegate = self;
        self.passwordTextField.delegate = self;
        self.repeatPassTextField.delegate = self;

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: Sing UP Button Action
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        
        activityIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        signUpButton.isEnabled = false
        signUpButton.isHighlighted = true
        
        guard  let nameCheck = emailTextField.text, let passwordCheck = passwordTextField.text, let repeatPassCheck = repeatPassTextField.text, nameCheck != "", passwordCheck != "", repeatPassCheck != "" else {
        
            alertGeneral(errorDescrip: "Fill all the Fields", information: "Information")
        return
        }//End Guard let
        
        if passwordCheck == repeatPassCheck {
            
            Auth.auth().createUser(withEmail: nameCheck, password: passwordCheck) { (user, error) in
             
                if error == nil {
                
                 print("Sign up OK")
                    
                    self.sendEmailVerification() { ready in
                        
                        if ready == "ready" {
                        
                            self.activityIndicator.stopAnimating()
                            
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            
                            self.alertEmailVerification(email: self.emailTextField.text!)
                        
                        }//End if ready == "ready"
                    }//End sendEmailVerification function
                    
                
                } else  if let error = error {
                
                    self.alertGeneral(errorDescrip: error.localizedDescription, information: "Information")
                
                }// End if error == nil
                
                
            }// End Auth
                
            
            
        }else {
        
        
            alertGeneral(errorDescrip: "The Passwords don't match", information: "Information")
        
        } //END passwordCheck == repeatPassCheck

        
    }// End function SignUPButtonAction
    
    
// MARK: sendEmailVerification
    
func sendEmailVerification(completion: @escaping (String) -> Void) {

    Auth.auth().currentUser?.sendEmailVerification(completion: {(error) in
        
        if let error = error{
            self.alertGeneral(errorDescrip: error.localizedDescription, information: "Information")
            
            print("Error sending email verification")
        }
        else
        {
            print("Email verification send")
            
            completion("ready")
            
        } //End let error = error
    }) // End Auth
    
}// End sendEmailVerification Function
    
    

//MARK : alertGeneral
    
func alertGeneral(errorDescrip:String, information: String) {
        
        signUpButton.isEnabled = true
        signUpButton.isHighlighted = false
        
        activityIndicator.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let alertGeneral = UIAlertController(title: information, message: errorDescrip, preferredStyle: .alert)
        
        let aceptAction = UIAlertAction(title: "Ok", style: .default)
        
        alertGeneral.addAction(aceptAction)
        present(alertGeneral, animated: true)
        
    }

    
    func alertEmailVerification(email:String) {
        
        signUpButton.isEnabled = true
        signUpButton.isHighlighted = false
        
        activityIndicator.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let message = NSLocalizedString("name.message", comment: "Ready")
        
        let alertGeneral = UIAlertController(title: "Required Email-Verification", message: message + " " + email, preferredStyle: .alert)
        
        let aceptAction = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            
            print("send to other VC")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            self.present(nextViewController, animated:true, completion:nil)
            
            nextViewController.emailTextField.text = email
            
            
            
        }//End Let acceptAction
        
        alertGeneral.addAction(aceptAction)
        present(alertGeneral, animated: true)
    
    }// End AlertEmailVerification
   

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}// End ViewController
