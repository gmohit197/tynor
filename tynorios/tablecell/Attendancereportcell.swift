//
//  Attendancereportcell.swift
//  tynorios
//
//  Created by Acxiom Consulting on 10/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class Attendancereportcell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var dayend: UILabel!
    @IBOutlet weak var daystart: UILabel!
    @IBOutlet weak var usercode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
