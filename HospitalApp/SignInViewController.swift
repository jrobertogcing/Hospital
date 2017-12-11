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
        
        
    
    }// End logInButtonAction
    
//MARK: function SignUP
    
    func signInUser (completion: @escaping (Bool) -> Void ){
        
        
        guard let nameText = emailTextField.text, let passwordText = passwordTextField.text, nameText != "", passwordText != "" else {
            
          //  alertGeneral(errorDescrip: strFill, information: strInfo)
            
            completion(false)
            return
        }
        
        
    }// End func signInUser

   
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

    
    

}// End ViewController











