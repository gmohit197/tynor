//
//  AttachChemistcell.swift
//  tynorios
//
//  Created by Acxiom Consulting on 07/12/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class AttachChemistcell: UITableViewCell {
    
    @IBOutlet weak var chemistid: UILabel!
    @IBOutlet weak var chemistname: UILabel!
    @IBOutlet weak var mobileno: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
