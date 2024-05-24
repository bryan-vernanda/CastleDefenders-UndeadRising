//
//  MultiplayerView.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 21/05/24.
//

import SwiftUI

struct MultiplayerView: View {
    //    @State private var spawningZombiePage: Int = 2
    @StateObject private var multiplayer = ControllerMultiplayer()
    @State var message: String = ""
    let deviceType = UIDevice.current.userInterfaceIdiom
    
    @State private var doneShowBackground: Bool = false
    @State private var remainingTime: Int = 10
    @State private var randomProTip: String
    @State private var showConnectedStatus: Bool = true
    
//    var gifNames = ["gif1", "gif2", "gif3", "gif4"]
    var proTips = [
        "If you keep losing, it might be time to take a break.",
        "Too many zombies? Just spam your attacks!",
        "As you advance to higher levels, zombies become more numerous and faster!",
        "Find a reliable and skilled friend to play with.",
        "If you lose, the restart button is your best friend."
    ]
    
    init() {
        _randomProTip = State(initialValue: proTips.randomElement() ?? "If you keep losing, it might be time to take a break.")
    }
    
    var body: some View {
        ZStack {
            //            ARViewContainer(spawningZombiePage: $spawningZombiePage)
            ARViewContainerMultiplayer(multiplayer: multiplayer)
                .ignoresSafeArea()
                .overlay(alignment: .bottom) {
                    if message == "Established joint experience with other players." {
                        if !doneShowBackground {
                            ZStack {
                                Color.white
                                    .ignoresSafeArea()
                                VStack {
                                    Spacer() // Pushes the VStack to the top
                                    HStack {
                                        Image(systemName: "exclamationmark.circle")
                                            .font(deviceType == .pad ? .title : .title2)
                                            .bold()
                                            .foregroundColor(.red)
                                        Text("Objective")
                                            .font(deviceType == .pad ? .title : .title2)
                                            .bold()
                                            .foregroundColor(.red)
                                    }
                                    .padding(.bottom, 2)
                                    Text("🧟‍♂️ Survive the endless waves of zombies until time runs out! 🧟‍♂️")
                                        .font(deviceType == .pad ? .title : .title2)
                                        .foregroundColor(.black)
                                        .padding(.bottom, 7)
                                    Text("Tip: \(randomProTip)")
                                        .font(deviceType == .pad ? .title3 : .subheadline)
                                        .foregroundColor(.black)
                                        .opacity(0.7)
                                    Spacer()
                                    VStack {
                                        Text("Game will start in...")
                                            .font(deviceType == .pad ? .title : .title2)
                                            .foregroundColor(.black)
                                        Text("\(remainingTime)")
                                            .font(deviceType == .pad ? .largeTitle : .title)
                                            .bold()
                                            .foregroundColor(.black)
                                            .padding(.bottom, 50)
                                    }
                                    .padding(.bottom, 20)
                                }
                            }
                            .onAppear{
                                showConnectedStatus = false
                                startCountdown()
                            }
                        } else {
                            Button {
                                ARManager2.shared2.actionStream2.send(.attackButton)
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
                    } else {
                        VStack {
                            ZStack {
                                Rectangle()
                                    .fill(Color.black)
                                    .opacity(0.5)
                                    .frame(height: deviceType == .pad ? 70 : 60)
                                    .edgesIgnoringSafeArea(.top)
                                HStack {
                                    Text(message)
                                        .font(deviceType == .pad ? .title2 : .title3)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding(deviceType == .pad ? EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16) : EdgeInsets(top: 16, leading: 40, bottom: 16, trailing: 16))
                                
                            }
                            Spacer()
                        }
                    }
                    
                    if showConnectedStatus {
                        VStack {
                            Spacer()
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(message == "Established joint experience with other players." ? Color.green : Color.red)
                                        .frame(width: deviceType == .pad ? 40 : 35, height: deviceType == .pad ? 40 : 35)
                                    
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: deviceType == .pad ? 30 : 25, height: deviceType == .pad ? 30 : 25)
                                        .blendMode(.destinationOut)
                                    
                                    Circle()
                                        .fill(message == "Established joint experience with other players." ? Color.green : Color.red)
                                        .frame(width: deviceType == .pad ? 15 : 10, height: deviceType == .pad ? 15 : 10)
                                }
                                .compositingGroup()
                                Text(message == "Established joint experience with other players." ? "Connected" : "Not Connected")
                                    .font(deviceType == .pad ? .title3 : .body)
                                    .foregroundColor(message == "Established joint experience with other players." ? .green : .red)
                                    .bold()
                                Spacer()
                            }
                        }
                        .padding(deviceType == .pad ? EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16) : EdgeInsets(top: 16, leading: 40, bottom: 16, trailing: 16))
                    }
                    
                }
                .onReceive(multiplayer.$message.receive(on: DispatchQueue.main)) { value in
                    message = value
                }
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
    }
    
    private func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                doneShowBackground = true
                showConnectedStatus = true
                timer.invalidate()
            }
        }
    }
   
}

#Preview {
    MultiplayerView()
}
