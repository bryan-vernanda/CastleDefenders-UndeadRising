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

enum ARActionZombie {
    case firstPage
    case secondPage
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

//class ARManager2 {
//    static let shared2 = ARManager2()
//    
//    private init() {
//        sceneView2 = ARSCNView()
//    }
//    
//    let sceneView2: ARSCNView
//    var actionStream2 = PassthroughSubject<ARAction2, Never>()
////    var actionStreamZombie = PassthroughSubject<ARActionZombie, Never>()
//    
//    func reset() {
//        sceneView2.session.pause()
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.isLightEstimationEnabled = true
//        sceneView2.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
//        sceneView2.removeFromSuperview()
//    }
//    
//    func setupARView(for parentView: UIView) {
//        sceneView2.frame = parentView.frame
//        parentView.addSubview(sceneView2)
//        sceneView2.delegate = parentView as? ARSCNViewDelegate
//        sceneView2.session.delegate = parentView as? ARSessionDelegate
//    }
//}
