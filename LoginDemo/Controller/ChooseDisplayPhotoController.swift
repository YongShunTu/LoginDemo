//
//  ChooseDisplayPhotoController.swift
//  LoginDemo
//
//  Created by 塗詠順 on 2022/4/29.
//

import Foundation
import UIKit

class ChooseDisplayPhotoController {
    
     static let shard = ChooseDisplayPhotoController()
    
    func fetchImage(_ imageURL: URL?, _ complection: @escaping (UIImage?) -> Void) {
        if let imageURL = imageURL {
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                guard let data = data,
                let image = UIImage(data: data)
                else
                {
                  return  complection(nil)
                }
                complection(image)
            }.resume()
        }
    }
    
}
