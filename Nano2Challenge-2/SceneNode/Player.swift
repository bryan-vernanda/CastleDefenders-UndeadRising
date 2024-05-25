//
//  Bow.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 25/05/24.
//

import Foundation
import SceneKit
import ARKit

class Player: SCNNode{
    init(at cameraOrientation: SCNVector3, pass anchor: ARAnchor) {
        super.init()
        
        self.position = cameraOrientation
        
        let triangleGeometry = SCNPyramid(width: 0.05, height: 0.05, length: 0.05)
        let triangleNode = SCNNode(geometry: triangleGeometry)
        triangleNode.eulerAngles.x = .pi // Rotate the triangle upside-down
        triangleNode.geometry?.firstMaterial?.diffuse.contents = anchor.sessionIdentifier?.toRandomColor() ?? .white
        
        self.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: self, options: nil))
        
        self.addChildNode(triangleNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UUID {
    /**
     - Tag: ToRandomColor
    Pseudo-randomly return one of several fixed standard colors, based on this UUID's first four bytes.
    */
    func toRandomColor() -> UIColor {
        var firstFourUUIDBytesAsUInt32: UInt32 = 0
        let data = withUnsafePointer(to: self) {
            return Data(bytes: $0, count: MemoryLayout.size(ofValue: self))
        }
        _ = withUnsafeMutableBytes(of: &firstFourUUIDBytesAsUInt32, { data.copyBytes(to: $0) })

        let colors: [UIColor] = [.red, .green, .blue, .yellow, .magenta, .cyan, .purple,
                                 .orange, .brown, .lightGray, .gray, .darkGray, .black, .white]
        
        let randomNumber = Int(firstFourUUIDBytesAsUInt32) % colors.count
        return colors[randomNumber]
    }
}
