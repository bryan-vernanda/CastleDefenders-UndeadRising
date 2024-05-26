//
//  ARViewContainer.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 18/05/24.
//

import SwiftUI

struct ARViewContainer: UIViewControllerRepresentable {
    @ObservedObject var singleplayer: ViewController
    
    func makeUIViewController(context: Context) -> ViewController {
        return singleplayer
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
    }
}

struct ARViewContainerMultiplayer: UIViewControllerRepresentable {
    @ObservedObject var multiplayer: ControllerMultiplayer
    
    func makeUIViewController(context: Context) -> ControllerMultiplayer {
        return multiplayer
    }
    
    func updateUIViewController(_ uiViewController: ControllerMultiplayer, context: Context) {
    }
}
