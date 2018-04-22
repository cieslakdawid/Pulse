//
//  TunningView.swift
//  Pulse
//
//  Created by Dawid Cieslak on 15/04/2018.
//  Copyright © 2018 Dawid Cieslak. All rights reserved.
//

import UIKit

enum VisibilityState {
    case notVisible
    case graphOnly
    case fullyVisible
}

class TunningView: UIView {
  
    struct Configuration {
        let minimumValue: CGFloat
        let maximumValue: CGFloat
        
        let initialConfiguration: Pulse.Configuration
    }
    
    private struct LayoutConstants {
        
        /// Colors of graph's background gradinet
        static let GraphColors: [UIColor] = [UIColor(red: 72.0/255.0, green: 35.0/255.0, blue: 174.0/255.0, alpha: 1.0),
                                             UIColor(red: 184.0/255.0, green: 109.0/255.0, blue: 215.0/255.0, alpha: 1.0)]
    }
    
    var visibilityState: VisibilityState = .notVisible {
        didSet {
            update()
        }
    }
    
    private var didSetConstraints: Bool = false
    private let closeButton = UIButton(type: .custom)
    private let controlsView: ControlsView
    
    private var topConstraint: NSLayoutConstraint? = nil
    
    // Draws current value of Pulse's `output` value and `setPoint`
    private let graphView: LineGraphView
    
    /// Draws current value of Pulse's output value
    private let outputValueGraphItem: LineGraphItem
    
    /// Draws current value of Pulse's `setPoint` value
    private let setpointValueGraphItem: LineGraphItem
    
    // Constraints
    private lazy var containerStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .trailing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        return stackView
    }()

    var closeClosure: ((TunningView) -> Void)
    
    var configurationChanged: ((TunningView, Pulse.Configuration) -> Void)

    required init(configuration: Configuration, closeClosure: @escaping ((TunningView) -> Void), configurationChanged: @escaping ((TunningView, Pulse.Configuration) -> Void)) {
        self.closeClosure = closeClosure
        self.configurationChanged = configurationChanged

        controlsView = ControlsView(initialConfiguration: configuration.initialConfiguration)

        outputValueGraphItem = LineGraphItem(initialValue: CGFloat(0),
                                             strokeColor: UIColor.white,
                                             headValueOffsetFactor: 0.9,
                                             minimumValue: CGFloat(configuration.minimumValue),
                                             maximumValue: CGFloat(configuration.maximumValue))
        
        setpointValueGraphItem = LineGraphItem(initialValue: CGFloat(0),
                                               strokeColor: UIColor(white: 1.0, alpha: 0.2),
                                               headValueOffsetFactor: 0.9,
                                               minimumValue: CGFloat(configuration.minimumValue),
                                               maximumValue: CGFloat(configuration.maximumValue))
        
        graphView = LineGraphView(items: [outputValueGraphItem, setpointValueGraphItem],
                                  backgroundColors: LayoutConstants.GraphColors)
   
        super.init(frame: .zero)
        
        let podBundle = Bundle(for: TunningView.self)
        if let url = podBundle.url(forResource: "Pulse", withExtension: "bundle"){   // leave the extension as "bundle"
            let imageBundle = Bundle(url: url)
            let image = UIImage.init(named: "tickIcon", in: imageBundle, compatibleWith: nil)
            closeButton.setImage(image, for: .normal)
        }

        closeButton.layer.cornerRadius = 20
        closeButton.backgroundColor = .white
        closeButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        closeButton.isUserInteractionEnabled = true
        
        // Controls View
        controlsView.translatesAutoresizingMaskIntoConstraints = false
        
        // Listen to configuration changes
        controlsView.configurationChanged = { [weak self] (sender, configuration) in
            guard let `self` = self else { return }
            self.configurationChanged(self, configuration)
        }

        // Add views to `UIStackView`
        graphView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerStackView)
      
        containerStackView.addArrangedSubview(closeButton)
        containerStackView.addArrangedSubview(graphView)
        containerStackView.addArrangedSubview(controlsView)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        let respondingView = containerStackView.frame.contains(point) ? view : nil
        return respondingView
    }
    
    func updateGraph() {
        graphView.update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        guard didSetConstraints == false else {
            return
        }
        didSetConstraints = true
        
        topConstraint =  self.containerStackView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        
        NSLayoutConstraint.activate([
            self.containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.graphView.heightAnchor.constraint(equalToConstant: 100),
            
            self.controlsView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            self.graphView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            self.closeButton.widthAnchor.constraint(equalToConstant: 40),
            self.closeButton.heightAnchor.constraint(equalToConstant: 40),
           topConstraint!,
        ])
    }
    
    // FIXME: Silly name and mess
    private func heightForState() -> CGFloat {
        let margin: CGFloat = 10
        let padding: CGFloat
        
        if(visibilityState == .graphOnly) {
            padding = graphView.frame.maxY + margin
        } else if(visibilityState == .notVisible) {
           padding = 0
        } else {
            padding = containerStackView.bounds.height + margin
        }
        
        return -padding
    }
    
    @objc func buttonPressed() {
        switch visibilityState {
        case .fullyVisible:
            visibilityState = .graphOnly
        case .graphOnly:
            visibilityState = .notVisible
        case .notVisible:
            visibilityState = .fullyVisible
        }

    }
    
    private func update() {
        self.topConstraint?.constant = heightForState()
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: { [weak self] in
            guard let `self` = self else { return }
            self.layoutIfNeeded()
        }) { [weak self] (finished)  in
            guard let `self` = self else { return }
            
            if(self.visibilityState == .notVisible) {
                self.closeClosure(self)
            }
        }
    }
}

// MARK: - Drawing Values
extension TunningView {
    func drawSetPoint(value: CGFloat) {
        setpointValueGraphItem.addValue(value)
    }
    
    func drawPulseOutput(value: CGFloat) {
        outputValueGraphItem.addValue(value)
    }
}
