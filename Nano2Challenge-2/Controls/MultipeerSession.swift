//
//  MultipeerSession.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 23/05/24.
//

import MultipeerConnectivity

public typealias PeerID = MCPeerID

/// - Tag: MultipeerSession
open class MultipeerSession: NSObject {
    private var serviceType: String!
    
    private let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    private var session: MCSession!
    private var serviceAdvertiser: MCNearbyServiceAdvertiser!
    private var serviceBrowser: MCNearbyServiceBrowser!
    
    private let receivedDataHandler: (Data, MCPeerID) -> Void
    private let peerJoinedHandler: (MCPeerID) -> Void
    private let peerLeftHandler: (MCPeerID) -> Void
    private let peerDiscoveredHandler: (MCPeerID) -> Bool
    
    /// A dictionary to map MultiPeer IDs to ARSession ID's. This is useful for keeping track of which peer created which ARAnchors.
    public var peerSessionIDs = [MCPeerID: String]()

    /**
     Creates a multipeer session.
     - parameters:
     - serviceName: a short text string that describes the app's networking protocol, in the same format as a Bonjour service type. For details on naming requirements: https://developer.apple.com/documentation/multipeerconnectivity/mcnearbyservicebrowser/1407094-init
     - receivedDataHandler
     - peerJoinedHandler
     - peerLeftHandler
     - peerDiscoveredHandler
     */
    public init(serviceName: String,
         receivedDataHandler: @escaping (Data, PeerID) -> Void,
         peerJoinedHandler: @escaping (PeerID) -> Void,
         peerLeftHandler: @escaping (PeerID) -> Void,
         peerDiscoveredHandler: @escaping (PeerID) -> Bool) {
        self.serviceType = serviceName
        self.receivedDataHandler = receivedDataHandler
        self.peerJoinedHandler = peerJoinedHandler
        self.peerLeftHandler = peerLeftHandler
        self.peerDiscoveredHandler = peerDiscoveredHandler
        
        super.init()
        
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: serviceType)
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
        
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
    }
    
    public func sendToAllPeers(_ data: Data, reliably: Bool) {
        sendToPeers(data, reliably: reliably, peers: connectedPeers)
    }
    
    /// - Tag: SendToPeers
    public func sendToPeers(_ data: Data, reliably: Bool, peers: [MCPeerID]) {
        guard !peers.isEmpty else { return }
        do {
            try session.send(data, toPeers: peers, with: reliably ? .reliable : .unreliable)
        } catch {
            print("error sending data to peers \(peers): \(error.localizedDescription)")
        }
    }
    
    public var connectedPeers: [MCPeerID] {
        return session.connectedPeers
    }
}

extension MultipeerSession: MCSessionDelegate {
    
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if state == .connected {
            peerJoinedHandler(peerID)
        } else if state == .notConnected {
            peerLeftHandler(peerID)
        }
    }
    
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        receivedDataHandler(data, peerID)
    }
    
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String,
                 fromPeer peerID: MCPeerID) {
        fatalError("This service does not send/receive streams.")
    }
    
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID, with progress: Progress) {
        fatalError("This service does not send/receive resources.")
    }
    
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        fatalError("This service does not send/receive resources.")
    }
    
}

extension MultipeerSession: MCNearbyServiceBrowserDelegate {
    
    /// - Tag: FoundPeer
    public func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        // Ask the handler whether we should invite this peer or not
        let accepted = peerDiscoveredHandler(peerID)
        if accepted {
            browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
        }
    }

    public func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        // This app doesn't do anything with non-invited peers, so there's nothing to do here.
    }
    
}

extension MultipeerSession: MCNearbyServiceAdvertiserDelegate {
    
    /// - Tag: AcceptInvite
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // Call the handler to accept the peer's invitation to join.
        invitationHandler(true, self.session)
    }
}
