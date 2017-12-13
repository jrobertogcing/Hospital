//
//  PatientsViewController.swift
//  HospitalApp
//
//  Created by Robert on 12/12/17.
//  Copyright © 2017 Robert González. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class PatientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var patientsTableView: UITableView!
    

    var arrayA = ["matute", "thor", "canela pachona y gordita"]
    var arrayObject :[JSONManager] = []
    
    //variables
    var ref: DatabaseReference!
    
    var patientsKeys = [String]()
    var patientsName = [String]()
    var patientsLastname = [String]()
    var patientsTelephone = [String]()
    var patientsEmail = [String]()
    var patientsUser = [String]()
    var patientsIDs = [String]()


    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        patientsTableView.delegate = self
        patientsTableView.dataSource = self
        
        let nibName = UINib(nibName: "PatientsTableViewCell", bundle: Bundle.main)
        
        patientsTableView.register(nibName, forCellReuseIdentifier: "PatientsTableViewCell")
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        patientsTableView.isUserInteractionEnabled = false
        
        //call dataBase JSON and inf not, send Alert No Patients Yet
        infoTable()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: information for table
    
    func infoTable(){
        
        patientsKeys.removeAll()
        patientsName.removeAll()
        patientsLastname.removeAll()
        patientsTelephone.removeAll()
        patientsEmail.removeAll()
        
        dataBase(){ data in
            
            if data  == "ready" {
                
                
                    self.patientsTableView.reloadData()
                    
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.patientsTableView.isUserInteractionEnabled = true
                
            } else {print("No patients yet")
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                self.alertGeneral(errorDescrip: "No Patients registered yet!", information: "Information")
                
            }
            
            
            
        }
        
        
    }

    
    
//MARK: Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientsName.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
    let cell = patientsTableView.dequeueReusableCell(withIdentifier: "PatientsTableViewCell", for: indexPath)
       
        guard let patientsCell = cell as? PatientsTableViewCell else {return cell}

        
        patientsCell.nameCellLabel.text = "Name: \(patientsName[indexPath.row])"
        patientsCell.lastnameCellLabel.text = "Lastname: \(patientsLastname[indexPath.row])"
        patientsCell.telephoneCellLabel.text = "Telephone: \(patientsTelephone[indexPath.row])"
        patientsCell.emailCellLabel.text = "Email: \(patientsEmail[indexPath.row])"
        return cell

        
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DetailsPatientViewController") as! DetailsPatientViewController
        
        // send name to next Details View Controller
        
        nextViewController.namePatientReceived = "\(patientsName[indexPath.row]) \(patientsLastname[indexPath.row])"
        
        // send also the ID of the patient to save information to it in the next ViewController.
        nextViewController.idPatientReceived = patientsIDs[indexPath.row]
        
        //self.present(nextViewController, animated:true, completion:nil)
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    
    
//MARK: Function Read Data base Patients
    
    func dataBase(completion: @escaping (String) -> Void){
        
        
        
        guard let userID = Auth.auth().currentUser?.uid else {
            
            print("no user auth")
            
            return
        }
        
        
// check in Json "Doctor"
        let ref = Database.database().reference().child("Nurse").child(userID).child("Patients");
        
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            // Get user value
            guard let dataInJSON = snapshot.value as? NSDictionary  else {
                
                print("no data in daba base Information")
                
                
                completion("No")
                
                return
            }
            
            
            for everyData in dataInJSON {
                
                
                guard let patientsKey = everyData.key as? String else {
                    
                    return
                }
                
                self.patientsKeys.append(patientsKey)
                
                guard let patientsValue = everyData.value as? NSDictionary else {
                    
                    return
                }
                
                guard let namePatient = patientsValue["name"] as? String else {
                    
                    return
                }
                guard let lastnamePatient = patientsValue["lastName"] as? String else {
                    
                    
                    return
                }
                guard let telephonePatient = patientsValue["telehpone"] as? String else {

                    return
                }
                guard let emailPatient = patientsValue["email"] as? String else {
                    

                    return
                }
                
                guard let idPatient = patientsValue["id"] as? String else {
                    
                    
                    return
                }
                
                self.patientsName.append(namePatient)
                self.patientsLastname.append(lastnamePatient)
                self.patientsTelephone.append(telephonePatient)
                self.patientsEmail.append(emailPatient)
                self.patientsIDs.append(idPatient)
                

                
            }// End  for everyData in dataInJSON
            
            
            completion("ready")
            
            
            
        }) { (error) in
            print(error.localizedDescription)
            
            self.alertGeneral(errorDescrip: error.localizedDescription, information: "Information")
            
        }// end json for Doctor
        
    }// end dataBase Function

//MARK : alertGeneral
    
    func alertGeneral(errorDescrip:String, information: String) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let alertGeneral = UIAlertController(title: information, message: errorDescrip, preferredStyle: .alert)
        
        let aceptAction = UIAlertAction(title: "Ok", style: .default)
        
        alertGeneral.addAction(aceptAction)
        present(alertGeneral, animated: true)
        
    }
    
 

  
}// End ViewController
