//
//  ColorPickerView.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 16/04/23.
//

import SwiftUI

struct ColorPickerView: View {
    let filterViewModel: FilterViewModel
    let inputKey: String
    
    @State private var bgColor = Color.red

    var body: some View {
        ColorPicker("", selection: $bgColor)
            .labelsHidden()
            .onChange(of: self.bgColor) { newValue in
                filterViewModel.add(value: bgColor.getCIColor(), key: inputKey)
            }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(bgColor)
    }
}
