//
//  LoadingAnimation.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 26/05/24.
//

import SwiftUI

struct LoadingAnimation: View {
    @State var isAnimating = false
    @State var circleStart: CGFloat = 0.17
    @State var circleEnd: CGFloat = 0.325
    @State var rotationDegree: Angle = .degrees(0)
    
    let trackerRotation: Double = 2
    let animationDuration: Double = 0.75
    let deviceType = UIDevice.current.userInterfaceIdiom
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            //animation
            ZStack {
                Circle()
                    .stroke(lineWidth: deviceType == .pad ? 7 : 5)
                    .fill(Color(red: 240 / 255, green: 240 / 255, blue: 240 / 255))
                    .shadow(color: .black.opacity(0.015), radius: 5, x: 1, y: 1)
                
                Circle()
                    .trim(from: circleStart, to: circleEnd)
                    .stroke(style: StrokeStyle(lineWidth: deviceType == .pad ? 7 : 5, lineCap: .round))
                    .fill(.black)
                    .rotationEffect(rotationDegree)
            }
        }
        .frame(width: deviceType == .pad ? 35 : 30, height: deviceType == .pad ? 35 : 30)
        .onAppear {
            // animate the views
            animateLoader()
            
            // loop the animation
            Timer.scheduledTimer(withTimeInterval: (trackerRotation * animationDuration) + animationDuration, repeats: true) { loadingTimer in
                animateLoader()
            }
            
        }
    }
    
    func getRotationAngle() -> Angle {
        return .degrees(360 * trackerRotation) + .degrees(120)
    }
    
    func animateLoader() {
        withAnimation(.spring(response: animationDuration * 2)) {
            rotationDegree = .degrees(-57.5)
            circleEnd = 0.325
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: false) { _ in
            withAnimation(.easeInOut(duration: trackerRotation * animationDuration)) {
                self.rotationDegree += self.getRotationAngle()
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration * 1.25, repeats: false) { _ in
            withAnimation(.easeOut(duration: (trackerRotation * animationDuration) / 2.25)) {
                circleEnd = 0.95
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: trackerRotation * animationDuration, repeats: false) { _ in
            rotationDegree = .degrees(47.5)
            withAnimation(.easeOut(duration: animationDuration)) {
                circleEnd = 0.25
            }
        }
            
    }
}

#Preview {
    LoadingAnimation()
}
