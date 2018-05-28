//
//  DetailBSTableViewCell.swift
//  Barbershops Moscow
//
//  Created by Alan on 20/05/2018.
//  Copyright © 2018 Alan. All rights reserved.
//

import UIKit

class DetailBSTableViewCell: UITableViewCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
