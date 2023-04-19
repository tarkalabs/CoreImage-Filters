//
//  FilterParamsMasterView.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 19/04/23.
//

import SwiftUI

struct FiltersParamsMasterView: View {
    let filter: CIFilter
    @ObservedObject var filterViewModel: FilterViewModel
    let inputKey: String
    
    var body: some View {
        let inputParameters = filter.attributes[inputKey] as? [String: Any] ?? [:]

        Text(inputParameters.getAttributeDescription())
            .padding(.vertical, 2)

        if let attributeClass = inputParameters["CIAttributeClass"] as? String {
            switch attributeClass {
            case "CIImage":
                SelectImageView(filterViewModel: filterViewModel, inputKeyName: inputKey)
            case "NSNumber":
                if inputParameters.getAttributeType() == "CIAttributeTypeBoolean" {
                    ToggleView(filterViewModel: filterViewModel, inputKey: inputKey)
                } else {
                    let filterRange = inputParameters.getMinMaxSliderAndDefaultValue()
                    
                    SliderView(filterViewModel: filterViewModel, filterRange: filterRange, inputKey:inputKey, value: filterRange.default)
                }
            case "CIVector":
                let civectorType = filterViewModel.getCIVectorType(inputKey: inputKey, inputParameters: inputParameters)
                
                VectorView(vectorType: civectorType, filterViewModel: filterViewModel, inputKey: inputKey)
            case "CIColor":
                ColorPickerView(filterViewModel: filterViewModel, inputKey: inputKey)
            case "NSAttributedString", "NSData", "NSString":
                if filter.name == "CIQRCodeGenerator" && inputKey == "inputCorrectionLevel" {
                    QRCodeInputCorrectionLevelView(filterViewModel: filterViewModel, inputKey: inputKey)
                } else {
                    TextView(filterViewModel: filterViewModel, inputKey: inputKey, attributeClass: attributeClass)
                }
            case "NSAffineTransform":
                AffineTransformView(filterViewModel: filterViewModel, inputKey: inputKey)
            default:
                EmptyView()
            }
        }
    }
}
