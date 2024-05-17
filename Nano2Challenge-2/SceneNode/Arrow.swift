//
//  Arrow.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 17/05/24.
//

import Foundation
import SceneKit

class Arrow: SCNNode{
    override init() {
        super.init()
        
        let arrowScene = SCNScene(named: "art.scnassets/Arrow.scn")!
        
//        self.position = SCNVector3(x: 0, y: 0, z: 0)
        
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: self, options: nil))
        self.physicsBody?.isAffectedByGravity = true
        self.physicsBody?.categoryBitMask = CollisionTypes.arrow.rawValue
        self.physicsBody?.contactTestBitMask = CollisionTypes.zombie.rawValue
        self.physicsBody?.collisionBitMask = 0
        
        if let arrowNode = arrowScene.rootNode.childNode(withName: "scene", recursively: true) {
            self.addChildNode(arrowNode)
            
//            let moveAction = SCNAction.move(to: SCNVector3(x: 0, y: 0, z: -10), duration: 3)
//            self.runAction(moveAction)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
