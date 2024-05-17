//
//  ViewController.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 15/05/24.
//

import UIKit
import SceneKit
import ARKit
import GameplayKit

enum CollisionTypes: Int {
    case zombie = 1
    case castle = 2
}

class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate, ObservableObject {

    @IBOutlet var sceneView: ARSCNView!
    
    private var spawnTimer: DispatchSourceTimer?
    private var currentZPosition: Float = -5
    private let randomSource = GKRandomSource()
    private var limitZombies = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = ARManager.shared.sceneView
        sceneView.frame = self.view.frame
        self.view.addSubview(sceneView)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Show world anchor
        sceneView.debugOptions = .showWorldOrigin
        
        sceneView.scene.physicsWorld.contactDelegate = self
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if (contact.nodeA.physicsBody?.categoryBitMask == CollisionTypes.castle.rawValue) && (contact.nodeB.physicsBody?.categoryBitMask == CollisionTypes.zombie.rawValue) {
//            print("Zombie hit the castle!")
            contact.nodeB.removeFromParentNode()
//            print("node B removed")
        } else if (contact.nodeA.physicsBody?.categoryBitMask == CollisionTypes.zombie.rawValue) && (contact.nodeB.physicsBody?.categoryBitMask == CollisionTypes.castle.rawValue) {
//            print("Zombie hit the castle!")
            contact.nodeA.removeFromParentNode()
//            print("node A removed")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
        
        // Create an anchor at the world origin
        let anchor = ARAnchor(name: "zombieAnchor", transform: matrix_identity_float4x4)
        sceneView.session.add(anchor: anchor)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        
        // Invalidate the timer when the view disappears
        spawnTimer?.cancel()
        spawnTimer = nil
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor.name == "zombieAnchor" {
            // Add the castle to the scene
            addCastle(for: node)
            
            // Start spawning zombies at regular intervals
            startSpawningZombies(for: node)
        }
    }
    
    private func startSpawningZombies(for parentNode: SCNNode) {
        // Create a dispatch timer to spawn zombies every 2 seconds
        spawnTimer = DispatchSource.makeTimerSource()
        spawnTimer?.schedule(deadline: .now(), repeating: 2.0)
        spawnTimer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                // Generate a random x position between -5 and 5
                let randomXPosition = Float(self.randomSource.nextInt(upperBound: 11)) - 5.0
//                print("Spawning zombie at x: \(randomXPosition), z: \(self.currentZPosition)")
                
                // Spawn a zombie at the current position & limit the zombies
                if self.limitZombies < 5 {
//                    print("Spawning zombie at x: \(randomXPosition), z: \(self.currentZPosition)")
                    self.spawnZombie(at: SCNVector3(x: randomXPosition, y: -0.5, z: self.currentZPosition), for: parentNode)
                    self.limitZombies += 1
                }
            }
        }
        spawnTimer?.resume()
    }
    
    func spawnZombie(at position: SCNVector3, for parentNode: SCNNode) {
        let zombie = Zombie(at: position)
        parentNode.addChildNode(zombie)
    }
    
    func addCastle(for parentNode: SCNNode) {
        let castle = Castle()
        parentNode.addChildNode(castle)
    }
    
//    func spawnZombie(at position: SCNVector3, for parentNode: SCNNode) {
//        // Load the zombie scene
//        let zombieScene = SCNScene(named: "art.scnassets/Zombie.scn")!
//        if let zombieNode = zombieScene.rootNode.childNode(withName: "scene", recursively: true) {
//            // Set the position of the zombie
//            zombieNode.position = position
//            
//            // Add the zombieNode to the parent node
//            parentNode.addChildNode(zombieNode)
//            
//            // Optionally, add an action to move the zombie
//            let moveAction = SCNAction.move(to: SCNVector3(x: 0, y: -0.5, z: 0.6), duration: 10.0)
//            zombieNode.runAction(moveAction)
//        }
//    }
//    
//    func addCastle(for parentNode: SCNNode) {
//        let castleScene = SCNScene(named: "art.scnassets/SmallCastle.scn")!
//        if let castleNode = castleScene.rootNode.childNode(withName: "scene", recursively: true) {
//            // Set the position of the castle
//            castleNode.position = SCNVector3(x: 0, y: -0.5, z: 0.5)
//            
//            // Add the castleNode to the parent node
//            parentNode.addChildNode(castleNode)
//            
//        }
//    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
}






