//
//  OtherMessagesTableViewCell.swift
//  LoginDemo
//
//  Created by 塗詠順 on 2022/4/26.
//

import UIKit

class OtherMessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var otherDisplayPhoto: UIImageView!
    @IBOutlet weak var otherDisplayName: UILabel!
    @IBOutlet weak var otherMessages: UITextView!
    @IBOutlet weak var otherMessagesTime: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        otherMessages.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
