//
//  HunterChatSenderImageCell.swift
//  Hunter
//
//  Created by Shamseer on 20/09/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import UIKit

class HunterChatSenderImageCell: UITableViewCell {

    @IBOutlet weak var imgSentImage: UIImageView!
    @IBOutlet weak var viewChatCV: UIView!

    @IBOutlet weak var imgClick: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
