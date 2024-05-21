//
//  MainView.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 17/05/24.
//

import SwiftUI

struct MainView: View {
    @State private var spawningZombiePage: Int = 1
    @State private var navigateToGameplayView: Bool = false
    @State private var navigateToMultiplayerView: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !navigateToGameplayView {
                    ARViewContainer(spawningZombiePage: $spawningZombiePage)
                        .ignoresSafeArea()
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
                        navigateToMultiplayerView = true
                    } label: {
                        Image("MultiplayerButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 700)
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToGameplayView) {
                TiltPhone()
            }
            .navigationDestination(isPresented: $navigateToMultiplayerView) {
                MultiplayerView()
            }
        }
    }
}


#Preview {
    MainView()
}
