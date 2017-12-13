//
//  DetailsMedicineViewController.swift
//  HospitalApp
//
//  Created by Robert on 12/12/17.
//  Copyright © 2017 Robert González. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DetailsMedicineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var detailsMedicineTableView: UITableView!
    
    @IBOutlet weak var medicineNameLabel: UILabel!
    
    var nameMedicineReceived = ""
    
    
    var arrayA = ["matute", "thor", "canela pachona y gordita"]
   
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        medicineNameLabel.text = nameMedicineReceived

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        detailsMedicineTableView.delegate = self
        detailsMedicineTableView.dataSource = self
        
        let nibName = UINib(nibName: "PatientMedicationTableViewCell", bundle: Bundle.main)
        
        detailsMedicineTableView.register(nibName, forCellReuseIdentifier: "PatientMedicationTableViewCell")
        
        // call function to read data base
        infoTable()

        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

func infoTable(){
        
        //medicinesName.removeAll()
        
        dataBase(){ data in
            
            if data  == "ready" {
                
                
                self.detailsMedicineTableView.reloadData()
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.detailsMedicineTableView.isUserInteractionEnabled = true
                
                
                
            } else {print("No patients yet")
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                self.alertGeneral(errorDescrip: "No patient assigned for this medicine yet!", information: "Information")
                
            }// end IF
            
        }// End call dataBase function
        
    }//End func infoTable
    
//MARK: Table ViewController
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayA.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = detailsMedicineTableView.dequeueReusableCell(withIdentifier: "PatientMedicationTableViewCell", for: indexPath)
        
        guard let medicationCell = cell as? PatientMedicationTableViewCell else {return cell}
        
        medicationCell.namePatientLabel.text = "Name: \(arrayA[indexPath.row])"
        
        return cell
        
    }
    
    
//MARK: Function Read Data base Patients
    
    func dataBase(completion: @escaping (String) -> Void){
        
        
        guard let userID = Auth.auth().currentUser?.uid else {
            
            print("no user auth")
            
            return
        }

        
        //read Patient JSON
        // check in Json "Doctor"
        let ref = Database.database().reference().child("Nurse").child(userID).child("Patients")
        //.child(idPatientReceived).child("Medication");
        
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            guard let dataInJSON = snapshot.value as? NSDictionary  else {
                
                print("no data in daba base Patient")
                completion("NotFound")
                return
            }
            
           // print(dataInJSON)
            
            for everyData in dataInJSON {
            
                guard let patientsValue = everyData.value as? NSDictionary else {
                    
                    print("no data")
                    return
                }
                
                
                guard let medicationBase  = patientsValue["Medication"] as? NSDictionary else {
                    
                    print("no medicationBase")
                    continue
                }
                
                guard let dosageBase = medicationBase.key as? String else {
                    
                    return
                }
            
            
            }//End  for everyData in dataInJSON
            
            /*
            for everyData in dataInJSON {
                
                
                guard let patientsValue = everyData.value as? NSDictionary else {
                    
                    print("no data")
                    return
                }
                
                
                guard let dosageBase = patientsValue["dosage"] as? String else {
                    
                    return
                }
                
                guard let medicineBase = patientsValue["medicine"] as? String else {
                    
                    return
                }
                
                guard let priorityBase = patientsValue["priority"] as? Int else {
                    
                    return
                }
                
                guard let scheduleBase = patientsValue["schedule"] as? String else {
                    
                    return
                }
                
                guard let typeDosageBase = patientsValue["typeDosage"] as? Int else {
                    
                    return
                }
                
                print(typeDosageBase)
                
                
                self.dosageBaseArray.append(dosageBase)
                self.medicineBaseArray.append(medicineBase)
                self.priorityBaseArray.append(priorityBase)
                self.scheduleBaseArray.append(scheduleBase)
                self.typeDosageBaseArray.append(typeDosageBase)
                
                
                
            }// End  for everyData in dataInJSON
            */
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
        
    }//End Alert General
}// End ViewController
