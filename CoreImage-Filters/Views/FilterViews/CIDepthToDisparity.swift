//
//  CIDepthToDisparity.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 18/04/23.
//

import SwiftUI

struct CIDepthToDisparity: View {
    @ObservedObject var filterViewModel: FilterViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            let filter = filterViewModel.getFilter()
            
            getHeader(filter: filter)
            
            Divider()
            
            VStack(alignment: .center) {
                HStack(alignment: .top) {
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
                                                            
                                                            
                                                            HStack {
                                                                GroupBox {
                                                                    VStack(alignment: .center) {
                                                                        Text("Input Image")
                                                                        
                                                                        Image(nsImage: NSImage(named: "ibrahim")!)
                                                                            .resizable()
                                                                            .aspectRatio(contentMode: .fit)
                                                                            .frame(width: 300, height: 300)
                                                                    }
                                                                }
                                                                                                                                
                                                                Divider()
                                                                
                                                                GroupBox {
                                                                    VStack(alignment: .center) {
                                                                        Text("Depth Image")
                                                                        
                                                                        Image(nsImage: getDepthImage())
                                                                            .resizable()
                                                                            .aspectRatio(contentMode: .fit)
                                                                            .frame(width: 300, height: 300)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }.frame(minWidth: 0, maxWidth: .infinity)
                                }
                            }.font(.title3)
                        }
                    }

                    Divider()

                    VStack(alignment: .center) {
                        Section(header: Text("Output").font(.title)) {
                            getOutputImage()
                        }
                        
//                        OutputCodeView(filter: $FilterViewModel.currentFilter)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
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

        guard let inputImage = FilterHelper().getDepthCIImage() else { return nil }
        
        filter.setValue(inputImage, forKey: "inputImage")

        guard let outputImage = filter.outputImage else { return nil }
                
        return outputImage.convertToNSImage()
    }
    
    func disparityImage() -> NSImage {
        if let outputImage = FilterHelper().getDisparityImage() {
            return outputImage
        }

        return NSImage.init()
    }
    
    func getDepthImage() -> NSImage {
        if let outputImage = FilterHelper().getDepthCIImage()?.convertToNSImage() {
            return outputImage
        }
        
        return NSImage.init()
    }
}
