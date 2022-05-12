//
//  MessagesViewController.swift
//  LoginDemo
//
//  Created by 塗詠順 on 2022/4/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MessagesViewController: UIViewController {
    
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messagesTextView: UITextView!
    @IBOutlet weak var textViewBottom: NSLayoutConstraint!
    @IBOutlet weak var messagesTableViewBottom: NSLayoutConstraint!
    
    
    var messages = [Messages]() {
            didSet {
                DispatchQueue.main.async {
                    self.messagesTableView.reloadData()
                    if self.messages.count >= 1 {
                        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                        self.messagesTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    }
                }
    
            }
        }
    
    var roomsName: String = ""
    var displayName: String = ""
    var displayPhoto: Data?

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        FirebaseController.shard.checkMessagesChanges(roomsName, self)
        FirebaseController.shard.checkMessagesChange(roomsName, self)
        addTapGesture()
        messagesTextView.addReturnButton()
        messagesTextView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillshow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addMessagesButtonClicked(_ sender: UIButton) {
        let time = Date()
        let messages = messagesTextView.text ?? ""
        let db = Firestore.firestore()
        if let displayPhoto = displayPhoto,
           let email = Auth.auth().currentUser?.email
        {
            if messagesTextView.text != "" {
                let messages = Messages(email: email, displayName: displayName, displayPhoto: displayPhoto, messages: messages, time: time)
                do {
                    try db.collection("rooms").document(roomsName).collection("messages").addDocument(from: messages)
                    messagesTextView.text = ""
                }catch{
                    print(error)
                }
            }
        }
    }
    
    @IBAction func dismissButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func testChangeMessages(_ sender: UIButton) {
        FirebaseController.shard.modifyMessage(roomsName, messages[1].id ?? "", "測試看看囉", self)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let message = messages[indexPath.row]
        
        if message.email == Auth.auth().currentUser?.email {
            guard let cell = messagesTableView.dequeueReusableCell(withIdentifier: "\(MessagesTableViewCell.self)", for: indexPath) as? MessagesTableViewCell else { return UITableViewCell() }
            
            cell.displayPhoto.image = UIImage(data: message.displayPhoto)
            cell.displayName.text = message.displayName
            cell.messages.text = message.messages
            cell.messagesTime.text = message.getTimeString()
            
            return cell
        }else{
            guard let cell = messagesTableView.dequeueReusableCell(withIdentifier: "\(OtherMessagesTableViewCell.self)", for: indexPath) as? OtherMessagesTableViewCell else { return UITableViewCell() }
            
            cell.otherDisplayPhoto.image = UIImage(data: message.displayPhoto)
            cell.otherDisplayName.text = message.displayName
            cell.otherMessages.text = message.messages
            cell.otherMessagesTime.text = message.getTimeString()
            
            return cell
        }
        
    }
    
}

extension MessagesViewController {
    
    @objc func keyboardWillshow(_ noti: Notification) {
        guard let userInfo = noti.userInfo,
              let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardHeight = keyboardFrame.height
        
        if messages.count >= 1 {
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.messagesTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        textViewBottom.constant = -keyboardHeight + 33
        view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(_ noti: Notification) {
        textViewBottom.constant = 0
        view.layoutIfNeeded()
    }
    
    func addTapGesture() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
}
