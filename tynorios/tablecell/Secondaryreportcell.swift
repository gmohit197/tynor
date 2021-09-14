//
//  Secondaryreportcell.swift
//  tynorios
//
//  Created by Acxiom Consulting on 29/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class Secondaryreportcell: UITableViewCell {
    
    @IBOutlet weak var orderno: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var customername: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
