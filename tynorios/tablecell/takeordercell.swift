//
//  takeordercell.swift
//  tynorios
//
//  Created by Acxiom Consulting on 03/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class takeordercell: UITableViewCell {

@IBOutlet weak var sono: UILabel!
@IBOutlet weak var date: UILabel!
@IBOutlet weak var amount: UILabel!
@IBOutlet weak var payamt: UILabel!
@IBOutlet weak var qty: UILabel!
@IBOutlet weak var status: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
