//
//  ZoomTransitionDemo.swift
//  Playground
//
//  Created by roc on 2024/7/25.
//

import SwiftUI

struct ZoomableViewModifier: ViewModifier {
    @State private var translation: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var doubleTapScale: CGFloat = 1.0
    
    func body(content: Content) -> some View {
        content
            .offset(translation)
            .scaleEffect(scale * doubleTapScale)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        translation = value.translation
                    }
                    .onEnded { value in
                        if abs(value.translation.height) > 100 || abs(value.translation.width) > 100 {
                            withAnimation(.spring()) {
                                translation = .zero
                                scale = 1.0
                                doubleTapScale = 1.0
                            }
                        } else {
                            withAnimation(.spring()) {
                                translation = .zero
                            }
                        }
                    }
            )
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        scale = value
                    }
                    .onEnded { value in
                        withAnimation {
                            scale = 1.0
                        }
                    }
            )
            .onTapGesture(count: 2) {
                withAnimation {
                    doubleTapScale = doubleTapScale == 1.0 ? 2.0 : 1.0
                }
            }
    }
}

extension View {
    func zoomable() -> some View {
        self.modifier(ZoomableViewModifier())
    }
}

struct ZoomTransitionDemo: View {
    let samplePhotos = (1...6).map { Photo(name: "\($0)") }
    
    @Namespace private var namespace
    @State private var selectedPhoto: Photo? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                    ForEach(samplePhotos) { photo in
                        Image(photo.name)
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 150)
                            .cornerRadius(30.0)
                            .matchedGeometryEffect(id: photo.id, in: namespace)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    selectedPhoto = photo
                                }
                            }
                    }
                }
            }
            .padding()
            .overlay(
                Group {
                    if let selectedPhoto = selectedPhoto {
                        ZStack(alignment: .topTrailing) {
                            Color.black.opacity(0.5)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        self.selectedPhoto = nil
                                    }
                                }
                            
                            Image(selectedPhoto.name)
                                .resizable()
                                .scaledToFit()
                                .matchedGeometryEffect(id: selectedPhoto.id, in: namespace)
                                .zoomable()
                                .padding()
                                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                        }
                    }
                }
            )
        }
    }
}

struct Photo: Identifiable {
    let id = UUID()
    let name: String
}

#Preview {
    ZoomTransitionDemo()
}
