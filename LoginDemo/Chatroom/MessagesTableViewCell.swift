//
//  MessagesTableViewCell.swift
//  LoginDemo
//
//  Created by 塗詠順 on 2022/4/21.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var displayPhoto: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var messages: UITextView!
    @IBOutlet weak var messagesTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messages.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state

        
    }

}
