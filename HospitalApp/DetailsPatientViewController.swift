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


    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        patientNameLabel.text = namePatientReceived
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        medicationTableView.delegate = self
        medicationTableView.dataSource = self
        
        let nibName = UINib(nibName: "MedicationTableViewCell", bundle: Bundle.main)
        
        medicationTableView.register(nibName, forCellReuseIdentifier: "MedicationTableViewCell")
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
//MARK: Table ViewController
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayA.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = medicationTableView.dequeueReusableCell(withIdentifier: "MedicationTableViewCell", for: indexPath)
        
        guard let medicationCell = cell as? MedicationTableViewCell else {return cell}
        
        medicationCell.nameMedicineLabel.text = arrayA[indexPath.row]
        
        
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
    
//MARK : alertGeneral
    
    func alertGeneral(errorDescrip:String, information: String) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let alertGeneral = UIAlertController(title: information, message: errorDescrip, preferredStyle: .alert)
        
        let aceptAction = UIAlertAction(title: "Ok", style: .default)
        
        alertGeneral.addAction(aceptAction)
        present(alertGeneral, animated: true)
        
    }//End Alert General
    

}// End ViewController
