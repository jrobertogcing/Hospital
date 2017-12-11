//
//  NewUserViewController.swift
//  HospitalApp
//
//  Created by Robert on 11/12/17.
//  Copyright © 2017 Robert González. All rights reserved.
//

import UIKit

class NewUserViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var repeatPassTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        
        
    }// End function SignUPButtonAction
    
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

   

}// End ViewController
