//
//  ResetPasswordViewController.swift
//  HospitalApp
//
//  Created by Robert on 11/12/17.
//  Copyright © 2017 Robert González. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ResetPasswordViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var activityAnimator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: resetButton Action

    @IBAction func resetButtonAction(_ sender: UIButton) {
        
        
        
        
    }
    
//MARK: Alerts
    
    
    func alertSendEmailReset(email:String) {
        
        let title = NSLocalizedString("reset.title", comment: "Ready!")
        let message = NSLocalizedString("reset.message", comment: "Ready!")
        
        
        let alertGeneral = UIAlertController(title: title, message: message + " " + email,  preferredStyle: .alert)
        
        let aceptAction = UIAlertAction(title: "Ok", style: .default)
        
        alertGeneral.addAction(aceptAction)
        present(alertGeneral, animated: true)
        
        
    }
    
    func alertGeneral(errorDescrip:String, information: String) {
        
        
        let alertGeneral = UIAlertController(title: information, message: errorDescrip, preferredStyle: .alert)
        
        let aceptAction = UIAlertAction(title: "Ok", style: .default)
        
        alertGeneral.addAction(aceptAction)
        present(alertGeneral, animated: true)
        
        
    }
    

    
    
   

}//End ViewController

