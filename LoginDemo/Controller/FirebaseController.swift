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
    
    func checkMessagesChanges(_ roomsName: String, _ messagesViewController: MessagesViewController) {
        db.collection("rooms").document(roomsName).collection("messages").order(by: "time").addSnapshotListener { snapshot, error in
            messagesViewController.messages = []
            guard let snapshot = snapshot else { return }
            snapshot.documents.forEach { snapshot in
                guard let messages = try? snapshot.data(as: Messages.self) else { return }
                messagesViewController.messages.append(messages)
                print("\(messagesViewController.messages)")
            }
        }
    }
    
    func checkMessagesChange(_ roomsName: String, _ messagesViewController: MessagesViewController) {
        db.collection("rooms").document(roomsName).collection("messages").order(by: "time").addSnapshotListener { snapshot, error in
            messagesViewController.messages.removeAll()
            guard let snapshot = snapshot else { return }
            snapshot.documentChanges.forEach { documentChange in
                switch documentChange.type {
                case .added:
                    print("add")
                    guard let messages = try? documentChange.document.data(as: Messages.self) else { break }
                    messagesViewController.messages.append(messages)
                case .modified:
                    print("modified")
                case .removed:
                    print("removed")
                }
            }
        }
    }
    
}
