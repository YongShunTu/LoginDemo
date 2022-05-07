//
//  AnimationViewController.swift
//  LoginDemo
//
//  Created by 塗詠順 on 2022/5/2.
//

import UIKit

class AnimationViewController: UIViewController {
    
    @IBOutlet weak var animationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func animationButtonClicked(_ sender: UIButton) {
        self.animationLabel.text = "測試文字閃爍動畫"
        animationLabel.alpha = 1
        animationAction()
    }

    func animationAction() {
        UIView.animate(withDuration: 1, delay: 0, options: [.autoreverse, .repeat]) {
            self.animationLabel.alpha = 0
        }
        
        AnimationEffectController.shard.animationStarts(0, 3, "先顯示第一段", self.animationLabel, self)
        AnimationEffectController.shard.animationStarts(3, 6, "再來顯示第二段", self.animationLabel, self)
    }



}
