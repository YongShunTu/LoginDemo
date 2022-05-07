//
//  Messages.swift
//  LoginDemo
//
//  Created by 塗詠順 on 2022/4/21.
//

import Foundation
import FirebaseFirestoreSwift
import UIKit

struct Messages: Codable, Identifiable {
    @DocumentID var id: String?
    let email: String
    let displayName: String
    let displayPhoto: Data
    let messages: String
    let time: Date
    
    func getTimeStyle() -> String {
        let dateForMatter = DateFormatter()
        dateForMatter.dateFormat = "HH:mm"
        let timeString = dateForMatter.string(from: time)
        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: time)
        let hour = dateComponents.hour ?? 0
        if hour >= 12 {
            return "下午" + timeString
        }else{
            return "上午" + timeString
        }
    }
}
