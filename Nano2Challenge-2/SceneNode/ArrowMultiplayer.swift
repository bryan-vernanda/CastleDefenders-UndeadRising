//
//  ArrowMultiplayer.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 21/05/24.
//

import Foundation
import SceneKit

class ArrowMultiplayer: SCNNode {
    let sessionIdentifier: UUID?

    init(at position: SCNVector3, at cameraOrientation: SCNVector3, sessionIdentifier: UUID?) {
        self.sessionIdentifier = sessionIdentifier
        super.init()

        let arrowScene = SCNScene(named: "art.scnassets/Arrow.scn")!

        self.position = position

        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: self, options: nil))
        self.physicsBody?.isAffectedByGravity = true
        self.physicsBody?.categoryBitMask = CollisionTypes.arrow.rawValue
        self.physicsBody?.contactTestBitMask = CollisionTypes.zombie.rawValue
        self.physicsBody?.collisionBitMask = 0

        if let arrowNode = arrowScene.rootNode.childNode(withName: "scene", recursively: true) {
            self.addChildNode(arrowNode)

            // Apply an impulse to the arrow to simulate launch
            let force = SCNVector3(cameraOrientation.x * 20, cameraOrientation.y * 20, cameraOrientation.z * 20)
            self.physicsBody?.applyForce(force, asImpulse: true)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
