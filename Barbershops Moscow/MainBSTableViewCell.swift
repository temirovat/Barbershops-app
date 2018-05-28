//
//  MainBSTableViewCell.swift
//  Barbershops Moscow
//
//  Created by Alan on 18/05/2018.
//  Copyright © 2018 Alan. All rights reserved.
//

import UIKit

class MainBSTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundImage: UIImageView!
    

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var review: UILabel!

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
