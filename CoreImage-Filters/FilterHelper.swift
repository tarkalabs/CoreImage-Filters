//
//  FilterHelper.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 16/04/23.
//

import CoreImage
import AVFoundation
import AppKit

class FilterHelper {
    func readGlassMapData(path: URL) -> CVPixelBuffer? {
        let fileURL: CFURL = path as CFURL
        
        guard let source = CGImageSourceCreateWithURL(fileURL, nil) else {
            return nil
        }
        
        guard let auxDataInfo = CGImageSourceCopyAuxiliaryDataInfoAtIndex(source, 0,
                                                                          kCGImageAuxiliaryDataTypeSemanticSegmentationGlassesMatte) as? [AnyHashable : Any] else {
                                                                            return nil
        }
        
        var portraitEffectMatte: AVPortraitEffectsMatte
        
        do {
            portraitEffectMatte = try AVPortraitEffectsMatte(fromDictionaryRepresentation: auxDataInfo)
        } catch {
            print (error)
            return nil
        }
        
        return portraitEffectMatte.mattingImage
    }
    
    func readHairDataMap(path: URL) -> CVPixelBuffer? {
        let fileURL: CFURL = path as CFURL
        
        guard let source = CGImageSourceCreateWithURL(fileURL, nil) else {
            return nil
        }
        
        guard let auxDataInfo = CGImageSourceCopyAuxiliaryDataInfoAtIndex(source, 0,
                                                                          kCGImageAuxiliaryDataTypeSemanticSegmentationHairMatte) as? [AnyHashable : Any] else {
                                                                            return nil
        }
        
        var portraitEffectMatte: AVPortraitEffectsMatte
        
        do {
            portraitEffectMatte = try AVPortraitEffectsMatte(fromDictionaryRepresentation: auxDataInfo)
        } catch {
            print (error)
            return nil
        }
        
        return portraitEffectMatte.mattingImage
    }
    
    func readPortraitMatteDataMap(path: URL) -> CVPixelBuffer? {
        let fileURL: CFURL = path as CFURL
        
        guard let source = CGImageSourceCreateWithURL(fileURL, nil) else {
            return nil
        }
        
        guard let auxDataInfo = CGImageSourceCopyAuxiliaryDataInfoAtIndex(source, 0,
                                                                          kCGImageAuxiliaryDataTypePortraitEffectsMatte) as? [AnyHashable : Any] else {
                                                                            return nil
        }
        
        
        var portraitEffectMatte: AVPortraitEffectsMatte
        
        do {
            portraitEffectMatte = try AVPortraitEffectsMatte(fromDictionaryRepresentation: auxDataInfo)
        } catch {
            print (error)
            return nil
        }
        
        return portraitEffectMatte.mattingImage
    }
    
    func readDisparityDataMap(path: URL) -> CVPixelBuffer? {
        let fileURL: CFURL = path as CFURL
        
        guard let source = CGImageSourceCreateWithURL(fileURL, nil) else {
            return nil
        }
        
        guard let auxDataInfo = CGImageSourceCopyAuxiliaryDataInfoAtIndex(source, 0,
                                                                          kCGImageAuxiliaryDataTypeDisparity) as? [AnyHashable : Any] else {
                                                                            return nil
        }

        var depthData: AVDepthData
        
        do {
            depthData = try AVDepthData(fromDictionaryRepresentation: auxDataInfo)
        } catch {
            return nil
        }
        
        return depthData.depthDataMap
    }
    
    func readDepthDataMap(path: URL) -> CVPixelBuffer? {
        let fileURL: CFURL = path as CFURL

        guard let source = CGImageSourceCreateWithURL(fileURL, nil) else {
            return nil
        }

        guard let auxDataInfo = CGImageSourceCopyAuxiliaryDataInfoAtIndex(source, 0,
                                                                          kCGImageAuxiliaryDataTypeDisparity) as? [AnyHashable : Any] else {
            return nil
        }

        var depthData: AVDepthData

        do {
            depthData = try AVDepthData(fromDictionaryRepresentation: auxDataInfo)
        } catch {
            return nil
        }

        depthData = depthData.converting(
            toDepthDataType: kCVPixelFormatType_DepthFloat16
        )

        return depthData.depthDataMap
    }
        
    func getImageAsCFData(_ image: NSImage) -> CFData? {
        image.tiffRepresentation as CFData?
    }
    
    func getDepthCIImage() -> CIImage? {
        guard let url = Bundle.main.url(forResource: "ibrahim", withExtension: "jpg") else {
            return nil
        }

        guard let depthPixelBuffer = readDepthDataMap(path: url) else {
            return nil
        }

        return CIImage(cvPixelBuffer: depthPixelBuffer)
    }
    
    func getDisparityCIImage() -> CIImage? {
        guard let url = Bundle.main.url(forResource: "ibrahim", withExtension: "jpg") else {
            return nil
        }
        
        guard let depthPixelBuffer = readDisparityDataMap(path: url) else {
            return nil
        }
        
        return CIImage(cvPixelBuffer: depthPixelBuffer)
    }
        
    func getDisparityImage() -> NSImage? {
        guard let url = Bundle.main.url(forResource: "ibrahim", withExtension: "jpg") else {
            return nil
        }

        if let depthPixelBuffer = readDisparityDataMap(path: url) {
            let depthCIImage = CIImage(cvPixelBuffer: depthPixelBuffer)
            
            return depthCIImage.convertToInfiniteSizeNSImage()
        }

        return nil
    }
    
    func getPortraitMatteImage() -> NSImage? {
        guard let url = Bundle.main.url(forResource: "ibrahim", withExtension: "jpg") else {
            return nil
        }
        
        if let portraitMatteBuffer = readPortraitMatteDataMap(path: url) {
            let portraitCIImage = CIImage(cvPixelBuffer: portraitMatteBuffer)
            
            return portraitCIImage.convertToInfiniteSizeNSImage()
        }
        
        return nil
    }
    
    func showInputGlassImage() -> NSImage? {
        guard let url = Bundle.main.url(forResource: "ibrahim", withExtension: "jpg") else {
            return nil
        }
        
        if let portraitMatteBuffer = readGlassMapData(path: url) {
            let portraitCIImage = CIImage(cvPixelBuffer: portraitMatteBuffer)
            
            return portraitCIImage.convertToInfiniteSizeNSImage()
        }
        
        return nil
    }
    
    func getHairMatteImage() -> NSImage? {
        guard let url = Bundle.main.url(forResource: "ibrahim", withExtension: "jpg") else {
            return nil
        }
        
        if let portraitMatteBuffer = readHairDataMap(path: url) {
            let portraitCIImage = CIImage(cvPixelBuffer: portraitMatteBuffer)
            
            return portraitCIImage.convertToInfiniteSizeNSImage()
        }
        
        return nil
    }
}
