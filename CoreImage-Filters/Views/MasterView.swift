//
//  MasterView.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 11/04/23.
//

import SwiftUI
import CoreImage

struct MasterView: View {
    @ObservedObject var filterViewModel: FilterViewModel
    
    @AppStorage("unsupportedFilters") var unsupportedFilter: String = ""

    let filterCategories = [
        "CICategoryBlur", "CICategoryColorAdjustment", "CICategoryCompositeOperation",
        "CICategoryDistortionEffect", "CICategoryGenerator","CICategoryGeometryAdjustment",
        "CICategoryGradient", "CICategoryHalftoneEffect", "CICategoryReduction",
        "CICategorySharpen", "CICategoryStylize","CICategoryTileEffect",
        "CICategoryTransition"
    ]

    var body: some View {
        List {
            ForEach(filterCategories, id: \.self) {filterCategory in
                Section(header: Text(filterCategory).font(.largeTitle)) {
                    ForEach(CIFilter.filterNames(inCategories: [filterCategory]), id: \.self) { filterName in
                        HStack {
                            let text = Text(filterName).onTapGesture {
                                filterViewModel.set(filterName: filterName)
                            }

                            if filterName == filterViewModel.filterName {
                                text.padding(.horizontal).background {
                                    Capsule().fill(Color(nsColor: NSColor.lightGray))
                                }
                            } else {
                                text
                            }
                        }
                    }.font(.title3)
                }
            }
        }.onAppear {
            print (CIFilter(name: "CIConvolution3X3")?.attributes ?? [:])
        }
    }
}
