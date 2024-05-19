//
//  GameplayView.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 18/05/24.
//

import SwiftUI

import SwiftUI

struct GameplayView: View {
    @State private var spawningZombiePage: Int = 2
    @State private var showBackground: Bool = true
    @State private var remainingTime: Int = 10

    @State private var randomGIFName: String

    let gifNames = ["gif1", "gif2", "gif3", "gif4"]
    
    init() {
        // Initialize randomGIFName here
        _randomGIFName = State(initialValue: gifNames.randomElement() ?? "gif1")
    }
    
    var body: some View {
        ZStack {
            ARViewContainer(spawningZombiePage: $spawningZombiePage)
                .ignoresSafeArea()
                .overlay(alignment: .bottom) {
                    Button {
                        ARManager.shared.actionStream.send(.attackButton)
                    } label: {
                        Image("AttackBowButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                    }
                    .position(x: UIScreen.main.bounds.width - 150, y: UIScreen.main.bounds.height - 150)
                    
                    Image(systemName: "plus")
                        .resizable()
                        .foregroundColor(Color.white)
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .navigationBarBackButtonHidden(true)
            
            if showBackground {
                ZStack {
                    Color.white
                        .ignoresSafeArea()
                        .onAppear {
                            startCountdown()
                        }
                    VStack {
                        if randomGIFName == "gif4" {
                            GIFImageView(gifName: $randomGIFName)
                                .scaledToFit()
                                .frame(height: 200)
                        } else {
                            GIFImageView(gifName: $randomGIFName)
                                .scaledToFit()
                                .frame(width: 100)
                        }
                        Text("Game will start in")
                            .font(.title)
                            .foregroundColor(.black)
                        Text("\(remainingTime)")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
    
    private func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                withAnimation(.easeInOut(duration: 2)) {
                    showBackground = false
                }
                timer.invalidate()
            }
        }
    }
}

#Preview {
    GameplayView()
}
