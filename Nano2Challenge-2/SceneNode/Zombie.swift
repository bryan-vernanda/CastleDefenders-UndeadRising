//
//  Zombie.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 16/05/24.
//

import Foundation
import SceneKit

class Zombie: SCNNode {
    
    var health: Int = 3
    var healthBarNode: SCNNode = SCNNode()
    
    init(at position: SCNVector3) {
        super.init()
        
        let zombieScene = SCNScene(named: "art.scnassets/Zombie.scn")!
        
        self.position = position
        
        let largerShape = SCNBox(width: 0.55, height: 0.9, length: 0.3, chamferRadius: 0)
        
        //create physics node for the new physics body
        let physicsNode = SCNNode(geometry: largerShape) // the geometry inside is used only for debugging when changing the UIColor below
        //make the node invisible
        physicsNode.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        
        self.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: largerShape, options: nil))
        self.physicsBody?.categoryBitMask = CollisionTypes.zombie.rawValue
        self.physicsBody?.contactTestBitMask = CollisionTypes.castle.rawValue | CollisionTypes.arrow.rawValue
        
        let healthBar = SCNBox(width: 0.4, height: 0.05, length: 0.01, chamferRadius: 0)
        self.healthBarNode = SCNNode(geometry: healthBar)
        healthBarNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red.withAlphaComponent(0.8)
        
        let border = SCNBox(width: 0.41, height: 0.06, length: 0.01, chamferRadius: 0)
        let borderNode = SCNNode(geometry: border)
        borderNode.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        
        if let zombieNode = zombieScene.rootNode.childNode(withName: "scene", recursively: true) {
            self.addChildNode(physicsNode) //add this as child for the parent/main children
            
            zombieNode.position = SCNVector3(x: 0, y: -0.5, z: 0) //correct the position of the zombie to match the new physics body
            physicsNode.addChildNode(zombieNode) // add zombienode as child of the new physics body to overlap it
            
            borderNode.position = SCNVector3(x: 0, y: 0.5, z: 0.1)
            healthBarNode.position = SCNVector3(x: 0, y: 0, z: 0.01) // Slightly in front of the border
            
            borderNode.addChildNode(healthBarNode)
            physicsNode.addChildNode(borderNode)
            
            let moveAction = SCNAction.move(to: SCNVector3(x: 0, y: -0.5, z: 0.5), duration: 10.0)
            self.runAction(moveAction)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func takeDamage() {
        health -= 1
        updateHealthBar()
        
        if health <= 0 {
            self.removeFromParentNode()
        }
    }
    
    private func updateHealthBar() {
        let newWidth = CGFloat(health) * 0.1333
        healthBarNode.geometry = SCNBox(width: newWidth, height: 0.05, length: 0.01, chamferRadius: 0)
        healthBarNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red.withAlphaComponent(0.8)
        
        if health == 2 {
            healthBarNode.position = SCNVector3(x: -0.065, y: 0, z: 0.01)
        } else if health == 1 {
            healthBarNode.position = SCNVector3(x: -0.133, y: 0, z: 0.01)
        } else if health == 0 {
            healthBarNode.position = SCNVector3(x: -0.2, y: 0, z: 0.01)
        }
    }
}


