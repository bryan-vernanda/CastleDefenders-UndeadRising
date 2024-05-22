//
//  MultiplayerView.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 21/05/24.
//

import SwiftUI

struct MultiplayerView: View {
    let deviceType = UIDevice.current.userInterfaceIdiom
    
    var body: some View {
        ZStack {
            MultiplayerView()
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
        }
        .ignoresSafeArea()
    }
}

#Preview {
    MultiplayerView()
}
