//
//  TunningViewController.swift
//  Pulse
//
//  Created by Dawid Cieslak on 21/04/2018.
//  Copyright © 2018 Dawid Cieslak. All rights reserved.
//

import UIKit

class TunningViewController: UIViewController {
    private var tunningView: TunningView? = nil
    
    var setPointValue: CGFloat = 0
    var pulseOutputValue: CGFloat = 0
    
    private let displayLink: CADisplayLink
    private let displayLinkProxy: DisplayLinkTargetProxy = DisplayLinkTargetProxy()
    
    var closeClosure: ((TunningViewController) -> Void)
    var configurationChanged: ((TunningViewController, Pulse.Configuration) -> Void)
    
    init(configuration: TunningView.Configuration, closeClosure: @escaping ((TunningViewController) -> Void), configurationChanged: @escaping ((TunningViewController, Pulse.Configuration) -> Void)) {
        self.closeClosure = closeClosure
        self.configurationChanged = configurationChanged
        self.displayLink = CADisplayLink(target: displayLinkProxy, selector: #selector(tick))
        
        super.init(nibName: nil, bundle: nil)
        
        // Setup timer
        displayLinkProxy.target = self
        displayLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        
        self.tunningView = TunningView(configuration: configuration, closeClosure: { [weak self] (sender) in
            guard let `self` = self else { return }
            self.closeClosure(self)
            
        }, configurationChanged: { [weak self] (sender, configuration) in
                guard let `self` = self else { return }
                self.configurationChanged(self, configuration)
        })
    }
    
    @objc func tick() {
        tunningView?.drawSetPoint(value: setPointValue)
        tunningView?.drawPulseOutput(value: pulseOutputValue)
        tunningView?.updateGraph()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
    
                tunningView?.layoutIfNeeded()
                tunningView?.visibilityState = .fullyVisible
    }
    
    deinit {
        displayLink.invalidate()
        print("Deinin")
        
    }
    override func loadView() {
        view = tunningView
    }
}

