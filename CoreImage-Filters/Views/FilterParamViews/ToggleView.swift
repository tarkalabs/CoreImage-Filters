//
//  ToggleView.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 16/04/23.
//

import SwiftUI

struct ToggleView: View {
    let filterViewModel: FilterViewModel
    let inputKey: String
    @State var value = false
    
    var body: some View {
        Toggle("", isOn: $value).labelsHidden()
            .onSubmit {
                filterViewModel.add(value: NSNumber(value: value), key: inputKey)
            }
    }
}
