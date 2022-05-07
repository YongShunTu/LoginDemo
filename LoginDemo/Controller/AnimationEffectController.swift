//
//  AnimationEffectController.swift
//  LoginDemo
//
//  Created by 塗詠順 on 2022/5/2.
//

import Foundation
import UIKit

class AnimationEffectController: UIViewController {
    
    static let shard = AnimationEffectController()
    
    func animationStarts(_ startingTime: Double, _ endTime: Double, _ labelText: String, _ label: UILabel, _ viewController: UIViewController) {
        
        var time: Timer?
        
        Timer.scheduledTimer(withTimeInterval: startingTime, repeats: false) { timer in
            time = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak viewController] timer in
                guard viewController != nil else {
                    timer.invalidate()
                    return
                }
                for (index, value) in labelText.enumerated() {
                    Timer.scheduledTimer(withTimeInterval: Double(index) / Double(labelText.count), repeats: false) { timer in
                        label.text?.append(value)
                        print("\(value)\n\(index)")
                    }
                }
                label.text?.removeAll()
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: endTime + Double(1), repeats: false) { timer in
            guard let time = time else {
                return
            }
            label.text?.removeAll()
            time.invalidate()
        }
    }
    
    
}
