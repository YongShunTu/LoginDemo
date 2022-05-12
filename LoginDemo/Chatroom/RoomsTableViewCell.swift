//
//  RoomsTableViewCell.swift
//  LoginDemo
//
//  Created by 塗詠順 on 2022/4/20.
//

import UIKit

class RoomsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var roomsName: UILabel!
    @IBOutlet weak var createRoomsTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
