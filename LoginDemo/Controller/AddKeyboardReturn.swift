//
//  AddKeyboardReturn.swift
//  LoginDemo
//
//  Created by 塗詠順 on 2022/4/19.
//

import Foundation
import UIKit

extension UITextField {
    func addReturnButton() {
        let weight = UIScreen.main.bounds.width
        let toobar = UIToolbar(frame: CGRect(x: 0, y: 0, width: weight, height: (weight * 0.1)))
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(add))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toobar.items = [space,space,done]
        self.inputAccessoryView = toobar
    }

    @objc func add() {
        self.resignFirstResponder()
    }
}


extension UITextView {
    func addReturnButton() {
        let weight = UIScreen.main.bounds.width
        let toobar = UIToolbar(frame: CGRect(x: 0, y: 0, width: weight, height: (weight * 0.1)))
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(add))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toobar.items = [space,space,done]
        self.inputAccessoryView = toobar
    }

    @objc func add() {
        self.resignFirstResponder()
    }
}
