//
//  MedicationTableViewCell.swift
//  HospitalApp
//
//  Created by Robert on 12/12/17.
//  Copyright © 2017 Robert González. All rights reserved.
//

import UIKit

class MedicationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameMedicineLabel: UILabel!
    
    @IBOutlet weak var scheduleTimeLabel: UILabel!
    
    @IBOutlet weak var dosageLabel: UILabel!
    
    @IBOutlet weak var typeDosageLabel: UILabel!
    
    @IBOutlet weak var priorityLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
