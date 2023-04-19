//
//  View+GetCommonViews.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 19/04/23.
//

import SwiftUI

extension View {
    @ViewBuilder
    func getHeader(filter:CIFilter) -> some View {
        Group {
            Text(filter.displayName ?? "")
                .font(.title)
            
            TagListView(tags: filter.filterCategories ?? [])
            
            SupportedOSVersionView(filter: filter)
        }
    }
}
