//
//  GameplayView.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 18/05/24.
//

import SwiftUI

struct GameplayView: View {
    @State private var spawningZombiePage: Int = 2
    
    var body: some View {
        ARViewContainer(spawningZombiePage: $spawningZombiePage)
            .ignoresSafeArea()
            .overlay(alignment: .bottom){
                Button {
                    ARManager.shared.actionStream.send(.attackButton)
                } label: {
                    Image("AttackBowButton")
                        .resizable()
                        .scaledToFit()
                        .frame(width:150, height: 150)
                }
                .position(x: UIScreen.main.bounds.width - 150, y: UIScreen.main.bounds.height - 150)
                
                Image(systemName: "plus")
                    .resizable()
                    .foregroundColor(Color.white)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    GameplayView()
}
