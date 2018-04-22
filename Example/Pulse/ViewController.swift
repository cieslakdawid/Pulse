//
//  ViewController.swift
//  Pulse
//
//  Created by cieslakdawid on 04/21/2018.
//  Copyright (c) 2018 cieslakdawid. All rights reserved.
//

import UIKit
import Pulse

class ViewController: UIViewController {

    private var positionController: Pulse? = nil
    
    @IBOutlet weak var emojiLabel: UILabel!
    
    @IBOutlet weak var helicpoterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = Pulse.Configuration(minimumValueStep: 0.5, Kp: 0.5, Ki: 0.1, Kd: 0.9)
        positionController = Pulse(configuration: configuration, measureClosure: {  [weak self] () -> CGFloat in
            guard let `self` = self else { return 0 }
            
            // This closure returns information about current value
            return self.emojiLabel.center.x
        }, outputClosure: { [weak self] (output) in
            guard let `self` = self else { return }
            self.emojiLabel.center = CGPoint(x: output, y: self.view.center.y)
        })
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        // Scale value from slider (0-1) to size of view
        let targetPosition = CGFloat(sender.value) * view.bounds.width
        
        // Notify about new `SetPoint`
        positionController?.setPoint = targetPosition
        
        helicpoterLabel.center = CGPoint(x: targetPosition, y:  helicpoterLabel.center.y)
    }
    
    // Detect 
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if(motion == .motionShake) {
            positionController?.showTunningView(minimumValue: 0, maximumValue: 300)
        }
    }
}

