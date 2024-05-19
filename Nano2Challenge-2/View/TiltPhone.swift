//
//  Testing.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 19/05/24.
//

import SwiftUI

struct TiltPhone: View {
    @ObservedObject private var accelManager = AccelometerManager.shared
    @State private var navigateToGameplayView: Bool = false
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("HoldingIpadHorizontal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                Text("Please position your phone so that it looks like the above to play the game")
                    .font(.title2)
            }
            .navigationBarBackButtonHidden(true)
            .onReceive(timer) { _ in
                if (accelManager.x <= -0.878) &&
                   (accelManager.x >= -0.9879) {
                    navigateToGameplayView = true
                }
            }
            .navigationDestination(isPresented: $navigateToGameplayView) {
                GameplayView()
            }
        }
    }
}

#Preview {
    TiltPhone()
}
