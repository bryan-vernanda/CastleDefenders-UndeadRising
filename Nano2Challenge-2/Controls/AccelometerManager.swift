//
//  AccelometerManager.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 19/05/24.
//

import Foundation
import CoreMotion

class AccelometerManager: ObservableObject {
    private let manager = CMMotionManager()
    @Published var x = 0.0
    @Published var y = 0.0
    @Published var z = 0.0
    
    private init(){
        manager.accelerometerUpdateInterval = 1
        
        manager.startAccelerometerUpdates(to: OperationQueue.current!) { [weak self] data, error in
            if let myData = data {
                DispatchQueue.main.async {
                    self?.x = myData.acceleration.x
                    self?.y = myData.acceleration.y
                    self?.z = myData.acceleration.z
                }
            }
        }
    }

    static let shared = AccelometerManager()
}
