//
//  MainView.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 17/05/24.
//

import SwiftUI

struct MainView: View {
    @State private var spawningZombiePage: Int = 1
//    @StateObject var viewController: ViewController
    @State private var navigateToGameplayView: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !navigateToGameplayView {
                    ARViewContainer(spawningZombiePage: $spawningZombiePage)
                        .ignoresSafeArea()
//                        .onAppear {
//                            ARManager.shared.actionStreamZombie.send(.firstPage)
//                            print("success1")
//                        }
                }
                
                VStack(alignment: .center) {
                    Button {
                        navigateToGameplayView = true
                    } label: {
                        Image("SingeplayerButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 700)
                    }
                    .padding(.bottom)
                    
                    Button {
                        // add action
                    } label: {
                        Image("MultiplayerButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 700)
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToGameplayView) {
                GameplayView()
            }
        }
    }
}


#Preview {
    MainView()
}
