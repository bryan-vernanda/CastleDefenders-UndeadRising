//
//  ARManager.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 17/05/24.
//

import Foundation
import ARKit
import Combine

enum ARAction {
    case attackButton
}

enum ARActionContinue {
    case continueButton
}

enum ARAction2 {
    case attackButton
}

class ARManager {
    static let shared = ARManager()
    
    private init() {
        sceneView = ARSCNView()
    }
    
    let sceneView: ARSCNView
    var actionStream = PassthroughSubject<ARAction, Never>()
    var actionStream2 = PassthroughSubject<ARAction2, Never>()
    var actionStreamContinue = PassthroughSubject<ARActionContinue, Never>()
    
    func reset() {
        sceneView.session.pause()
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        sceneView.removeFromSuperview()
    }
    
    func setupARView(for parentView: UIView) {
        sceneView.frame = parentView.frame
        parentView.addSubview(sceneView)
        sceneView.delegate = parentView as? ARSCNViewDelegate
        sceneView.session.delegate = parentView as? ARSessionDelegate
    }
}
