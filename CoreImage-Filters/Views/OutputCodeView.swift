//
//  OutputCodeView.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 18/04/23.
//

import CodeEditor
import SwiftUI

struct OutputCodeView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var filterViewModel: FilterViewModel

    var body: some View {
        VStack(alignment: .trailing) {
            Button {
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(filterViewModel.getDescription(), forType: .string)
            } label: {
                Image(systemName: "doc.on.doc.fill")
                    .font(.title)
            }
            .buttonStyle(.borderless)
            .padding(.horizontal)
            
            CodeEditor(
                source: filterViewModel.getDescription(),
                language: .swift,
                theme: colorScheme == .dark ? CodeEditor.ThemeName.atelierSavannaDark : CodeEditor.ThemeName.atelierSavannaLight,
                flags: [ .selectable, .smartIndent],
                inset: CGSize(width: 5, height: 5)
            ).frame(width: 640, height: 320)
        }
    }
}
