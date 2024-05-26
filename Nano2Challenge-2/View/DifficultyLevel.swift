//
//  DifficultyLevel.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 24/05/24.
//

import SwiftUI

struct DifficultyLevelView: View {
    var difficulty: Int
    let deviceType = UIDevice.current.userInterfaceIdiom
    
    var body: some View {
        HStack {
            Spacer()
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .foregroundColor(.gray)
                        .opacity(0.5)
                    Rectangle()
                        .frame(width: progressWidth(for: difficulty, in: geometry.size.width), height: geometry.size.height)
                        .foregroundColor(color(for: difficulty))
                }
                .cornerRadius(8.0)
            }
            .frame(width: UIScreen.main.bounds.width/5, height: deviceType == .pad ? UIScreen.main.bounds.height/50 : UIScreen.main.bounds.height/30)
            Spacer()
        }
    }
    
    private func progressWidth(for difficulty: Int, in totalWidth: CGFloat) -> CGFloat {
        let maxDifficulty = 3
        return CGFloat(difficulty) / CGFloat(maxDifficulty) * totalWidth
    }
    
    private func color(for difficulty: Int) -> Color {
        switch difficulty {
        case 1:
            return .green
        case 2:
            return .orange
        case 3:
            return .red
        default:
            return .gray
        }
    }
}

struct DifficultyTextView: View {
    var difficulty: Int
    var text: String
    let deviceType = UIDevice.current.userInterfaceIdiom
    
    var body: some View {
        Text(text)
            .foregroundColor(color(for: difficulty))
            .font(deviceType == .pad ? .title2 : .title3)
            .bold()
    }
    
    private func color(for difficulty: Int) -> Color {
        switch difficulty {
        case 1:
            return .green
        case 2:
            return .orange
        case 3:
            return .red
        default:
            return .gray
        }
    }
}

struct DifficultyLevel: View {
    var difficultyLevel: Int = 1
    var difficultyText: String = "Easy"
    var body: some View {
            VStack {
                DifficultyLevelView(difficulty: difficultyLevel)
                HStack {
                    DifficultyTextView(difficulty: difficultyLevel, text: "Level: " + difficultyText)
                }
            }
        .padding()
    }
}

#Preview {
    DifficultyLevel()
}
