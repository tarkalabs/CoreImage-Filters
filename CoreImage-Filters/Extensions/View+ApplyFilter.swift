//
//  View+ApplyFilter.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 19/04/23.
//

import SwiftUI

extension View {
    func applyFitler(filter: CIFilter, filterViewModel: FilterViewModel) -> NSImage? {
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
}
