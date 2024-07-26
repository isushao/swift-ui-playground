//
//  ZoomTransitionV2.swift
//  Playground
//
//  Created by roc on 2024/7/26.
//

import SwiftUI

struct ZoomTransitionV2: View {
    let samplePhotos = (1...6).map { Photo(id: $0, name: "\($0)") }
    
    @Namespace private var namespace
    @State private var isSelected = false
    @State private var selectedIndex: Int = 0
    
    @GestureState private var draggingOffset: CGSize = .zero
    
    @State private var bgOpacity: Double = 1
    @State private var imageScale: CGFloat = 1
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                    ForEach(samplePhotos.indices, id: \.self) { index in
                        let photo = samplePhotos[index]
                        Button(action: {
                            withAnimation(.spring()) {
                                isSelected.toggle()
                                selectedIndex = index
                            }
                        }, label: {
                            Image(photo.name)
                                .resizable()
                                .scaledToFill()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .frame(height: 150)
                                .cornerRadius(30.0)
                                .matchedGeometryEffect(id: photo.id, in: namespace, isSource: !isSelected && index == selectedIndex)
                        })
                    }
                }
            }
            .padding()
            .overlay(
                Group {
                    if isSelected {
                        Color.black.opacity(bgOpacity)
                            .ignoresSafeArea(.all)
                        ZStack {
                            ScrollView(.init()) {
                                TabView(selection: $selectedIndex) {
                                    ForEach(samplePhotos.indices, id: \.self) { index in
                                        let photo = samplePhotos[index]
                                        Image(photo.name)
                                            .resizable()
                                            .scaledToFit()
                                            .matchedGeometryEffect(id: photo.id, in: namespace, isSource: isSelected && index == selectedIndex)
                                            .tag(index)
                                            .offset(selectedIndex == index ? draggingOffset : .zero)
                                            .scaleEffect(selectedIndex == index ? (imageScale > 1 ? imageScale : 1) : 1)
                                            .gesture(
                                                MagnificationGesture()
                                                    .onChanged { value in
                                                        imageScale = value
                                                    }
                                                    .onEnded { _ in
                                                        withAnimation(.spring()) {
                                                            imageScale = 1
                                                        }
                                                    }
                                            )
                                            .simultaneousGesture(
                                                TapGesture(count: 2).onEnded {
                                                    withAnimation(.spring()) {
                                                        imageScale = imageScale > 1 ? 1 : 4
                                                    }
                                                }
                                            )
                                            .padding()
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            }
                            .ignoresSafeArea()
                        }
                        .gesture(
                            DragGesture()
                                .updating($draggingOffset) { value, outValue, _ in
                                    outValue = value.translation
                                    let halfHeight = UIScreen.main.bounds.height / 2
                                    let progress = abs(draggingOffset.height / halfHeight)
                                    bgOpacity = Double(1 - progress)
                                }
                                .onEnded { value in
                                    withAnimation(.spring()) {
                                        let translation = abs(value.translation.height)
                                        if translation > 150 {
                                            isSelected.toggle()
                                        }
                                        bgOpacity = 1
                                    }
                                }
                        )
                    }
                }
            )
        }
    }
}

#Preview {
    ZoomTransitionV2()
}
