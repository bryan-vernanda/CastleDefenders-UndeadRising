//
//  Castle.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 16/05/24.
//

import Foundation
import SceneKit

class Castle: SCNNode{
    var health: Int = 5
    var healthBarNode: SCNNode = SCNNode()
    
    override init() {
        super.init()
        
        let castleScene = SCNScene(named: "art.scnassets/Castle.scn")!
        
        self.position = SCNVector3(x: 0, y: -0.5, z: 0.5)
        
        let largerShape = SCNBox(width: 0.55, height: 0.9, length: 0.01, chamferRadius: 0)
        
        //create physics node for the new physics body
        let physicsNode = SCNNode(geometry: largerShape) // the geometry inside is used only for debugging when changing the UIColor below
        
        //make the node invisible
        physicsNode.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        
        self.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: largerShape, options: nil))
        self.physicsBody?.categoryBitMask = CollisionTypes.castle.rawValue
        self.physicsBody?.contactTestBitMask = CollisionTypes.zombie.rawValue
        self.physicsBody?.collisionBitMask = 0
        
        let healthBar = SCNBox(width: 1.8, height: 0.05, length: 0.02, chamferRadius: 0)
        self.healthBarNode = SCNNode(geometry: healthBar)
        healthBarNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red.withAlphaComponent(0.8)
        
        let border = SCNBox(width: 1.81, height: 0.06, length: 0.01, chamferRadius: 0)
        let borderNode = SCNNode(geometry: border)
        borderNode.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        
        if let castleNode = castleScene.rootNode.childNode(withName: "scene", recursively: true) {
            
            self.addChildNode(physicsNode)
            physicsNode.addChildNode(castleNode)
            
            borderNode.position = SCNVector3(x: 0, y: 2, z: 0.5)
            healthBarNode.position = SCNVector3(x: 0, y: 0, z: 0)
            
            borderNode.addChildNode(healthBarNode)
            physicsNode.addChildNode(borderNode)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func healBackCastle() {
        health = 5
        updateHealthBar()
    }
    
    func takeDamage(spawningZombiePage: Int) {
        
        if spawningZombiePage == 2 {
            if health <= 0 {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .castleDestroyed, object: nil)
                }
            } else {
                health -= 1
                updateHealthBar()
            }
        }
        
    }
    
    private func updateHealthBar() {
        let newWidth = CGFloat(health) * 0.36
        healthBarNode.geometry = SCNBox(width: newWidth, height: 0.05, length: 0.02, chamferRadius: 0)
        healthBarNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red.withAlphaComponent(0.8)
        
        if health == 5{
            healthBarNode.position = SCNVector3(x: 0, y: 0, z: 0)
        } else if health == 4 {
            healthBarNode.position = SCNVector3(x: 0.18, y: 0, z: 0)
        } else if health == 3 {
            healthBarNode.position = SCNVector3(x: 0.36, y: 0, z: 0)
        } else if health == 2 {
            healthBarNode.position = SCNVector3(x: 0.54, y: 0, z: 0)
        } else if health == 1 {
            healthBarNode.position = SCNVector3(x: 0.72, y: 0, z: 0)
        } else if health == 0 {
            healthBarNode.position = SCNVector3(x: 0.9, y: 0, z: 0)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .castleDestroyed, object: nil)
            }
        }
    }
}

extension Notification.Name {
    static let castleDestroyed = Notification.Name("castleDestroyed")
}
