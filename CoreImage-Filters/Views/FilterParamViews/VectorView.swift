//
//  VectorView.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 14/04/23.
//

import SwiftUI
import CoreImage

struct VectorView: View {
    let vectorType: VectorType
    var filterViewModel: FilterViewModel
    let inputKey: String
    
    var body: some View {
        if case VectorType.fourPoints(let defaultValue, let min, let max) = vectorType {
            HStack {
                ForEach(0..<4) { index in
                    SliderView(
                        filterViewModel: filterViewModel,
                        filterRange: FilterRange(default: defaultValue, min: min, max: max),
                        inputKey: inputKey,
                        vectorType: vectorType,
                        vectorIndex: index,
                        value: defaultValue
                    )
                }
            }
        } else if case VectorType.extent = vectorType {
            ExtentsInputView(vectorType: vectorType, filterViewModel: filterViewModel, inputKey: inputKey)
        } else if case VectorType.cgPoint(let defaultValue) = vectorType {
            HStack {
                ForEach(0..<2) { index in
                    SliderView(
                        filterViewModel: filterViewModel,
                        filterRange: FilterRange(default: defaultValue.value(at: index), min: 0, max: 640),
                        inputKey: inputKey,
                        vectorType: vectorType,
                        vectorIndex: index,
                        value: defaultValue.value(at: index)
                    )
                }
            }
        } else if case VectorType.offset(let defaultValue) = vectorType {
            HStack {
                ForEach(0..<2) { index in
                    let minMaxValues = getMinMax()

                    SliderView(
                        filterViewModel: filterViewModel,
                        filterRange: FilterRange(default: defaultValue.value(at: index), min: minMaxValues.min, max: minMaxValues.max),
                        inputKey: inputKey,
                        vectorType: vectorType,
                        vectorIndex: index,
                        value: defaultValue.value(at: index)
                    )
                }
            }
        } else if case VectorType.fourPointsWithVector(let defaultValue, let min, let max) = vectorType {
            HStack {
                ForEach(0 ..< 4) { index in
                    let currentValue = defaultValue.value(at: index)

                    SliderView(
                        filterViewModel: filterViewModel,
                        filterRange: FilterRange(default: currentValue, min: min, max: max),
                        inputKey: inputKey,
                        vectorType: vectorType,
                        vectorIndex: index,
                        value: currentValue
                    )
                }
            }
        } else {
            EmptyView()
        }
    }
    
    func getMinMax() -> (min: CGFloat, max: CGFloat) {
        var min: CGFloat = -640
        var max: CGFloat = 640
        
        if filterViewModel.filterName == "CIToneCurve" {
            if inputKey == "inputPoint4" {
                min = 0
                max = 640
            } else {
                min = 0
                max = 1
            }
        }

        return (min: min, max: max)
    }
}
