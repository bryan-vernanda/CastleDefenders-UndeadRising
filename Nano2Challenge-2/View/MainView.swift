//
//  MainView.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 17/05/24.
//

import SwiftUI

struct MainView: View {
//    @State private var spawningZombiePage: Int = 1
//    @State private var checkFirstIndicator: Bool = true
    @State private var navigateToGameplayView: Bool = false
    @State private var navigateToMultiplayerView: Bool = false
    @State private var checkStatusNotShowingAR2: Bool = false
    @State private var checkStatusNotShowingAR1: Bool = false
    @StateObject private var singleplayer: ViewController
    
    init() {
        _singleplayer = StateObject(wrappedValue: ViewController(spawningZombiePage: .constant(1)))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !checkStatusNotShowingAR1 && !checkStatusNotShowingAR2 {
                    ARViewContainer(singleplayer: singleplayer)
                }
                
                VStack(alignment: .center) {
                    Button {
                        navigateToGameplayView = true
                    } label: {
                        Image("SingeplayerButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width/1.959)
                    }
                    .padding(.bottom)
                    
                    Button {
                        navigateToMultiplayerView = true
                    } label: {
                        Image("MultiplayerButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width/1.959)
                    }
                }
            }
            .onChange(of: navigateToGameplayView, { _, newValue in
                if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        // Delay to ensure ARViewContainer has time to run
                        checkStatusNotShowingAR1 = true
                    }
                }
            })
            .onChange(of: navigateToMultiplayerView, { _, newValue in
                if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        // Delay to ensure ARViewContainer has time to run
                        checkStatusNotShowingAR2 = true
                    }
                }
            })
            .navigationDestination(isPresented: $checkStatusNotShowingAR1) {
                TiltPhone()
            }
            .navigationDestination(isPresented: $checkStatusNotShowingAR2) {
                MultiplayerView()
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
        }
    }
}


#Preview {
    MainView()
}
