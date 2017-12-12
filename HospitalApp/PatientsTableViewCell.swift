//
//  PatientsTableViewCell.swift
//  HospitalApp
//
//  Created by Robert on 12/12/17.
//  Copyright © 2017 Robert González. All rights reserved.
//

import UIKit

class PatientsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameCellLabel: UILabel!
    
    @IBOutlet weak var lastnameCellLabel: UILabel!
    
    @IBOutlet weak var telephoneCellLabel: UILabel!
    
    @IBOutlet weak var emailCellLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
