//
//  ZoomTransitionDemo.swift
//  Playground
//
//  Created by roc on 2024/7/25.
//

import SwiftUI

struct ZoomTransitionDemo: View {
    let samplePhotos = (1...6).map { Photo(id:$0 ,name: "\($0)") }
    
    @Namespace private var namespace
    @State private var selectedPhoto: Photo? = nil
    @State private var translation: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var doubleTapScale: CGFloat = 1.0
    @State private var backgroundOpacity: Double = 1 // 初始背景透明度

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
                                    translation = .zero  // Reset translation to zero when a new photo is selected
                                    scale = 1.0          // Reset scale to 1.0 when a new photo is selected
                                    doubleTapScale = 1.0 // Reset double tap scale to 1.0 when a new photo is selected
                                    backgroundOpacity = 1 // Reset background opacity when a new photo is selected
                                }
                            }
                    }
                }
            }
            .padding()
            .overlay(
                Group {
                    if let selectedPhoto = selectedPhoto {
                        ZStack(alignment: .center) {
                            Color.black
                                .opacity(backgroundOpacity) // 设置背景透明度
                                .edgesIgnoringSafeArea(.all)
                              

                            Image(selectedPhoto.name)
                                .resizable()
                                .scaledToFit()
                                .matchedGeometryEffect(id: selectedPhoto.id, in: namespace)
                                .offset(translation)
                                .scaleEffect(scale * doubleTapScale)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            translation = value.translation
                                            let distance = sqrt(pow(value.translation.width, 2) + pow(value.translation.height, 2))
                                            backgroundOpacity = max(0,1 - Double(distance) / 200)
                                        }
                                        .onEnded { value in
                                            if abs(value.translation.height) > 100 || abs(value.translation.width) > 100 {
                                                withAnimation(.spring()) {
                                                    self.selectedPhoto = nil
                                                }
                                            } else {
                                                withAnimation(.spring()) {
                                                    translation = .zero
                                                    backgroundOpacity = 1
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
                                .padding()
                        }
                    }
                }
            )
        }
    }
}

struct Photo: Identifiable {
    let id : Int
    let name: String
}

#Preview {
    ZoomTransitionDemo()
}
