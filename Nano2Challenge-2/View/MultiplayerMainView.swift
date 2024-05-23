//
//  MultiplayerMainView.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 23/05/24.
//

import SwiftUI

struct MultiplayerMainView: View {
    @State private var spawningZombiePage: Int = 2
    @State private var multiplayer = ControllerMultiplayer()
//    @State private var activateDebugOptions: Bool = true
    @State var message: String = "Test Make Words"
    @State private var navigateToMultiplayerView: Bool = false
    let deviceType = UIDevice.current.userInterfaceIdiom
    
    var body: some View {
        ZStack {
//            ARViewContainer(spawningZombiePage: $spawningZombiePage)
            ARViewContainerMultiplayer(multiplayer: $multiplayer)
                .ignoresSafeArea()
                .onReceive(multiplayer.$message.receive(on: DispatchQueue.main)) { value in
                    message = value
                }
            
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
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
    }
}


#Preview {
    MultiplayerMainView()
}
