//
//  HunterReceiverCell.swift
//  Hunter
//
//  Created by Ajith Kumar on 22/10/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit

class HunterChatCell: UITableViewCell {
    @IBOutlet weak var textChat: UILabel!
    @IBOutlet weak var textTime: UILabel!
    @IBOutlet weak var viewChatCV: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
