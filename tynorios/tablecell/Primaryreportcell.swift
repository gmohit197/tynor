//
//  Primaryreportcell.swift
//  tynorios
//
//  Created by Acxiom Consulting on 27/10/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import UIKit

class Primaryreportcell: UITableViewCell {
    
    @IBOutlet weak var createdby: UILabel!
    @IBOutlet weak var orderno: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var customername: UILabel!
      @IBOutlet var logicSoNo: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
