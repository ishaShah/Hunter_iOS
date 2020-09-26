//
//  HunterMessagesCell.swift
//  Hunter
//
//  Created by Ajith Kumar on 18/10/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit

class HunterMessagesCell: UITableViewCell {
    @IBOutlet weak var viewReadStatus: UIView!
    @IBOutlet weak var labelChatName: UILabel!
    @IBOutlet weak var labelChatMessage: UILabel!
    @IBOutlet weak var imageChat: UIImageView!

    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var proImgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
