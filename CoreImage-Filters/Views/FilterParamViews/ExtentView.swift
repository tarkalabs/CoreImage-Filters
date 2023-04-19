//
//  ExtentView.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 16/04/23.
//

import SwiftUI

struct ExtentsInputView: View {
    let vectorType: VectorType
    var filterViewModel: FilterViewModel
    let inputKey: String

    var body: some View {
        let inputHints: [String] = ["x", "y", "width", "height"]
        
        HStack {
            ForEach(0..<4) { index in
                VStack {
                    Text(inputHints[index])
                    
                    SliderView(
                        filterViewModel: filterViewModel,
                        filterRange: FilterRange(default: 0, min: 0, max: 640),
                        inputKey: inputKey,
                        vectorType: vectorType,
                        vectorIndex: index,
                        value: 0
                    )
                }
            }
        }
    }
}
