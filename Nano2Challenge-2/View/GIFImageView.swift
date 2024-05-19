//
//  GIFImageView.swift
//  Nano2Challenge-2
//
//  Created by Bryan Vernanda on 19/05/24.
//

import SwiftUI
import UIKit
import ImageIO
//        gifNames[Int.random(in: 0..<gifNames.count)]
struct GIFImageView: UIViewRepresentable {
    @Binding var gifName: String
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        loadGif(imageView: uiView, gifName: gifName)
    }
    
    private func loadGif(imageView: UIImageView, gifName: String) {
        if let url = Bundle.main.url(forResource: gifName, withExtension: "gif") {
            DispatchQueue.global().async {
                let imageData = try? Data(contentsOf: url)
                if let data = imageData {
                    let imageSource = CGImageSourceCreateWithData(data as CFData, nil)
                    let count = CGImageSourceGetCount(imageSource!)
                    var images: [UIImage] = []
                    var duration: TimeInterval = 0.0
                    
                    for i in 0..<count {
                        if let cgImage = CGImageSourceCreateImageAtIndex(imageSource!, i, nil) {
                            let frameDuration = UIImageView.gifFrameDuration(from: imageSource!, index: i)
                            duration += frameDuration
                            let image = UIImage(cgImage: cgImage)
                            images.append(image)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        imageView.animationImages = images
                        imageView.animationDuration = duration
                        imageView.startAnimating()
                    }
                }
            }
        }
    }
}

extension UIImageView {
    static func gifFrameDuration(from imageSource: CGImageSource, index: Int) -> TimeInterval {
        let frameProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, index, nil) as? [String: Any]
        let gifProperties = frameProperties?[kCGImagePropertyGIFDictionary as String] as? [String: Any]
        
        var frameDuration = gifProperties?[kCGImagePropertyGIFUnclampedDelayTime as String] as? TimeInterval
        
        if frameDuration == nil {
            frameDuration = gifProperties?[kCGImagePropertyGIFDelayTime as String] as? TimeInterval
        }
        
        if let duration = frameDuration, duration > 0 {
            return duration
        } else {
            return 0.1
        }
    }
}



