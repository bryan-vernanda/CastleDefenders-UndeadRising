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
            .overlay(alignment: .bottom){
                Button {
                    ARManager.shared.actionStream.send(.attackButton)
                } label: {
                    Image("AttackBowButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width:150, height: 150)
                }
                .position(x: UIScreen.main.bounds.width - 150, y: UIScreen.main.bounds.height - 150)
                
                Image(systemName: "plus")
                    .resizable()
                    .foregroundColor(Color.white)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
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
