//
//  AttributedTextImageGenerator.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 16/04/23.
//

import SwiftUI

enum TextInputType {
    case string
    case attributedString
    case data
    
    init(attributeClass: String) {
        if attributeClass == "NSString" {
            self = .string
        } else if attributeClass == "NSAttributedString" {
            self = .attributedString
        } else if attributeClass == "NSData" {
            self = .data
        } else {
            self = .string
        }
    }
}

struct TextView: View {
    let filterViewModel: FilterViewModel
    let inputKey: String
    @State private var text = "Enter text here"
    let attributeClass: String

    var body: some View {
        let textInputType = TextInputType(attributeClass: attributeClass)
        
        Group {
            if inputKey == "inputFontName" {
                Menu {
                    ForEach(NSFontManager.shared.availableFonts, id: \.self) { font in
                        Button(font) {
                            text = font
                            updateFilterViewModel(textInputType)
                        }
                    }
                } label: {
                    Text("Select Font").fontWeight(.bold)
                }
            } else {
                TextEditor(text: $text).onChange(of: text) { newValue in
                    updateFilterViewModel(textInputType)
                }.frame(height: 50)
            }
        }.onAppear {
            updateFilterViewModel(textInputType)
        }
    }
    
    func updateFilterViewModel(_ textInputType: TextInputType) {
        switch textInputType {
            case .string:
                filterViewModel.add(value: text, key: inputKey)
            case .attributedString:
                filterViewModel.add(value: NSAttributedString(string: text), key: inputKey)
            case .data:
                filterViewModel.add(value: Data(text.utf8), key: inputKey)
        }
    }
}
