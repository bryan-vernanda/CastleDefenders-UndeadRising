//
//  Zombie.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 16/05/24.
//

import Foundation
import SceneKit

class Zombie: SCNNode {
    
    init(at position: SCNVector3) {
        super.init()
        
        let zombieScene = SCNScene(named: "art.scnassets/Zombie.scn")!
        
        self.position = position
        
        let largerShape = SCNBox(width: 0.55, height: 0.9, length: 0.3, chamferRadius: 0)
        let physicsShape = SCNPhysicsShape(geometry: largerShape, options: nil)
        
        //create physics node for the new physics body
        let physicsNode = SCNNode(geometry: largerShape) // the geometry inside is used only for debugging when changing the UIColor below
        //make the node invisible
        physicsNode.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        
        self.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: largerShape, options: nil))
        self.physicsBody?.categoryBitMask = CollisionTypes.zombie.rawValue
        self.physicsBody?.contactTestBitMask = CollisionTypes.castle.rawValue | CollisionTypes.arrow.rawValue
        
        if let zombieNode = zombieScene.rootNode.childNode(withName: "scene", recursively: true) {
            self.addChildNode(physicsNode) //add this as child for the parent/main children
            zombieNode.position = SCNVector3(x: 0, y: -0.5, z: 0) //correct the position of the zombie to match the new physics body
            physicsNode.addChildNode(zombieNode) // add zombienode as child of the new physics body to overlap it
            
            let moveAction = SCNAction.move(to: SCNVector3(x: 0, y: -0.5, z: 0.5), duration: 10.0)
            self.runAction(moveAction)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


