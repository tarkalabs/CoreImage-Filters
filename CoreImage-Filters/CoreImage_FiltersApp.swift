//
//  CoreImage_FiltersApp.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 07/04/23.
//

import SwiftUI

enum WindowSize {
    static let min = CGSize(width: 1000, height: 400)
}

@main
struct CoreImage_FiltersApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: WindowSize.min.width, minHeight: WindowSize.min.height)
        }.commands {
            SidebarCommands() // 1
        }
    }
}
