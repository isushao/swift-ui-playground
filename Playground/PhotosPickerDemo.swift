//
//  PhotosPickerDemo.swift
//  Playground
//
//  Created by roc on 2024/7/24.
//

import SwiftUI
import PhotosUI

struct PhotosPickerDemo: View {
    @State private var selectedImages: [Image] = []
    @State private var selectedItems: [PhotosPickerItem] = []
    var body: some View {
        
        if selectedImages.isEmpty {
            ContentUnavailableView("No Photos", systemImage: "photo.on.rectangle", description: Text("To get started, select some photos below"))
                .frame(height: 300)
        } else {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(0..<selectedImages.count, id: \.self) { index in
                        selectedImages[index]
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            .padding(.horizontal, 20)
                            .containerRelativeFrame(.horizontal)
                            .scrollTransition(.animated, axis: .horizontal) { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1.0 : 0.8)
                                    .scaleEffect(phase.isIdentity ? 1.0 : 0.8)
                            }
                    }
                    
                }
            }
            .frame(height: 300)
        }
        
        PhotosPicker(selection: $selectedItems,
                     maxSelectionCount: 5,
                     selectionBehavior: .continuousAndOrdered,
                     matching: .images) {
            Label("Select a photo", systemImage: "photo")
        }
//                     .photosPickerStyle(.inline)
            .ignoresSafeArea()
            .photosPickerAccessoryVisibility(.hidden,edges: .bottom)
            .onChange(of: selectedItems) { oldItems, newItems in
            selectedImages.removeAll()
            newItems.forEach { newItem in
                Task {
                    if let image = try? await newItem.loadTransferable(type: Image.self) {
                        selectedImages.append(image)
                    }
                }
            }
        }
    }
}

#Preview {
    PhotosPickerDemo()
}
