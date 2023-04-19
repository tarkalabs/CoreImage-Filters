//
//  QRCodeInputCorrectionLevelView.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 19/04/23.
//

import SwiftUI

struct QRCodeInputCorrectionLevelView: View {
    @ObservedObject var filterViewModel: FilterViewModel
    @State private var selectedCorrectionLevel: String?
    
    let inputKey: String
    
    var body: some View {
        Text("This defines the error correction capability which can restore data if a code is dirty or damaged but at the expense of an increased amount of data required in the code. L: 7% | M: 15% | Q: 25% | H: 30%")
        
        Menu {
            ForEach(["L", "M", "Q", "H"], id: \.self) { correctionLevel in
                Button(correctionLevel) {
                    selectedCorrectionLevel = correctionLevel
                    filterViewModel.add(value: correctionLevel, key: inputKey)
                }
            }
        } label: {
            Text(selectedCorrectionLevel == nil ? "Select Correct Level": selectedCorrectionLevel!)
                .fontWeight(.bold)
        }
    }
}
