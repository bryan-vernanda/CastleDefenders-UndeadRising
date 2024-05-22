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
//    var actionStreamZombie = PassthroughSubject<ARActionZombie, Never>()
}

class ARManager2 {
    static let shared2 = ARManager2()
    
    private init() {
        sceneView2 = ARSCNView()
    }
    
    let sceneView2: ARSCNView
    var actionStream2 = PassthroughSubject<ARAction2, Never>()
//    var actionStreamZombie = PassthroughSubject<ARActionZombie, Never>()
}
