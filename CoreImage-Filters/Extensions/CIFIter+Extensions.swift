//
//  CIFIter+Extensions.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 11/04/23.
//

import CoreImage

extension CIFilter {
    var displayName: String? {
        self.attributes["CIAttributeFilterDisplayName"] as? String
    }
    
    var filterCategories: [String]? {
        self.attributes["CIAttributeFilterCategories"] as? [String]
    }
}
