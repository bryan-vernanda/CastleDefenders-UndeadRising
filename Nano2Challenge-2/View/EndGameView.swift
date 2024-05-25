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
    @Binding var pageToGo: Int
    @Binding var notNeedToShowAR: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 190 / 255.0, green: 50 / 255.0, blue: 19 / 255.0, opacity: 0.3)
                    .ignoresSafeArea()
                VStack{
                    Image("YouDiedText")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width/5)
                        .padding(.bottom)
                    
                    Image("TextEndDesc")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width/2)
                        .padding(.bottom, 98)
                    
                    Button(action: {
                        notNeedToShowAR = true
                        playIndicator = true
                    }, label: {
                        Image("RespawnButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width/1.959)

                    })
                    .padding(.bottom)
                    
                    Button(action: {
                        notNeedToShowAR = true
                        mainViewIndicator = true
                    }, label: {
                        Image("TitleScreenButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width/1.959)

                    })
                    
                }
            }
            .navigationDestination(isPresented: $mainViewIndicator) {
                MainView()
            }
            .navigationDestination(isPresented: $playIndicator) {
                if pageToGo == 1 {
                    SingleplayerView()
                } else {
                    MultiplayerView()
                }
            }
        }
    }
}

#Preview {
    EndGameView(pageToGo: .constant(1), notNeedToShowAR: .constant(false))
}
