//
//  TableCell.swift
//  PharmacyOnDuty
//
//  Created by Furkan Ayşavkı on 17.03.2022.
//

import UIKit

class TableCell: UITableViewCell {
    
    
    @IBOutlet weak var adressName: UILabel!
    
    @IBOutlet weak var districtName: UILabel!
    
    @IBOutlet weak var pharmacyNameLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
