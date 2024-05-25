//
//  EndGameView.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 25/05/24.
//

import SwiftUI

struct EndGameView: View {
    var body: some View {
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
                    
                }, label: {
                    Image("RespawnButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width/1.959)

                })
                .padding(.bottom)
                
                Button(action: {
                    
                }, label: {
                    Image("TitleScreenButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width/1.959)

                })
                
            }
        }
    }
}

#Preview {
    EndGameView()
}
