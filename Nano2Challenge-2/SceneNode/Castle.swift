//
//  Castle.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 16/05/24.
//

import Foundation
import SceneKit

class Castle: SCNNode{
    var health: Int = 20
    var healthBarNode: SCNNode = SCNNode()
    
    override init() {
        super.init()
        
        let castleScene = SCNScene(named: "art.scnassets/Castle.scn")!
        
        self.position = SCNVector3(x: 0, y: -0.5, z: 0.5)
        
        self.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: self, options: nil))
        self.physicsBody?.categoryBitMask = CollisionTypes.castle.rawValue
        self.physicsBody?.contactTestBitMask = CollisionTypes.zombie.rawValue
        
        let healthBar = SCNBox(width: 0.4, height: 0.05, length: 0.01, chamferRadius: 0)
        self.healthBarNode = SCNNode(geometry: healthBar)
        healthBarNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red.withAlphaComponent(0.8)
        
        let border = SCNBox(width: 0.41, height: 0.06, length: 0.01, chamferRadius: 0)
        let borderNode = SCNNode(geometry: border)
        borderNode.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        
        if let castleNode = castleScene.rootNode.childNode(withName: "scene", recursively: true) {
            self.addChildNode(castleNode)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
