//
//  CIDepthBlurSample.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 12/04/23.
//

import CoreImage
import SwiftUI
import AVFoundation

class MeraLifeSaverHelper {
    /*
     {
         guard let imageData = photo.fileDataRepresentation(),
               let mainImage = CIImage(data: imageData),
               
               // Get the depth map
               let disparityImage = CIImage(data: imageData, options: [.auxiliaryDisparity: true]),
               
               // Merge 2 image: original image and depth map
               let filter = CIFilter(name: "CIDepthBlurEffect",
                                     parameters: [kCIInputImageKey : mainImage,
                                         kCIInputDisparityImageKey : disparityImage]),
               
               // Got the image which has blur effect like PORTRAIT native camera
               let outputImage = filter.outputImage else { return }
         
         let resultImage = UIImage(ciImage: outputImage.oriented(.right))
         captureImageView.image = resultImage
         
         // Get latest capture image
         blurringImage = resultImage
         originalImage = UIImage(data: photo.fileDataRepresentation()!)
     }
     */
    
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
        
        if depthData.depthDataType != kCVPixelFormatType_DisparityFloat32 {
            depthData = depthData.converting(toDepthDataType: kCVPixelFormatType_DisparityFloat32)
        }
        
        return depthData.depthDataMap
    }
        
    func getImageAsCFData(_ image: NSImage) -> CFData? {
        image.tiffRepresentation as CFData?
    }
        
    func getDisparityImage() -> NSImage? {
        guard let url = Bundle.main.url(forResource: "IMG_1889", withExtension: "jpg") else {
            return nil
        }

        if let depthPixelBuffer = readDisparityDataMap(path: url) {
            let depthCIImage = CIImage(cvPixelBuffer: depthPixelBuffer)
            
            return depthCIImage.convertToNSImage()
        }

        return nil
    }
    
    func getPortraitMatteImage() -> NSImage? {
        guard let url = Bundle.main.url(forResource: "IMG_1889", withExtension: "jpg") else {
            return nil
        }
        
        if let portraitMatteBuffer = readPortraitMatteDataMap(path: url) {
            let portraitCIImage = CIImage(cvPixelBuffer: portraitMatteBuffer)
            
            return portraitCIImage.convertToNSImage()
        }
        
        return nil
    }
    
    func showInputGlassImage() -> NSImage? {
        guard let url = Bundle.main.url(forResource: "IMG_1889", withExtension: "jpg") else {
            return nil
        }
        
        if let portraitMatteBuffer = readGlassMapData(path: url) {
            let portraitCIImage = CIImage(cvPixelBuffer: portraitMatteBuffer)
            
            return portraitCIImage.convertToNSImage()
        }
        
        return nil
    }
    
    func getHairMatteImage() -> NSImage? {
        guard let url = Bundle.main.url(forResource: "IMG_1889", withExtension: "jpg") else {
            return nil
        }
        
        if let portraitMatteBuffer = readHairDataMap(path: url) {
            let portraitCIImage = CIImage(cvPixelBuffer: portraitMatteBuffer)
            
            return portraitCIImage.convertToNSImage()
        }
        
        return nil
    }
}

struct CIDepthDetailView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                let filter = viewModel.getFilter()
                
                Text(filter.displayName ?? "")
                    .font(.title)
                
                TagListView(tags: filter.filterCategories ?? [])
                
                VStack(alignment: .trailing) {
                    HStack {
                        Spacer()
                        
                        Text("iOS \(filter.attributes.getMiniOSVersion())+")
                            .fontWeight(.semibold)
                            .padding(6)
                            .background {
                                RoundedRectangle(
                                    cornerSize: CGSize(width: 8, height: 8)
                                ).fill(
                                    Color(nsColor: NSColor(red: 129 / 255.0, green: 172 / 255.0, blue: 219 / 255.0, alpha: 1.0))
                                )
                            }
                        
                        Text("OSX \(filter.attributes.getMinMacOSVersion())+")
                            .fontWeight(.semibold)
                            .padding(6)
                            .background {
                                RoundedRectangle(
                                    cornerSize: CGSize(width: 8, height: 8)
                                ).fill(
                                    Color(nsColor: NSColor(red: 240 / 255.0, green: 147 / 255.0, blue: 144 / 255.0, alpha: 1.0))
                                )
                            }
                    }
                }
                
                Divider()
                
                VStack(alignment: .center) {
                    HStack {
                        VStack(alignment: .leading) {
                            Section(header: Text("Parameters for \(filter.displayName ?? "")").font(.title)) {
                                ForEach(filter.inputKeys, id: \.self) { inputKey in
                                    GroupBox {
                                        VStack(alignment: .leading) {
                                            Text(inputKey)
                                                .underline()
                                            
                                            if let inputParameters = filter.attributes[inputKey] as? [String: Any] {
                                                Text(inputParameters.getAttributeDescription())
                                                    .padding(.vertical, 2)
                                                
                                                if let attributeClass = inputParameters["CIAttributeClass"] as? String {
                                                    if attributeClass == "CIImage" {
                                                        if inputKey == "inputImage" {
                                                            if let image = NSImage(named: "IMG_1889") {
                                                                Image(nsImage: image)
                                                                    .resizable()
                                                                    .aspectRatio(contentMode: .fit)
                                                                    .frame(width: 500, height: 500)
                                                            }
                                                        } else if inputKey == "inputDisparityImage" {
                                                            Image(nsImage: showDepthImageView())
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: 500, height: 500)
                                                        } else if inputKey == "inputMatteImage" {
                                                            Image(nsImage: showInputMatteImage())
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: 500, height: 500)
                                                        } else if inputKey == "inputHairImage" {
                                                            Image(nsImage: showInputHairImage())
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: 500, height: 500)

                                                        } else if inputKey == "inputGlassesImage" {
                                                            Image(nsImage: showInputHairImage())
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: 500, height: 500)

                                                        }
                                                    } else if attributeClass == "NSNumber" {
                                                        let filterRange = inputParameters.getMinMaxSliderAndDefaultValue()
                                                        
                                                        SliderView(viewModel: viewModel, filterRange: filterRange, inputKey:inputKey, value: filterRange.default)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }.font(.title3)
                        }
                        
                        Divider()
                        
                        VStack {
                            Section(header: Text("Output").font(.title)) {
                                //                                outputImage
                            }
                            
                            Text("TODO: Add generated code")
                        }
                    }
                }
            }
        }
    }
    
    func showInputGlassesImage() -> NSImage {
        if let outputImage = MeraLifeSaverHelper().getHairMatteImage() {
            print ("***")
            print(NSImage(named: "IMG_1889"))
            print (outputImage)
            print ("***")
            return outputImage
        }
        
        return NSImage.init()

    }
    
    func showInputHairImage() -> NSImage {
        if let outputImage = MeraLifeSaverHelper().getHairMatteImage() {
            print ("***")
            print(NSImage(named: "IMG_1889"))
            print (outputImage)
            print ("***")
            return outputImage
        }
        
        return NSImage.init()
    }
    
    func showInputMatteImage() -> NSImage {
        if let outputImage = MeraLifeSaverHelper().getPortraitMatteImage() {
            print ("***")
            print(NSImage(named: "IMG_1889"))
            print (outputImage)
            print ("***")
            return outputImage
        }
        
        return NSImage.init()
    }
    
    func showDepthImageView() -> NSImage {
        if let outputImage = MeraLifeSaverHelper().getDisparityImage() {
            print ("***")
            print(NSImage(named: "IMG_1889"))
            print (outputImage)
            print ("***")
            return outputImage
        }

        return NSImage.init()
    }
}
