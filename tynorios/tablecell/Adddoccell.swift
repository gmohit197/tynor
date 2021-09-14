//
//  Adddoccell.swift
//  tynorios
//
//  Created by Acxiom Consulting on 27/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class Adddoccell: UITableViewCell {

    @IBOutlet weak var hostype: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var hosname: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
