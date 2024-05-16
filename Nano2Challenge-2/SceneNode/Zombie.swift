//
//  Zombie.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 16/05/24.
//

import Foundation
import SceneKit

class Zombie: SCNNode{
    init(at position: SCNVector3) {
        super.init()
        
        let zombieScene = SCNScene(named: "art.scnassets/Zombie.scn")!
        
        self.position = position
        
        self.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: self, options: nil))
        self.physicsBody?.categoryBitMask = CollisionTypes.zombie.rawValue
        self.physicsBody?.contactTestBitMask = CollisionTypes.castle.rawValue
        
        if let zombieNode = zombieScene.rootNode.childNode(withName: "scene", recursively: true) {
            self.addChildNode(zombieNode)
            
            let moveAction = SCNAction.move(to: SCNVector3(x: 0, y: -0.5, z: 0.5), duration: 10.0)
            self.runAction(moveAction)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
