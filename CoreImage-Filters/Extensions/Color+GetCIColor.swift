//
//  Color+GetCIColor.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 16/04/23.
//

import SwiftUI

extension Color {
    func getCIColor() -> CIColor {
        CIColor(color: NSColor(self)) ?? CIColor()
    }
}

