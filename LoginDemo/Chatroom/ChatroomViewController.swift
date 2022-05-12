//
//  ChatroomViewController.swift
//  LoginDemo
//
//  Created by 塗詠順 on 2022/5/9.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatroomViewController: UIViewController {

    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var roomsTableView: UITableView!
    
    
    var rooms = [Rooms]() {
        didSet {
            roomsTableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        updataPersonalInformation()
        FirebaseController.shard.fetchRooms(self)
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
        let date = Date()
        let alter = UIAlertController(title: "輸入聊天室名稱", message: nil, preferredStyle: .alert)
        alter.addTextField { textfield in
            textfield.keyboardType = .default
            textfield.placeholder = "請輸入名稱"
            textfield.addReturnButton()
        }
        let okAction = UIAlertAction(title: "新增", style: .default) { action in
            let rooms = Rooms(name: alter.textFields?[0].text ?? "", time: date)
            FirebaseController.shard.creatRooms(alter.textFields?[0].text ?? "", rooms, self)
        }
        let cancleAction = UIAlertAction(title: "取消", style: .default)
        alter.addAction(cancleAction)
        alter.addAction(okAction)
        present(alter, animated: true)
        
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

extension ChatroomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = roomsTableView.dequeueReusableCell(withIdentifier: "\(RoomsTableViewCell.self)", for: indexPath) as? RoomsTableViewCell else {
            return UITableViewCell()
        }
        
        let room = rooms[indexPath.row]
        cell.roomsName.text = room.name
        cell.createRoomsTime.text = room.getTimeString()
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? MessagesViewController,
           let row = roomsTableView.indexPathForSelectedRow?.row,
           let displayPhoto = userPhoto.image?.jpegData(compressionQuality: 0.5)
        {
            controller.roomsName = rooms[row].id ?? ""
            controller.displayName = userName.text ?? ""
            controller.displayPhoto = displayPhoto
        }
    }
    
}

