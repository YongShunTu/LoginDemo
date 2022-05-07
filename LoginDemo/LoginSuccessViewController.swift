//
//  LoginSuccessViewController.swift
//  LoginDemo
//
//  Created by 塗詠順 on 2022/4/16.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginSuccessViewController: UIViewController {

    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var roomsNameTextField: UITextField!
    @IBOutlet weak var roomsTableView: UITableView!
    
    
    var rooms = [Rooms]() {
        didSet {
            roomsTableView.reloadData()
        }
    }
    
    var time = Date.self
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        updataPersonalInformation()
        fetchRooms()
    }
    
    func updataPersonalInformation() {
        if let user = Auth.auth().currentUser,
           let imageData = try? Data(contentsOf: user.photoURL!)
        {
            userEmail.text = user.email
            userName.text = user.displayName
            DispatchQueue.main.async {
                self.userPhoto.image = UIImage(data: imageData)
            }
        }
    }
    
    @IBAction func signOutButtonClicked(_ sender: UIButton) {
        let alter = UIAlertController(title: "是否登出", message: nil, preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "Cancle", style: .default)
        let okAction = UIAlertAction(title: "Sign Out", style: .default) { action in
            do {
                try Auth.auth().signOut()
                self.dismiss(animated: true)
            }catch{
                print("\(error)")
            }
        }
        alter.addAction(cancleAction)
        alter.addAction(okAction)
        present(alter, animated: true)
    }
    
    @IBAction func createRooms(_ sender: UIButton) {
        let roomsName = roomsNameTextField.text ?? ""
        let dateForMatter = DateFormatter()
        dateForMatter.dateFormat = "yyyy/MM/dd"
        let time = dateForMatter.string(from: time.now)
        let db = Firestore.firestore()
        let rooms = Rooms(name: roomsName, time: time)
        do {
            try? db.collection("rooms").document(roomsName).setData(from: rooms)
            fetchRooms()
        }catch{
            print("error")
        }
    }
    
    func fetchRooms() {
        let db = Firestore.firestore()
        db.collection("rooms").getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            let rooms = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: Rooms.self)
            }
            self.rooms = rooms
        }
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

extension LoginSuccessViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = roomsTableView.dequeueReusableCell(withIdentifier: "\(RoomsTableViewCell.self)", for: indexPath) as? RoomsTableViewCell else {
            return UITableViewCell()
        }
        
        let room = rooms[indexPath.row]
        cell.roomsName.text = room.name
        cell.createRoomsTime.text = room.time
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? MessagesViewController,
           let row = roomsTableView.indexPathForSelectedRow?.row,
           let displayPhoto = userPhoto.image?.jpegData(compressionQuality: 0.5)
        {
            controller.roomsName = rooms[row].name
            controller.displayName = userName.text ?? ""
            controller.displayPhoto = displayPhoto
        }
    }
    
}
