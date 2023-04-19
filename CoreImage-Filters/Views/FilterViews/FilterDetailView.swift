//
//  DetailView.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 11/04/23.
//

import SwiftUI
import AVFoundation

struct FilterDetailView: View {
    @ObservedObject var filterViewModel: FilterViewModel

    var body: some View {
        let filter = filterViewModel.getFilter()
        
        Group {
            if filter.name == "CIDepthBlurEffect" {
                CIDepthDetailView(filterViewModel: filterViewModel)
            } else if filter.name == "CIDisparityToDepth" {
                CIDisparityToDepth(filterViewModel: filterViewModel)
            } else if filter.name == "CIDepthToDisparity" {
                CIDepthToDisparity(filterViewModel: filterViewModel)
            } else {
                VStack(alignment: .leading) {
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

                                                    FiltersParamsMasterView(filter: filter, filterViewModel: filterViewModel, inputKey: inputKey)
                                                }
                                            }
                                        }
                                    }.font(.title3)
                                }
                            }
                            
                            Divider()
                            
                            VStack(alignment: .center) {
                                Section(header: Text("Output").font(.title)) {
                                    getOutputImage()
                                }
                                
                                OutputCodeView(filterViewModel: filterViewModel)
                            }
                        }
                    }
                }
                .padding(.horizontal, 8)
                .scrollIndicators(.never)
            }
        }
    }
    
    @ViewBuilder
    func getOutputImage() -> some View {
        if let filteredImage = applyFitler(filter: filterViewModel.getFilter(), filterViewModel: filterViewModel) {
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
