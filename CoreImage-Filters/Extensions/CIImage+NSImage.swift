//
//  CIImage+NSImage.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 12/04/23.
//

import CoreImage
import AppKit.NSImage

extension CIImage {    
    private func renderForSmallerImages() -> NSImage? {
        if extent.width == 1 || extent.height == 1 {
            if let stretchOut = CIFilter(name: "CIStretchCrop",
                                   parameters: ["inputSize": CIVector(x: 640, y: 640),
                    "inputCropAmount": 0,
                    "inputCenterStretchAmount": 1,
                                                kCIInputImageKey: self])?.outputImage {
                let context = CIContext()
                
                if let val = context.createCGImage(stretchOut, from: CGRect(x: 0, y: 0, width: 640, height: 640)) {
                    let img = NSImage(cgImage: val, size: NSSize(width: 640, height: 640))
                    return img
                }
            }
        }
        
        return nil
    }
    
    func convertToInfiniteSizeNSImage() -> NSImage {
        let rep = NSCIImageRep(ciImage: self)
        
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        
        return nsImage
    }
    
    func convertToNSImage() -> NSImage {
        guard let renderForSmallerImage = renderForSmallerImages() else {
            let context = CIContext()
            
            if let val = context.createCGImage(self, from: CGRect(x: 0, y: 0, width: 640, height: 640)) {
                let img = NSImage(cgImage: val, size: NSSize(width: 640, height: 640))
                return img
            } else {
                return NSImage()
            }
        }
        
        return renderForSmallerImage
    }
}

