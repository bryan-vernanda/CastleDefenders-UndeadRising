//
//  Testing.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 19/05/24.
//

import SwiftUI
import Combine

struct TiltPhone: View {
    @ObservedObject private var accelManager = AccelometerManager.shared
    @State private var navigateToGameplayView: Bool = false
    @State private var timerCancellable: AnyCancellable?
    let deviceType = UIDevice.current.userInterfaceIdiom
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("HoldingIpadHorizontal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: deviceType == .pad ? UIScreen.main.bounds.width / 4.5 : UIScreen.main.bounds.width / 4)
                Text("Hold your device upright with the screen facing you.")
                    .font(deviceType == .pad ? .title : .body)
            }
            .onAppear {
                startTimer()
            }
            .onDisappear {
                stopTimer()
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $navigateToGameplayView) {
                SingleplayerView()
            }
        }
    }
    
    private func startTimer() {
        timerCancellable = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if (accelManager.x <= -0.878) && (accelManager.x >= -0.9879) {
                    navigateToGameplayView = true
                }
            }
    }

    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
}

#Preview {
    TiltPhone()
}
