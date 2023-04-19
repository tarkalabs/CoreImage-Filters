//
//  CIDepthBlurSample.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 12/04/23.
//

import CoreImage
import SwiftUI
import AVFoundation

struct CIDepthDetailView: View {
    @ObservedObject var filterViewModel: FilterViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            let filter = filterViewModel.getFilter()
            
            Text(filter.displayName ?? "")
                .font(.title)
            
            TagListView(tags: filter.filterCategories ?? [])
            
            SupportedOSVersionView(filter: filter)
            
            Divider()
            
            VStack(alignment: .center) {
                HStack {
                    ScrollView(showsIndicators: false) {
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
                                                            if let image = NSImage(named: "ibrahim") {
                                                                Image(nsImage: image)
                                                                    .resizable()
                                                                    .aspectRatio(contentMode: .fit)
                                                                    .frame(width: 500, height: 500)
                                                            }
                                                        } else if inputKey == "inputDisparityImage" {
                                                            Image(nsImage: showDisparityImage())
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
                                                        
                                                        SliderView(filterViewModel: filterViewModel, filterRange: filterRange, inputKey:inputKey, value: filterRange.default)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }.font(.title3)
                        }
                    }
                    
                    Divider()
                    
                    VStack {
                        Section(header: Text("Output").font(.title)) {
                            getOutputImage()
                        }
                        
                        OutputCodeView(filterViewModel: filterViewModel)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func getOutputImage() -> some View {
        Group {
            if let filteredImage = applyFitler() {
                Image(nsImage: filteredImage)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            } else {
                EmptyView()
            }
        }
    }
    
    func applyFitler() -> NSImage? {
        let filter = filterViewModel.getFilter()
        
        for (key, value) in filterViewModel.filterAttributes {
            if filter.inputKeys.contains(key) {
                filter.setValue(value, forKey: key)
            }
        }
        
        for (key, value) in filterViewModel.vectorDict {
            if filter.inputKeys.contains(key) {
                filter.setValue(value, forKey: key)
            }
        }

        guard let outputImage = filter.outputImage else { return nil }
        
        let infiniteResolutionFilters = [
            "CISaliencyMapFilter", "CIHistogramDisplayFilter", "CITextImageGenerator",
            "CIRoundedRectangleGenerator", "CIQRCodeGenerator", "CIPDF417BarcodeGenerator",
            "CICode128BarcodeGenerator", "CIAztecCodeGenerator", "CIAttributedTextImageGenerator"
        ]
        
        if infiniteResolutionFilters.contains(filterViewModel.filterName) {
            return outputImage.convertToInfiniteSizeNSImage()
        } else {
            return outputImage.convertToNSImage()
        }
    }
    
    func showInputGlassesImage() -> NSImage {
        FilterHelper().getHairMatteImage() ?? NSImage()
    }
    
    func showInputHairImage() -> NSImage {
        FilterHelper().getHairMatteImage() ?? NSImage()
    }
    
    func showInputMatteImage() -> NSImage {
        FilterHelper().getPortraitMatteImage() ?? NSImage()
    }
    
    func showDisparityImage() -> NSImage {
        FilterHelper().getDisparityImage() ?? NSImage()
    }
}

