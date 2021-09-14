//
//  Competitorcell.swift
//  tynorios
//
//  Created by Acxiom Consulting on 23/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class Competitorcell: UITableViewCell {

    
    @IBOutlet weak var sno: UILabel!
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var product: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var colorlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
