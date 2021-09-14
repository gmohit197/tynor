//
//  UploadSyncLogcell.swift
//  tynorios
//
//  Created by Acxiom Consulting on 17/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class UploadSyncLogcell: UITableViewCell {

    
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var imagelbl: UIImageView!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var pendinglbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
