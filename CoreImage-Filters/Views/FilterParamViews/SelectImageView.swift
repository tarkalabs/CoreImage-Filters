//
//  SelectImageView.swift
//  CoreImage-Filters
//
//  Created by Ibrahim Hassan on 11/04/23.
//

import SwiftUI

struct SelectImageView: View {
    let filterViewModel: FilterViewModel
    let inputKeyName: String
    let images = ["carMascot", "coffeecup", "monalisa", "stop", "sunflower", "sunset", "ibrahim"]

    @State private var selectedImage = "carMascot"
    
    var body: some View {
        VStack {
            Picker("Select Image", selection: $selectedImage) {
                ForEach(images, id: \.self) {
                    Text($0.capitalized)
                }
            }
            .onReceive(selectedImage.publisher.first()) { value in
                updateSelectedImage(selectedImage)
            }
            .labelsHidden()
            .pickerStyle(.segmented)

            if let image = NSImage(named: selectedImage) {
                Image(nsImage: image)
                    .resizable()
                    .clipped()
                    .frame(width: 300, height: 300)
            }
        }.onAppear {
//            updateSelectedImage(selectedImage)
        }
    }

    func updateSelectedImage(_ value: String) {
        if let ciImage = NSImage(named: selectedImage)?.ciImage() {
            filterViewModel.add(value: ciImage, key: inputKeyName)
            filterViewModel.add(imageName: selectedImage, key: inputKeyName)
        }
    }
}
