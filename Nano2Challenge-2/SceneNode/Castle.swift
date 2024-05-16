//
//  Castle.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 16/05/24.
//

import Foundation
import SceneKit

class Castle: SCNNode{
    override init() {
        super.init()
        
        let castleScene = SCNScene(named: "art.scnassets/SmallCastle.scn")!
        
        self.position = SCNVector3(x: 0, y: -0.5, z: 0.5)
        
        self.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: self, options: nil))
        self.physicsBody?.categoryBitMask = CollisionTypes.castle.rawValue
        self.physicsBody?.contactTestBitMask = CollisionTypes.zombie.rawValue
        
        if let castleNode = castleScene.rootNode.childNode(withName: "scene", recursively: true) {
            self.addChildNode(castleNode)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
