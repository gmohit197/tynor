//
//  Escalationreportcell.swift
//  tynorios
//
//  Created by Acxiom Consulting on 13/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class Escalationreportcell: UITableViewCell {

    @IBOutlet weak var escalationno: UILabel!
    @IBOutlet weak var customername: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var reason: UILabel!
    @IBOutlet weak var custtype: UILabel!
    @IBOutlet weak var createdby: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
