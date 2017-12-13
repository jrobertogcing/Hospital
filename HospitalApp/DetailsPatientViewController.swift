//
//  DetailsPatientViewController.swift
//  HospitalApp
//
//  Created by Robert on 12/12/17.
//  Copyright © 2017 Robert González. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase



class DetailsPatientViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var patientNameLabel: UILabel!
    
    @IBOutlet weak var medicationTableView: UITableView!
    
    //variables
    var arrayA = ["matute", "thor", "canela pachona y gordita"]
    var namePatientReceived = ""
    var idPatientReceived = ""
    
    var medicineBaseArray = [String]()
    var dosageBaseArray = [String]()
    var priorityBaseArray = [Int]()
    var scheduleBaseArray = [String]()
    var typeDosageBaseArray = [Int]()

    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        patientNameLabel.text = namePatientReceived
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        medicationTableView.delegate = self
        medicationTableView.dataSource = self
        
        let nibName = UINib(nibName: "MedicationTableViewCell", bundle: Bundle.main)
        
        medicationTableView.register(nibName, forCellReuseIdentifier: "MedicationTableViewCell")
        
       // call function to read data base
        infoTable()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
//MARK: Table ViewController
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicineBaseArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = medicationTableView.dequeueReusableCell(withIdentifier: "MedicationTableViewCell", for: indexPath)
        
        guard let medicationCell = cell as? MedicationTableViewCell else {return cell}
        
        medicationCell.nameMedicineLabel.text = "Medicine: \(medicineBaseArray[indexPath.row])"
        medicationCell.dosageLabel.text = "Dosage: \(dosageBaseArray[indexPath.row])"
        medicationCell.scheduleTimeLabel.text = "Schedule: \(scheduleBaseArray[indexPath.row])"
        
        var priorityValue = ""
        switch priorityBaseArray[indexPath.row] {
        case 0:
            priorityValue = "High"
        case 1:
            priorityValue = "Medium"
        case 2:
            priorityValue = "Low"
        
        default:  priorityValue = "No"
        }
        
        
        var dosageTypeValue = ""
        switch typeDosageBaseArray[indexPath.row] {
        case 0:
            dosageTypeValue = "ml."
        case 1:
            dosageTypeValue = "Pills"
            
        default:  priorityValue = "No"
        }

        
        medicationCell.priorityLabel.text = priorityValue
        
        medicationCell.typeDosageLabel.text = dosageTypeValue

        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
        
    }
    
//MARK: prepare segue send ID and name
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AssignMedicineViewController" {
            if let destinationVC = segue.destination as? AssignMedicineViewController {
                
                destinationVC.nameReceived = namePatientReceived
                destinationVC.idPatientReceived = idPatientReceived
                
            }//End if
        }//End if
        
    }// end preparefor segue
    

    
    func infoTable(){
        
               
        dosageBaseArray.removeAll()
        medicineBaseArray.removeAll()
        priorityBaseArray.removeAll()
        scheduleBaseArray.removeAll()
        typeDosageBaseArray.removeAll()

        
        dataBase(){ data in
            
            
            if data  == "ready" {
                
                self.medicationTableView.reloadData()
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                //self.patientsTableView.isUserInteractionEnabled = true
                
            } else {print("No patients yet")
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                self.alertGeneral(errorDescrip: "No medication registered yet!", information: "Information")
                
            }//End if data  == "ready"
        }//End call dataBase function
    }// End func infoTable
    
//MARK: Function Read Data base PatientsMedication
    
    func dataBase(completion: @escaping (String) -> Void){
        
        
        
        guard let userID = Auth.auth().currentUser?.uid else {
            
            print("no user auth")
            
            return
        }
        
        
        // check in Json "Doctor"
        let ref = Database.database().reference().child("Nurse").child(userID).child("Patients").child(idPatientReceived).child("Medication");
        
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            // Get user value
            guard let dataInJSON = snapshot.value as? NSDictionary  else {
                
                print("no data in daba base Information")
                
                
                completion("No")
                
                return
            }
            
          
            
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
