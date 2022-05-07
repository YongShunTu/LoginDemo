//
//  RegisterViewController.swift
//  LoginDemo
//
//  Created by 塗詠順 on 2022/4/18.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var UserID: UITextField!
    @IBOutlet weak var displayPhoto: UIImageView!
    @IBOutlet weak var doubleCheckPhoto: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var doubleCheckPasswordTextField: UITextField!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var registerSuccessAnimationView: UIView!
    @IBOutlet weak var registerSuccessAnimationLabel: UILabel!
    
    
    var changeDoubleCheckPasswordStyle: Bool = true
    var displayPhotoURL: URL?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        UserID.addReturnButton()
        emailTextField.addReturnButton()
        passwordTextField.addReturnButton()
        doubleCheckPasswordTextField.addReturnButton()
        addTapGestue()
        registerSuccessAnimationView.isHidden = true
        doubleCheckPasswordTextField.autocorrectionType = .no
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        let userID = UserID.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let doubleCheckPassword = doubleCheckPasswordTextField.text ?? ""
        
        if let displayPhotoURL = displayPhotoURL {
            switch password {
            case _ where password.count >= 8 && password.count <= 12:
                if password == doubleCheckPassword {
                    FirebaseController.shard.createUser(email: email, password: password, displayPhotoURL: displayPhotoURL, displayName: userID) { result in
                        switch result {
                        case .success(_):
                            self.registerSuccessAnimationView.isHidden = false
                            self.registerSuccessAnimationLabel.alpha = 1
                            self.animationAction()
                        case .failure(_):
                            let alter = AddAlterController.shard.alterController("帳號已經註冊過", "請重新註冊", "OK", nil)
                            self.present(alter, animated: true)
                        }
                    }
                }else{
                    let alter = AddAlterController.shard.alterController("密碼輸入錯誤", nil, "OK", nil)
                    self.present(alter, animated: true)
                }
            case _ where password.count < 8 || password.count > 12:
                let alter = AddAlterController.shard.alterController("密碼長度需8字元～12字元", nil, "OK", nil)
                present(alter, animated: true)
            default:
                break
            }
        }else{
            let alter = AddAlterController.shard.alterController("大頭照未選擇", "請選擇大頭照", "OK", nil)
            present(alter, animated: true)
        }
        
    }
    
    func animationAction() {
        UIView.animate(withDuration: 1, delay: 0, options: [.autoreverse, .repeat]) {
            self.registerSuccessAnimationLabel.alpha = 0
        }
        AnimationEffectController.shard.animationStarts(0, 3, "註冊中...", self.registerSuccessAnimationLabel, self)
        AnimationEffectController.shard.animationStarts(3, 6, "成功...", self.registerSuccessAnimationLabel, self)
        Timer.scheduledTimer(withTimeInterval: 7, repeats: false) { timer in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func currentDoubleCheckPassword(_ sender: UITextField) {
        guard doubleCheckPasswordTextField.text != "" else {
            return doubleCheckPhoto.isHidden = true
        }
        doubleCheckPhoto.isHidden = false
        doubleCheckPhoto.image = UIImage(named: (passwordTextField.text == doubleCheckPasswordTextField.text) ? "correct": "mistake")
    }
    
    
    @IBAction func hideDoubleCheckPasswordButtonClicked(_ sender: UIButton) {
        changeDoubleCheckPasswordStyle = !changeDoubleCheckPasswordStyle
        doubleCheckPasswordTextField.isSecureTextEntry = changeDoubleCheckPasswordStyle
        sender.setImage(UIImage(systemName: changeDoubleCheckPasswordStyle ? "eye.slash": "eye"), for: .normal)
    }
    
    @IBSegueAction func goToChooseDiaplayPhotoViewController(_ coder: NSCoder) -> ChooseDisplayPhotoViewController? {
        let controller = ChooseDisplayPhotoViewController(coder: coder)
        controller?.delegate = self
        return controller
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

extension RegisterViewController: ChooseDisplayPhotoViewControllerDelegate {
    func chooseDisplayPhoto(displayPhoto image: DisplayPhoto) {
        displayPhotoURL = image.photo
        ChooseDisplayPhotoController.shard.fetchImage(image.photo) { image in
            DispatchQueue.main.async {
                self.displayPhoto.image = image
            }
        }
    }
    
}

extension RegisterViewController {
    @objc func keyboardWillShow(_ noti: Notification) {
        guard let userInfo = noti.userInfo,
              let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardHeight = keyboardFrame.height
        let contentInsets = keyboardHeight - (view.frame.maxY - registerView.frame.maxY)

        if contentInsets > 0 {
            view.bounds.origin.y = contentInsets
        }
    }
    
    @objc func keyboardWillHide(_ noti: Notification) {
        view.bounds.origin.y = 0
    }
    
    func addTapGestue() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
