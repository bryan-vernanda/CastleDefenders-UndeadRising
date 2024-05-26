//
//  EndGameView.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 25/05/24.
//

import SwiftUI

struct EndGameView: View {
    @State private var mainViewIndicator = false
    @State var playIndicator: Bool = false
    @Binding var winningCondition: Bool
    @Binding var pageToGo: Int
    @Binding var notNeedToShowAR: Bool
    @State private var checkButtonPressed: Int = 0
    let deviceType = UIDevice.current.userInterfaceIdiom
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !winningCondition {
                    Color(red: 190 / 255.0, green: 50 / 255.0, blue: 19 / 255.0, opacity: 0.3)
                        .ignoresSafeArea()
                    VStack {
                        Image("YouDiedText")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width/5)
                            .padding(.bottom)
                        
                        Image("TextEndDesc")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width/2)
                            .padding(.bottom, deviceType == .pad ? 98 : 64)
                        
                        Button(action: {
                            notNeedToShowAR = true
                            checkButtonPressed = 2
                        }, label: {
                            Image("RespawnButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width/1.959)
                            
                        })
                        .padding(.bottom)
                        
                        Button(action: {
                            notNeedToShowAR = true
                            checkButtonPressed = 1
                        }, label: {
                            Image("TitleScreenButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width/1.959)
                            
                        })
                        
                    }
                } else {
                    Color.green
                        .opacity(0.4)
                        .ignoresSafeArea()
                    VStack {
                        Image("YouWinText")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width/5)
                            .padding(.bottom)
                        
                        Image("TextWinEndDesc")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width/2)
                            .padding(.bottom, deviceType == .pad ? 98 : 64)
                        
                        Button(action: {
                            notNeedToShowAR = true
                            checkButtonPressed = 1
                        }, label: {
                            Image("TitleScreenButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width/1.959)
                            
                        })
                    }
                }
            }
            .onChange(of: notNeedToShowAR, { _, newValue in
                if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        if checkButtonPressed == 1 {
                            mainViewIndicator = true
                        } else if checkButtonPressed == 2 {
                            playIndicator = true
                        }
                    }
                }
            })
            .navigationDestination(isPresented: $mainViewIndicator) {
                MainView()
            }
            .navigationDestination(isPresented: $playIndicator) {
                if pageToGo == 1 {
                    TiltPhone()
                } else {
                    MultiplayerView()
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    EndGameView(winningCondition: .constant(true), pageToGo: .constant(1), notNeedToShowAR: .constant(false))
}
