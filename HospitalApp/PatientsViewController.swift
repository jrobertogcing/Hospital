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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        patientsTableView.delegate = self
        patientsTableView.dataSource = self
        
        let nibName = UINib(nibName: "PatientsTableViewCell", bundle: Bundle.main)
        
        patientsTableView.register(nibName, forCellReuseIdentifier: "PatientsTableViewCell")
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayA.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    //let cell = tableViewTours.dequeueReusableCell(withIdentifier: "ToursTableViewCell", for: indexPath)
        
    let cell = patientsTableView.dequeueReusableCell(withIdentifier: "PatientsTableViewCell", for: indexPath)
       
        guard let patientsCell = cell as? PatientsTableViewCell else {return cell}

        //patientsCell.tituloLabelCell.text = arrayA[indexPath.row]
        
        patientsCell.nameCellLabel.text = arrayA[indexPath.row]
    
        
        
        return cell

        
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
        
    }

    

  
}
