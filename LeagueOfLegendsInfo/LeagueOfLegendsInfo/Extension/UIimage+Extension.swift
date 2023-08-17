//
//  UIimage+Extension.swift
//  LeagueOfLegendsInfo
//
//  Created by MaraMincho on 2023/08/16.
//

import UIKit
import CoreGraphics
import CoreImage

extension UIImage {
    func adjustedBrightness(_ value: CGFloat) -> UIImage {
        
        guard let ciImage = CIImage(image: self),
              let filter = CIFilter(name: "CIColorControls") else {
            return self
        }
        
        //kCIInputImageKey를 통해 image를 filter에 각인
        //kciInputBrightnessKey를 통해 value값을 조정
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(value, forKey: kCIInputBrightnessKey)
        
        let context = CIContext()
        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return self
        }
        
        return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
    }
    
    func applyGausianBlur(radius: CGFloat) -> UIImage {
        
        let context = CIContext()
        guard let ciImage = CIImage(image: self),
              let clampFilter = CIFilter(name: "CIAffineClamp"),
              let blurFilter = CIFilter(name: "CIGaussianBlur") else {
            return self
        }
        clampFilter.setValue(ciImage, forKey: kCIInputImageKey)
        
        //필터끼리는 벨류를 받을 수 있음
        blurFilter.setValue(clampFilter.outputImage, forKey: kCIInputImageKey)
        blurFilter.setValue(radius, forKey: kCIInputRadiusKey)
        guard let output = blurFilter.outputImage,
              let cgImage = context.createCGImage(output, from: ciImage.extent) else {
            return self
        }
        
        return UIImage(cgImage: cgImage).resize(newSize: self.size)
    }
    
    func resize(newSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: newSize).image { context in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
