//
//  MultiplayerViewCell.swift
//  CardGame
//
//  Created by Davorin Madaric on 28/12/2017.
//  Copyright © 2017 Davorin Madaric. All rights reserved.
//

import UIKit

class MultiplayerViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(data: MultiplayerData) {
        nameLabel.text = data.name
        rankLabel.text = data.rank
    }
    
}
