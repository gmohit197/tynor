//
//  Reasonordercell.swift
//  tynorios
//
//  Created by Acxiom Consulting on 17/01/19.
//  Copyright © 2019 Acxiom. All rights reserved.
//

import UIKit

class Reasonordercell: UICollectionViewCell {
    @IBOutlet weak var promotionalitem: UIButton!
    var delegate: PromotionalDelegate!
          var index: IndexPath!
          override func awakeFromNib() {
              self.promotionalitem.setBackgroundImage(UIImage(named: "proitem-graycolor"), for: .selected)

              self.promotionalitem.setBackgroundImage(UIImage(named: "proitem"), for: .normal)
          }
    
          @IBAction func pbtn(_ sender: UIButton) {
              sender.isSelected = !sender.isSelected
              self.delegate.setstate(at: index, state: sender.isSelected)
          }
      }
