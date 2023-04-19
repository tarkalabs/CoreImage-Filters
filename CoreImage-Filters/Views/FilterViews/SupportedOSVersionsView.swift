//
//  SupportedOSVersionsView.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 16/04/23.
//

import SwiftUI

struct SupportedOSVersionView: View {
    let filter: CIFilter
    
    var body: some View {
        VStack(alignment: .trailing) {
            HStack {
                Spacer()
                
                Text("iOS \(filter.attributes.getMiniOSVersion())+")
                    .fontWeight(.semibold)
                    .padding(6)
                    .background {
                        RoundedRectangle(
                            cornerSize: CGSize(width: 8, height: 8)
                        ).fill(
                            Color(nsColor: NSColor(red: 129 / 255.0, green: 172 / 255.0, blue: 219 / 255.0, alpha: 1.0))
                        )
                    }
                
                Text("OSX \(filter.attributes.getMinMacOSVersion())+")
                    .fontWeight(.semibold)
                    .padding(6)
                    .background {
                        RoundedRectangle(
                            cornerSize: CGSize(width: 8, height: 8)
                        ).fill(
                            Color(nsColor: NSColor(red: 240 / 255.0, green: 147 / 255.0, blue: 144 / 255.0, alpha: 1.0))
                        )
                    }
            }
        }
    }
}
