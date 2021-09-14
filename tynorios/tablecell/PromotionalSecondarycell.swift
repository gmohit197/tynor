//

//  PromotionalSecondarycell.swift

//  tynorios

//

//  Created by Acxiom Consulting on 16/01/19.

//  Copyright © 2019 Acxiom. All rights reserved.

//
import UIKit

protocol PromotionalDelegate {
    func setstate(at index: IndexPath,state: Bool)
}

class PromotionalSecondarycell: UICollectionViewCell {

    @IBOutlet weak var prmotionalitem: UIButton!

    var delegate: PromotionalDelegate!

    var flag = 0

    var index: IndexPath!

    override func awakeFromNib() {

        self.prmotionalitem.setBackgroundImage(UIImage(named: "proitem-graycolor"), for: .selected)

        self.prmotionalitem.setBackgroundImage(UIImage(named: "proitem"), for: .normal)

    }

   

    @IBAction func pbtn(_ sender: UIButton) {

        sender.isSelected = !sender.isSelected

        self.delegate.setstate(at: index, state: sender.isSelected)

    }

}
