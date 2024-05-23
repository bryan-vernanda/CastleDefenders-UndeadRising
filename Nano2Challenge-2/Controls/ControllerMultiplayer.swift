//
//  ControllerMultiplayer.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 21/05/24.
//

import UIKit
import ARKit
import SceneKit
import Foundation
import GameplayKit
import Combine
import SwiftUI
import MultipeerConnectivity

//enum CollisionTypesMul: Int {
//    case zombie = 1
//    case castle = 2
//    case arrow = 4
//}

class ControllerMultiplayer: UIViewController, ARSCNViewDelegate, ARSessionDelegate, SCNPhysicsContactDelegate, ObservableObject {
    
    @IBOutlet var sceneView2: ARSCNView!
    
    var multipeerSession: MultipeerSession?
    var sessionIDObservation: NSKeyValueObservation?
    
    private var cancellable: Set<AnyCancellable> = []
    private var cancellable1: Set<AnyCancellable> = []
    private var spawnTimer: DispatchSourceTimer?
    private var currentZPosition: Float = -5
    private let randomSource = GKRandomSource()
    
    private var isCastleAdded = false // Track if the castle has been added
    private var isSpawningZombies = false // Track if zombie spawning has started
    private var castleTransform: simd_float4x4?
    private var previousCastleTransform: simd_float4x4?
    private var indicator: Bool = true
    
    @Published var message: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView2 = ARManager2.shared2.sceneView2
        sceneView2.frame = self.view.frame
        self.view.addSubview(sceneView2)
        
        // Set the view's delegate
        sceneView2.delegate = self
        
        sceneView2.debugOptions = ARSCNDebugOptions.showFeaturePoints
        
        sceneView2.scene.physicsWorld.contactDelegate = self
        
        setupMessageObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupARView()
        
        setupMultipeerSession()
        
        sceneView2.session.delegate = self //otherwise session delegate below won't be called
        
        subscribeToActionStream()
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        message = "There are no players! Invite others to join with you."
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Invalidate the timer when the view disappears
        spawnTimer?.cancel()
        spawnTimer = nil
        
        // Pause the view's session
        sceneView2.session.pause()
        
        // Stop and reset the AR session
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView2.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        sceneView2.removeFromSuperview()
    }
    
    private func setupMessageObserver() {
        $message
            .receive(on: DispatchQueue.main) // Ensure updates are received on the main thread
            .sink { [weak self] newValue in
                guard let self = self else { return }
                self.message = newValue
            }
            .store(in: &cancellable1)
    }
    
    func addLaserRedAnchor() {
        guard let currentFrame = sceneView2.session.currentFrame else { return }
        let anchor = ARAnchor(name: "laserRed", transform: currentFrame.camera.transform)
        sceneView2.session.add(anchor: anchor)
    }
    
    func setupARView() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        config.isCollaborationEnabled = true //to send data to connected peers or else no data will be shared among peers
        
        sceneView2.session.run(config)
    }
    
    func setupMultipeerSession() {
        //user key-value observation to monitor your ARSession's identifier
        sessionIDObservation = sceneView2.session.observe(\.identifier, options: [.new]) { object, change in
            print("SessionID changed to: \(change.newValue!)")
            //tell all other peers about your ARSession's changed ID, so
            //that they can keep track of which ARAnchors are yours
            guard let multipeerSession = self.multipeerSession else { return }
            self.sendARSessionIDTo(peers: multipeerSession.connectedPeers)
        }
        //start looking for other players via MultiPeerconnectivity
        multipeerSession = MultipeerSession(serviceName: "castle-ar", receivedDataHandler:
            self.receivedData, peerJoinedHandler: self.peerJoined, peerLeftHandler: self.peerLeft, peerDiscoveredHandler: self.peerDiscovered)
    }
    
    //ini pasti bisa tapi ontap
    private func attackBowButton(for parentNode: SCNNode, pass anchor: ARAnchor) {
        // Get the position from the anchor's transform
        let position = SCNVector3(anchor.transform.columns.3.x,
                                  anchor.transform.columns.3.y,
                                  anchor.transform.columns.3.z)

        // Calculate the forward direction from the anchor's orientation
        let orientation = SCNVector3(-anchor.transform.columns.2.x,
                                     -anchor.transform.columns.2.y,
                                     -anchor.transform.columns.2.z)

        // Calculate a position in front of the anchor by moving forward from the anchor's position
        let forwardPosition = SCNVector3(position.x + orientation.x,
                                         position.y + orientation.y,
                                         position.z + orientation.z)

        // Pass the sessionIdentifier to the Arrow
        let arrow = ArrowMultiplayer(at: forwardPosition, at: orientation, sessionIdentifier: anchor.sessionIdentifier)
        arrow.look(at: SCNVector3(forwardPosition.x + orientation.x, forwardPosition.y + orientation.y, forwardPosition.z + orientation.z))

        // Add the arrow to the scene
        parentNode.addChildNode(arrow)
    }
    
    private func startSpawningZombies(for parentNode: SCNNode) {
        if !isSpawningZombies {
            isSpawningZombies = true
            // Create a dispatch timer to spawn zombies every 2 seconds
            spawnTimer = DispatchSource.makeTimerSource()
            spawnTimer?.schedule(deadline: .now(), repeating: 2.0)
            spawnTimer?.setEventHandler { [weak self] in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    // Generate a random x position between -5 and 5
                    let randomXPosition = Float(self.randomSource.nextInt(upperBound: 11)) - 5.0
    //                print("Spawning zombie at x: \(randomXPosition), z: \(self.currentZPosition)")
                    
                    // Spawn a zombie at the current position
                    self.spawnZombie(at: SCNVector3(x: randomXPosition, y: -0.5, z: self.currentZPosition), for: parentNode)
                }
            }
            spawnTimer?.resume()
        }
    }
    
    private func spawnZombie(at position: SCNVector3, for parentNode: SCNNode) {
        let zombie = Zombie(at: position)
        parentNode.addChildNode(zombie)
    }
    
    private func addCastle(for parentNode: SCNNode) {
        if !isCastleAdded {
            isCastleAdded = true
            
            let castle = Castle()
            parentNode.addChildNode(castle)
        }
    }
    
    private func subscribeToActionStream() {
        ARManager2.shared2
            .actionStream2
            .sink { [weak self] action in
                guard let self = self else { return }
                switch action {
                    case .attackButton:
                        self.addLaserRedAnchor()
                }
            }
            .store(in: &cancellable)
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if (contact.nodeA.physicsBody?.categoryBitMask == CollisionTypes.zombie.rawValue) && (contact.nodeB.physicsBody?.categoryBitMask == CollisionTypes.castle.rawValue) {
            
            contact.nodeA.physicsBody?.categoryBitMask = 0 // this is not needed, but should be used to handle bug (collision multiple times)
            contact.nodeA.removeFromParentNode()
            (contact.nodeB as? Castle)?.takeDamage(spawningZombiePage: 2)
            
        } else if (contact.nodeA.physicsBody?.categoryBitMask == CollisionTypes.castle.rawValue) && (contact.nodeB.physicsBody?.categoryBitMask == CollisionTypes.zombie.rawValue) {

            contact.nodeB.physicsBody?.categoryBitMask = 0 // this is not needed, but should be used to handle bug (collision multiple times)
            contact.nodeB.removeFromParentNode()
            (contact.nodeA as? Castle)?.takeDamage(spawningZombiePage: 2)
            
        }
        
        if (contact.nodeA.physicsBody?.categoryBitMask == CollisionTypes.arrow.rawValue) && (contact.nodeB.physicsBody?.categoryBitMask == CollisionTypes.zombie.rawValue) {
            
            contact.nodeA.physicsBody?.categoryBitMask = 0 // this is not needed, but should be used to handle bug (collision multiple times)
            contact.nodeA.removeFromParentNode()
            (contact.nodeB as? Zombie)?.takeDamage()
            
        } else if (contact.nodeA.physicsBody?.categoryBitMask == CollisionTypes.zombie.rawValue) && (contact.nodeB.physicsBody?.categoryBitMask == CollisionTypes.arrow.rawValue) {
            
            contact.nodeB.physicsBody?.categoryBitMask = 0 // this is not needed, but should be used to handle bug (collision multiple times)
            contact.nodeB.removeFromParentNode()
            (contact.nodeA as? Zombie)?.takeDamage()
            
        }
        
    }

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let anchorName = anchor.name, anchorName == "laserRed" {
                // Call attackBowButton for the parent node
                attackBowButton(for: sceneView2.scene.rootNode, pass: anchor)
            }

            if let participantAnchor = anchor as? ARParticipantAnchor {
                DispatchQueue.main.async {
                    if self.indicator { // player 1
                        self.castleTransform = participantAnchor.transform
                        self.previousCastleTransform = participantAnchor.transform
                        self.indicator = false
                    } else { // player 2
                        if let previousTransform = self.castleTransform {
                            // Here we concatenate the new transform with the previous one.
                            // This is a simple example, in real-world scenarios, you might need a more complex transformation logic
                            self.castleTransform = participantAnchor.transform + previousTransform
                        }
                    }
                    
                    if let castleTransforms = self.castleTransform {
                        let castleAnchor = ARAnchor(name: "castleZombieAnchor", transform: castleTransforms)
                        self.sceneView2.session.add(anchor: castleAnchor)
                        self.castleTransform = self.previousCastleTransform
                    } else {
                        print("Error: castleTransform is nil")
                    }
                }
            }
            
            if anchor.name == "castleZombieAnchor" {
                let dispatchGroup = DispatchGroup()

                dispatchGroup.enter()
                DispatchQueue.main.async {
                    print("successfully connected with another user!")
                    self.message = "Established joint experience with other players."
                    self.sceneView2.debugOptions = []
                    dispatchGroup.leave()
                }

                dispatchGroup.notify(queue: .main) {
                    // Add castle and start spawning zombies only after the message is updated
                    self.addCastle(for: self.sceneView2.scene.rootNode)
                    self.startSpawningZombies(for: self.sceneView2.scene.rootNode)
                }
            }
        }
    }
}

//MARK: - MultipeerSession

extension ControllerMultiplayer {
    private func sendARSessionIDTo(peers: [PeerID]) {
        guard let multipeerSession = multipeerSession else { return }
        let idString = sceneView2.session.identifier.uuidString
        let command = "SessionID:" + idString
        if let commandData = command.data(using: .utf8) {
            multipeerSession.sendToPeers(commandData, reliably: true, peers: peers)
        }
    }
    
    func receivedData(_ data: Data, from peer: PeerID) {
        guard let multipeerSession = multipeerSession else { return }
        
        if let collaborationData = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARSession.CollaborationData.self, from: data) {
            sceneView2.session.update(with: collaborationData)
            return
        }
        
        let sessionIDCommandString = "SessionID:"
        if let commandString = String(data: data, encoding: .utf8), commandString.starts(with: sessionIDCommandString) {
            let newSessionID = String(commandString[commandString.index(commandString.startIndex, offsetBy: sessionIDCommandString.count)...])
            // If this peer was using a different session ID before, remove all its associated anchors.
            // This will remove the old participant anchor and its geometry from the scene.
            if let oldSessionID = multipeerSession.peerSessionIDs[peer] {
                removeAllAnchorsOriginatingFromARSessionWithID(oldSessionID)
            }
            
            multipeerSession.peerSessionIDs[peer] = newSessionID
        }
    }
    
    func peerDiscovered(_ peer: PeerID) -> Bool {
        guard let multipeerSession = multipeerSession else { return false }
        
        if multipeerSession.connectedPeers.count > 2 {
            // Do not accept more than four users in the experience.
           print("A third player wants to join.The game is currently limited to two players")
//            message = "A third player wants to join. The game is currently limited to two players"
            return false
        } else {
            return true
        }
    }
    
    func peerJoined(_ peer: PeerID) {
        DispatchQueue.main.async {
            print("A player wants to join the game. Hold the devices next to each other.")
            self.message = "A player wants to join the game. Hold the devices next to each other."
        }
        // Provide your session ID to the new user so they can keep track of your anchors.
        sendARSessionIDTo(peers: [peer])
    }
    
    func peerLeft(_ peer: PeerID) {
        guard let multipeerSession = multipeerSession else { return }
        
        DispatchQueue.main.async {
            print("A player has left the game")
            self.message = "A player has left the game."
        }
        
        // Remove all ARAnchors associated with the peer that just left the experience.
        if let sessionID = multipeerSession.peerSessionIDs[peer] {
            removeAllAnchorsOriginatingFromARSessionWithID(sessionID)
            multipeerSession.peerSessionIDs.removeValue(forKey: peer)
        }
    }
    
    private func removeAllAnchorsOriginatingFromARSessionWithID(_ identifier: String) {
        guard let frame = sceneView2.session.currentFrame else { return }
        for anchor in frame.anchors {
            guard let anchorSessionID = anchor.sessionIdentifier else { continue }
            if anchorSessionID.uuidString == identifier {
                sceneView2.session.remove(anchor: anchor)
            }
        }
    }
    
    func session(_ session: ARSession, didOutputCollaborationData data: ARSession.CollaborationData) {
        guard let multipeerSession = multipeerSession else { return }
        if !multipeerSession.connectedPeers.isEmpty {
            guard let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
            else { fatalError("Unexpectedly failed to encode collaboration data.") }
            // Use reliable mode if the data is critical, and unreliable mode if the data is optional.
            let dataIsCritical = data.priority == .critical
            multipeerSession.sendToAllPeers(encodedData, reliably: dataIsCritical)
        } else {
            print("Deferred sending collaboration to later because there are no peers.")
        }
    }
}
