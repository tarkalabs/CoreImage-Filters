//
//  ContentView.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 07/04/23.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    var body: some View {
        let filterViewModel = FilterViewModel()
        
        NavigationView {
            MasterView(filterViewModel: filterViewModel).frame(minWidth: 150)
            FilterDetailView(filterViewModel: filterViewModel)
        }
        .navigationTitle("Core Image Filters")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar, label: { // 1
                    Image(systemName: "sidebar.leading")
                })
            }
        }
    }
    
    private func toggleSidebar() { // 2
        #if os(macOS)
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        #endif
    }
}
