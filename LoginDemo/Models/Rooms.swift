//
//  Rooms.swift
//  LoginDemo
//
//  Created by 塗詠順 on 2022/4/20.
//

import Foundation
import FirebaseFirestoreSwift

struct Rooms: Codable, Identifiable {
    @DocumentID var id: String?
    let name: String
    let time: String
}
