//
//  TagListView.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 11/04/23.
//

import SwiftUI

struct TagListView: View {
    var tags: [String] = []
    
    var body: some View {
        HStack {
            ForEach(tags, id:\.self) { tag in
                Text(tag)
                    .padding(.horizontal, 4)
                    .padding(2)
                    .background {
                        Color.secondary
                            .blur(radius: 8, opaque: false)
                    }.cornerRadius(4)
            }
        }
    }
}
