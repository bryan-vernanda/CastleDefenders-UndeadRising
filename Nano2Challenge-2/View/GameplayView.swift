//
//  GameplayView.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 18/05/24.
//

import SwiftUI

struct GameplayView: View {
    @State private var spawningZombiePage: Int = 2
    @State private var showBackground: Bool = true
    @State private var remainingTime: Int = 5

    @State private var randomGIFName: String

    var gifNames = ["gif1", "gif2", "gif3", "gif4"]
    let deviceType = UIDevice.current.userInterfaceIdiom
    
    init() {
        // Initialize randomGIFName here
        if deviceType != .pad {
            gifNames = ["gif1", "gif4"]
        }
        _randomGIFName = State(initialValue: gifNames.randomElement() ?? "gif1")
    }
    
    var body: some View {
        ZStack {
            ARViewContainer(spawningZombiePage: $spawningZombiePage)
                .overlay(alignment: .bottom) {
                    Button {
                        ARManager.shared.actionStream.send(.attackButton)
                    } label: {
                        Image("AttackBowButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width/8)
                    }
                    .position(x: UIScreen.main.bounds.width/1.12, y: deviceType == .pad ? UIScreen.main.bounds.height/1.18 :  UIScreen.main.bounds.height/1.3)
                    
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
                                    .frame(height: deviceType == .pad ? UIScreen.main.bounds.height / 5 : UIScreen.main.bounds.height / 2)
                        } else {
                            GIFImageView(gifName: $randomGIFName)
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width/6)
                        }
                        Text("Game will start in")
                            .font(deviceType == .pad ? .title : .title2)
                            .foregroundColor(.black)
                        Text("\(remainingTime)")
                            .font(deviceType == .pad ? .largeTitle: .title)
                            .bold()
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
    
    private func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                withAnimation(.easeInOut(duration: 0.1)) {
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
