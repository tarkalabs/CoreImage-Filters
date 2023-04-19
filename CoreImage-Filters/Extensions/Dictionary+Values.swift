//
//  Dictionary+GetFilterMinMaxValues.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 11/04/23.
//

import Foundation
import CoreImage

extension Dictionary where Key == String, Value == Any {
    func getMinMaxSliderAndDefaultValue() -> FilterRange {
        var defaultValueString = ""
        var maxStepValueString = ""
        var minStepValueString = ""
        var minValueString = ""

        if let defaultValue = self["CIAttributeDefault"] {
            defaultValueString = "\(defaultValue)"
        }
        
        if let maxStepValue = self["CIAttributeSliderMax"] {
            maxStepValueString = "\(maxStepValue)"
        }
        
        if let minStepValue = self["CIAttributeSliderMin"] {
            minStepValueString = "\(minStepValue)"
        }
        
        if let minValue = self["CIAttributeMin"] {
            minValueString = "\(minValue)"
        }
                
        let `default` = CGFloat(truncating: NumberFormatter().number(from: defaultValueString) ?? 0)
        let min = CGFloat(truncating: NumberFormatter().number(from: minValueString) ?? 0)
        let minStep = CGFloat(truncating: NumberFormatter().number(from: minStepValueString) ?? 0)
        let max = CGFloat(truncating: NumberFormatter().number(from: maxStepValueString) ?? 640)

        return FilterRange(
            default: `default`,
            min: CGFloat.minimum(min, minStep),
            max: CGFloat.maximum(max, `default`)
        )
    }
}

extension Dictionary where Key == String, Value == Any {
    func getMiniOSVersion() -> String {
        self["CIAttributeFilterAvailable_iOS"] as? String ?? ""
    }
    
    func getMinMacOSVersion() -> String {
        self["CIAttributeFilterAvailable_Mac"] as? String ?? ""
    }
}

extension Dictionary where Key == String, Value == Any {
    func getAttributeDescription() -> String {
        self["CIAttributeDescription"] as? String ?? ""
    }
}

extension Dictionary where Key == String, Value == Any {
    func getInputMinComponents() -> CGFloat {
        self["inputMinComponents"] as? CGFloat ?? 0
    }
    
    func getAttributeType() -> String {
        self["CIAttributeType"] as? String ?? ""
    }
    
    func getDefaultValueForPositionType() -> CIVector {
        self["CIAttributeDefault"] as? CIVector ?? CIVector(cgPoint: CGPoint())
    }
}
