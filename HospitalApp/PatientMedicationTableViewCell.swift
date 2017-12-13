//
//  PatientMedicationTableViewCell.swift
//  HospitalApp
//
//  Created by Robert on 13/12/17.
//  Copyright © 2017 Robert González. All rights reserved.
//

import UIKit

class PatientMedicationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var namePatientLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
