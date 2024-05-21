//
//  MultiplayerView.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 21/05/24.
//

import SwiftUI

struct MultiplayerView: View {
    var body: some View {
        ARViewContainerMultiplayer()
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MultiplayerView()
}
