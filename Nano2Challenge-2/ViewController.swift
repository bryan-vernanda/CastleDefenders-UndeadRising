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

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    private var spawnTimer: DispatchSourceTimer?
    private var currentZPosition: Float = -5
    private let randomSource = GKRandomSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
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
                print("Spawning zombie at x: \(randomXPosition), z: \(self.currentZPosition)")
                
                // Spawn a zombie at the current position
                self.spawnZombie(at: SCNVector3(x: randomXPosition, y: 0, z: self.currentZPosition), for: parentNode)
            }
        }
        spawnTimer?.resume()
    }
    
    func spawnZombie(at position: SCNVector3, for parentNode: SCNNode) {
        // Load the zombie scene
        let zombieScene = SCNScene(named: "art.scnassets/Zombie.scn")!
        if let zombieNode = zombieScene.rootNode.childNode(withName: "scene", recursively: true) {
            // Set the position of the zombie
            zombieNode.position = position
            
            // Add the zombieNode to the parent node
            parentNode.addChildNode(zombieNode)
            
            // Optionally, add an action to move the zombie
            let moveAction = SCNAction.move(to: SCNVector3(x: 0, y: 0, z: -0.5), duration: 10.0)
            zombieNode.runAction(moveAction)
        }
    }
    
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






