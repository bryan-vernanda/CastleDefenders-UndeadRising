//
//  MainView.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 17/05/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewController: ViewController = ViewController()
    
    var body: some View {
        ARViewContainer(viewController: viewController)
            .ignoresSafeArea()
    }
}

struct ARViewContainer: UIViewControllerRepresentable {
    let viewController: ViewController
    
    func makeUIViewController(context: Context) -> ViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
    }
}

#Preview {
    MainView()
}
