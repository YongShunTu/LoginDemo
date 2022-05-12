//
//  FirebaseController.swift
//  LoginDemo
//
//  Created by 塗詠順 on 2022/4/29.
//

import Foundation
import FirebaseFirestore
import Firebase

class FirebaseController {
    
    static let shard = FirebaseController()
    let db = Firestore.firestore()
    
    func createUser(email emailString: String, password passwordString: String, displayPhotoURL imageURL: URL, displayName userID: String, complection: @escaping (Result<User,Error>) -> Void) {
        Auth.auth().createUser(withEmail: emailString, password: passwordString) { result, error in
            guard let user = result?.user, error == nil else {
                return complection(.failure(error!))
            }
            complection(.success(user))
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.photoURL = imageURL
            changeRequest?.displayName = userID
            changeRequest?.commitChanges(completion: { error in
                guard error != nil else { return }
            })
        }
    }
    
    func checkLogin(_ email: String, _ password: String, _ complection: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard error == nil else
            {
                return complection(.failure(error!))
            }
            complection(.success(result!))
        }
    }
    
//    func checkMessagesChanges(_ roomsName: String, _ messagesViewController: MessagesViewController) {
//        db.collection("rooms").document(roomsName).collection("messages").order(by: "time").addSnapshotListener { [weak messagesViewController] snapshot, error in
//            guard let messagesViewController = messagesViewController else { return }
//            messagesViewController.messages = []
//            guard let snapshot = snapshot else { return }
//            snapshot.documents.forEach { snapshot in
//                guard let messages = try? snapshot.data(as: Messages.self) else { return }
//                messagesViewController.messages.append(messages)
//            }
//        }
//    }
    
    
    func checkMessagesChange(_ roomsName: String, _ messagesViewController: MessagesViewController) {
        db.collection("rooms").document(roomsName).collection("messages").order(by: "time").addSnapshotListener { [weak messagesViewController] snapshot, error in
            guard let messagesViewController = messagesViewController else { return }
            guard let snapshot = snapshot else { return }
            let messages = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: Messages.self)
            }
            messagesViewController.messages = messages
        }
    }
    
    // just test modifyMessage
    func modifyMessage(_ roomsName: String, _ documentID: String,  _ messagesString: String, _ messagesViewController: MessagesViewController) {
        let documentReference = db.collection("rooms").document(roomsName).collection("messages").document(documentID)
        documentReference.getDocument { snapshot, error in
            guard let snapshot = snapshot,
                  snapshot.exists,
                  var message = try? snapshot.data(as: Messages.self) else { return }
            message.messages = messagesString
            do {
                try documentReference.setData(from: message)
            }catch{
                print(error)
            }
        }
    }
    
    func creatRooms(_ roomsName: String, _ rooms: Rooms, _ chatroomViewController: ChatroomViewController) {
        do {
            try db.collection("rooms").document(roomsName).setData(from: rooms)
            fetchRooms(chatroomViewController)
        }catch{
            print(error)
        }
    }
    
    func fetchRooms(_ chatroomViewController: ChatroomViewController) {
        db.collection("rooms").order(by: "time").getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            let rooms = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: Rooms.self)
            }
            chatroomViewController.rooms = rooms
        }
    }
    
}
