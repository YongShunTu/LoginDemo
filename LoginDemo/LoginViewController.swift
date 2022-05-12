//
//  LoginViewController.swift
//  LoginDemo
//
//  Created by 塗詠順 on 2022/4/16.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginAnimationView: UIView!
    @IBOutlet weak var loginAnimationLabel: UILabel!
    
    var changePasswordStyle: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        emailTextField.addReturnButton()
        passwordTextField.addReturnButton()
        if Auth.auth().currentUser == nil {
            animationAction(false)
            Timer.scheduledTimer(withTimeInterval: 7, repeats: false) { timer in
                self.loginAnimationView.isHidden = true
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            loginAnimationView.isHidden = false
            loginAnimationLabel.alpha = 1
            animationAction(true)
            Timer.scheduledTimer(withTimeInterval: 7, repeats: false) { timer in
                self.goToLoginSuccessView()
                self.loginAnimationView.isHidden = true
            }
        }
    }
    
    func animationAction(_ login: Bool) {
        UIView.animate(withDuration: 1, delay: 0, options: [.autoreverse, .repeat]) {
            self.loginAnimationLabel.alpha = 0
        }
        if login {
            AnimationEffectController.shard.animationStarts(0, 3, "登入中...", self.loginAnimationLabel, self)
            AnimationEffectController.shard.animationStarts(3, 6, "成功...", self.loginAnimationLabel, self)
        }else{
            AnimationEffectController.shard.animationStarts(0, 3, "登入中...", self.loginAnimationLabel, self)
            AnimationEffectController.shard.animationStarts(3, 6, "失敗...", self.loginAnimationLabel, self)
        }
    }
    
    func goToLoginSuccessView() {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "\(ChatroomViewController.self)") as? ChatroomViewController {
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true)
        }
    }
    
    @IBAction func hidePasswordButtonClicked(_ sender: UIButton) {
        changePasswordStyle = !changePasswordStyle
        passwordTextField.isSecureTextEntry = changePasswordStyle
        sender.setImage(UIImage(systemName: changePasswordStyle ? "eye.slash": "eye"), for: .normal)
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        let email = emailTextField.text ?? ""
        let pasword = passwordTextField.text ?? ""
        
        FirebaseController.shard.checkLogin(email, pasword) { result in
            switch result {
            case .success(_):
                self.loginAnimationView.isHidden = false
                self.loginAnimationLabel.alpha = 1
                self.animationAction(true)
                Timer.scheduledTimer(withTimeInterval: 7, repeats: false) { timer in
                    self.goToLoginSuccessView()
                    self.loginAnimationView.isHidden = true
                }
            case .failure(_):
                let alter = AddAlterController.shard.alterController("帳號密碼錯誤", nil, "ok", nil)
                self.present(alter, animated: true)
            }
            
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
