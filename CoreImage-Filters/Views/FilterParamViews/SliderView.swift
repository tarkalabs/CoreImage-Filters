//
//  SliderView.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 11/04/23.
//

import SwiftUI

struct SliderView: View {
    let filterViewModel: FilterViewModel
    let filterRange: FilterRange
    var inputKey: String
    
    var vectorType: VectorType?
    var vectorIndex: Int?
    
    @State var value: CGFloat
    
    var body: some View {
        VStack {
            Text("\(value)")
            
            Slider(value: $value, in: filterRange.min ... filterRange.max)
                .onChange(of: self.value) { newValue in
                    if let vectorType {
                        filterViewModel.modifyVector(inputKey: inputKey, vectorType: vectorType, index: vectorIndex ?? 0, value: value)
                    } else {
                        filterViewModel.add(value: newValue, key: inputKey)
                    }
                }
                .onAppear {
                    if let vectorType {
                        filterViewModel.modifyVector(inputKey: inputKey, vectorType: vectorType, index: vectorIndex ?? 0, value: value)
                    } else {
                        filterViewModel.add(value: value, key: inputKey)
                    }
                }
        }
    }
}
