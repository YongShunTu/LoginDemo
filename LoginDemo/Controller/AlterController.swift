//
//  AlterController.swift
//  LoginDemo
//
//  Created by 塗詠順 on 2022/4/30.
//

import Foundation
import UIKit

class AddAlterController: UIViewController {
    
    static let shard = AddAlterController()
    
    func alterController(_ alterTitle: String?, _ alterMessage: String?, _ rightActionTitle: String?, _ leftActionTitle: String?) -> UIAlertController {
        let alter = UIAlertController(title: alterTitle, message: alterMessage, preferredStyle: .alert)
        
        if let leftAction = leftAction(leftActionTitle) {
            alter.addAction(leftAction)
        }
        
        if let rightAction = rightAction(rightActionTitle) {
            alter.addAction(rightAction)
        }
        
        return alter
    }
    
    func leftAction(_ title: String?) -> UIAlertAction? {
        if let title = title {
            let action = UIAlertAction(title: title, style: .default, handler: nil)
            return action
        }
        return nil
    }
    
    func rightAction(_ title: String?) -> UIAlertAction? {
        if let title = title {
            let action = UIAlertAction(title: title, style: .default, handler: nil)
            return action
        }
        return nil
    }
    
    
}
