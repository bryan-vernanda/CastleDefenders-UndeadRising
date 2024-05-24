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
    var physicsNode: SCNNode = SCNNode()
    var timeTakenWalking: CGFloat
    
    init(at position: SCNVector3, timeWalking: CGFloat) {
        timeTakenWalking = timeWalking
        super.init()
        
        let zombieScene = SCNScene(named: "art.scnassets/Zombie.scn")!
        
        self.position = position
        
        let largerShape = SCNBox(width: 0.55, height: 0.9, length: 0.3, chamferRadius: 0)
        
        //create physics node for the new physics body
        physicsNode = SCNNode(geometry: largerShape) // the geometry inside is used only for debugging when changing the UIColor below
        //make the node invisible
        physicsNode.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        
        self.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: largerShape, options: nil))
        self.physicsBody?.categoryBitMask = CollisionTypes.zombie.rawValue
        self.physicsBody?.contactTestBitMask = CollisionTypes.castle.rawValue | CollisionTypes.arrow.rawValue
        self.physicsBody?.collisionBitMask = 0
        
        let healthBar = SCNBox(width: 0.4, height: 0.05, length: 0.02, chamferRadius: 0)
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
            healthBarNode.position = SCNVector3(x: 0, y: 0, z: 0) // Slightly in front of the border
            
            borderNode.addChildNode(healthBarNode)
            physicsNode.addChildNode(borderNode)
            
            let moveAction = SCNAction.move(to: SCNVector3(x: 0, y: 0, z: 0.5), duration: timeWalking)
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
            changeToDeadZombie()
        } else {
            showHitEffect()
        }
    }
    
    private func changeToDeadZombie() {
        // Remove current zombie nodes
        self.childNodes.forEach { $0.removeFromParentNode() }
        
        // Remove physics body
        self.physicsBody = nil
        
        // Load the dead zombie scene
        let zombieDiedScene = SCNScene(named: "art.scnassets/ZombieDied.scn")!
        if let deadZombieNode = zombieDiedScene.rootNode.childNode(withName: "scene", recursively: true) {
            deadZombieNode.position = SCNVector3(x: 0, y: -0.5, z: 0)
            
            // Add the dead zombie node to the current node
            self.addChildNode(deadZombieNode)
            
            // Define the rotation and fall effect
            let rotateAction = SCNAction.rotateBy(x: -CGFloat.pi / 2, y: 0, z: 0, duration: 0.5)
            let fallAction = SCNAction.moveBy(x: 0, y: 0, z: 0, duration: 0.5)
            let fallEffect = SCNAction.group([rotateAction, fallAction])
            
            // Make the node vanish after 2 seconds
            let vanishAction = SCNAction.sequence([
                fallEffect,
                SCNAction.wait(duration: 1.5),
                SCNAction.removeFromParentNode()
            ])
            deadZombieNode.runAction(vanishAction)
        }
    }
    
    private func updateHealthBar() {
        let newWidth = CGFloat(health) * 0.1333
        healthBarNode.geometry = SCNBox(width: newWidth, height: 0.05, length: 0.02, chamferRadius: 0)
        healthBarNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red.withAlphaComponent(0.8)
        
        if health == 2 {
            healthBarNode.position = SCNVector3(x: -0.065, y: 0, z: 0)
        } else if health == 1 {
            healthBarNode.position = SCNVector3(x: -0.133, y: 0, z: 0)
        } else if health == 0 {
            healthBarNode.position = SCNVector3(x: -0.2, y: 0, z: 0)
        }
    }
    
    private func showHitEffect() {
        let colorChange = SCNAction.customAction(duration: 0.1) { node, elapsedTime in
            let zombieNode = node.childNodes.first { $0.geometry != nil }
            zombieNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.red.withAlphaComponent(0.8)
        }
        
        let revertColor = SCNAction.customAction(duration: 0.1) { node, elapsedTime in
            let zombieNode = node.childNodes.first { $0.geometry != nil }
            zombieNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        }
        
        // Define the knockback effect
        let currentPosition = self.position
        let knockbackPosition1 = SCNVector3(currentPosition.x, currentPosition.y + 0.1, currentPosition.z - 0.25)
        let knockbackPosition2 = SCNVector3(currentPosition.x, currentPosition.y, currentPosition.z - 0.5)
        
        let knockback1 = SCNAction.move(to: knockbackPosition1, duration: 0.05)
        let knockback2 = SCNAction.move(to: knockbackPosition2, duration: 0.05)
        let moveAction = SCNAction.move(to: SCNVector3(x: 0, y: 0, z: 0.5), duration: timeTakenWalking)
        
        let sequence = SCNAction.sequence([colorChange, knockback1, revertColor, knockback2, moveAction])
        self.removeAllActions()
        self.runAction(sequence)
    }

}


