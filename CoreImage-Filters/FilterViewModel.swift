//
//  FilterViewModel.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 11/04/23.
//

import Foundation
import CoreImage

enum VectorType {
    case fourPoints(defaultValue: CGFloat, min: CGFloat, max: CGFloat)
    case fourPointsWithVector(defaultValue: CIVector, min: CGFloat, max: CGFloat)
    case cgPoint(defaultValue: CIVector)
    case offset(defaultValue: CIVector)
    case xyz
    case extent
}

class FilterViewModel: ObservableObject {
    @Published var filterName: String = "CIBokehBlur"
    @Published var filterAttributes: [String: Any] = [:]
    @Published var imageNameForInputKey: [String: String] = [:]
    @Published var vectorDict: [String: CIVector] = [:]
    @Published var inputImageDict: [String: String] = [:]

    func getInputFileName() -> String {
        imageNameForInputKey["inputImage"] ?? ""
    }

    func getFilter() -> CIFilter {
        CIFilter(name: filterName)!
    }

    func getDescription() -> String {
        var str = "guard let filter = CIFilter(name: \"\(filterName)\") else { return }\n"
        
        for inputKey in getFilter().inputKeys {
            if let imageName = inputImageDict[inputKey] {
                str += "guard let \(imageName) = UIImage(named: \"\(imageName)\") else { return }\n\n"
                str += "let \(inputKey) = CIImage(image: \(imageName))\n"
            }
            
            if let floatValue = filterAttributes[inputKey] as? CGFloat {
                str += "filter.set(\(floatValue), forKey: \"\(inputKey)\")\n"
            }
            
            if let stringValue = filterAttributes[inputKey] as? String {
                str += "filter.set(\(stringValue), forKey: \(inputKey)"
            }
            
            if let ciVector = vectorDict[inputKey] {
                str += "filter.set(\(ciVector), forKey: \(inputKey))"
            }
        }

        return str
    }

    func set(filterName: String) {
        self.filterName = filterName
    }

    func add(value: Any, key: String) {
        filterAttributes[key] = value
    }
    
    func add(imageName: String, key: String) {
        inputImageDict[key] = imageName
    }

    func modifyVector(inputKey: String, vectorType: VectorType, index: Int, value: CGFloat) {
        var valuesArr: [CGFloat] = []

        if case VectorType.fourPoints(let `default`, _, _) = vectorType {
            if let vectorDictVal = vectorDict[inputKey] {
                valuesArr = [vectorDictVal.value(at: 0), vectorDictVal.value(at: 1), vectorDictVal.value(at: 2), vectorDictVal.value(at: 3)]
            } else {
                valuesArr = [CGFloat](repeating: `default`, count: 4)
            }

            valuesArr[index] = value
            vectorDict[inputKey] = CIVector(values: valuesArr, count: 4)
        } else if case VectorType.extent = vectorType {
            if let vectorDictVal = vectorDict[inputKey] {
                valuesArr = [vectorDictVal.value(at: 0), vectorDictVal.value(at: 0), vectorDictVal.value(at: 2), vectorDictVal.value(at: 3)]
            } else {
                valuesArr = [CGFloat](repeating: 0, count: 4)
            }
            
            valuesArr[index] = value
            vectorDict[inputKey] = CIVector(cgRect: CGRect(x: valuesArr[0], y: valuesArr[1], width: valuesArr[2], height: valuesArr[3]))
        } else if case VectorType.cgPoint(let defaultValue) = vectorType {
            if let vectorDictVal = vectorDict[inputKey] {
                valuesArr = [vectorDictVal.value(at: 0), vectorDictVal.value(at: 1)]
            } else {
                valuesArr = [defaultValue.value(at: 0), defaultValue.value(at: 1)]
            }

            valuesArr[index] = value
            vectorDict[inputKey] = CIVector(cgPoint: CGPoint(x: valuesArr[0], y: valuesArr[1]))
        } else if case VectorType.offset(let defaultValue) = vectorType {
            if let vectorDictVal = vectorDict[inputKey] {
                valuesArr = [vectorDictVal.value(at: 0), vectorDictVal.value(at: 1)]
            } else {
                valuesArr = [defaultValue.value(at: 0), defaultValue.value(at: 1)]
            }

            valuesArr[index] = value
            vectorDict[inputKey] = CIVector(cgPoint: CGPoint(x: valuesArr[0], y: valuesArr[1]))
        } else if case VectorType.fourPointsWithVector(let defaultValue, _, _) = vectorType {
            if let vectorDictVal = vectorDict[inputKey] {
                valuesArr = [vectorDictVal.value(at: 0), vectorDictVal.value(at: 1), vectorDictVal.value(at: 2), vectorDictVal.value(at: 3)]
            } else {
                valuesArr = [defaultValue.value(at: 0), defaultValue.value(at: 1), defaultValue.value(at: 2), defaultValue.value(at: 3)]
            }

            valuesArr[index] = value
            vectorDict[inputKey] = CIVector(values: valuesArr, count: 4)
        }
    }

    func getCIVectorType(inputKey: String, inputParameters: [String: Any]) -> VectorType {
        if filterName == "CIColorClamp" {
            let defaultValue = inputKey == "inputMinComponents"
                ? inputParameters.getInputMinComponents()
                : 1
            
            return VectorType.fourPoints(defaultValue: defaultValue, min: 0, max: 1)
        } else if ["CIColorMatrix", "CIColorPolynomial"].contains(filterName) {
            if let defaultValues = inputParameters["CIAttributeDefault"] as? CIVector {
                return VectorType.fourPointsWithVector(defaultValue: defaultValues, min: 0, max: 1)
            }
        }

        if inputParameters.getAttributeType() == "CIAttributeTypeRectangle" {
            return VectorType.extent
        } else if inputParameters.getAttributeType() == "CIAttributeTypePosition" {
            return VectorType.cgPoint(defaultValue: inputParameters.getDefaultValueForPositionType())
        } else if inputParameters.getAttributeType() == "CIAttributeTypeOffset" {
            return VectorType.offset(defaultValue: inputParameters.getDefaultValueForPositionType())
        }

        return VectorType.xyz
    }
}
