//
//  ARViewContainer.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 18/05/24.
//

import SwiftUI

struct ARViewContainer: UIViewControllerRepresentable {
    @Binding var spawningZombiePage: Int
    
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController(spawningZombiePage: $spawningZombiePage)
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
    }
}
