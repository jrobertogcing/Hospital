//
//  MedicinesViewController.swift
//  HospitalApp
//
//  Created by Robert on 12/12/17.
//  Copyright © 2017 Robert González. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MedicinesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arrayA = ["matute", "thor", "canela pachona y gordita"]
    var arrayObject :[JSONManager] = []
    
    //variables
    var ref: DatabaseReference!
    
    var medicinesName = [String]()

    
    
    @IBOutlet weak var medicinesTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        medicinesTableView.delegate = self
        medicinesTableView.dataSource = self
        
        let nibName = UINib(nibName: "MedicinesTableViewCell", bundle: Bundle.main)
        
        medicinesTableView.register(nibName, forCellReuseIdentifier: "MedicinesTableViewCell")

        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        medicinesTableView.isUserInteractionEnabled = false
        
        // call function for read data base
        infoTable()
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func infoTable(){
        
        medicinesName.removeAll()
        
        dataBase(){ data in
            
            if data  == "ready" {
                
                
                self.medicinesTableView.reloadData()
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.medicinesTableView.isUserInteractionEnabled = true
                
                
                
            } else {print("No patients yet")
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                self.alertGeneral(errorDescrip: "No Medicines registered yet!", information: "Information")
                
            }// end IF
            
        }// End call dataBase function
        
    }//End func infoTable
    

    
//MARK: Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicinesName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = medicinesTableView.dequeueReusableCell(withIdentifier: "MedicinesTableViewCell", for: indexPath)
        
        guard let medicinesCell = cell as? MedicinesTableViewCell else {return cell}
        
        medicinesCell.medicineNameLabel.text = "Name: \(medicinesName[indexPath.row])"

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DetailsMedicineViewController") as! DetailsMedicineViewController
        
        // send name to next Details View Controller
        nextViewController.nameMedicineReceived = medicinesName[indexPath.row]
        
        self.present(nextViewController, animated:true, completion:nil)
        
        
    }
    
    
//MARK: Function Read Data base Patients
    
    func dataBase(completion: @escaping (String) -> Void){
        
        //read Patient JSON
        let refPat = Database.database().reference().child("Medicines");
        
        
        refPat.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            guard let dataInJSON = snapshot.value as? NSDictionary  else {
                
                print("no data in daba base Patient")
                completion("NotFound")
                // by this part we know that doctor not exist so we send to Name VC
                
                
                return
            }
            
            
            for everyData in dataInJSON {
                
                guard let valuesKey = everyData.value as? NSDictionary else {
                    
                    return
                }
                
                
                guard let nameMedicine = valuesKey["name"] as? String else {
                    
                    return
                }
                //we add all the emails to Array
                self.medicinesName.append(nameMedicine)

                
            } //End for everyData in dataInJSON
            
            //check if the medicine exist and get its uid user ID
            
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
    
    
    

}
