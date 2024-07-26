//
//  ZoomTransitionV2.swift
//  Playground
//
//  Created by roc on 2024/7/26.
//

import SwiftUI

struct ZoomTransitionV2: View {
    let samplePhotos = (1...6).map { Photo(id:$0 ,name: "\($0)") }
    
    @Namespace private var namespace
    @State private var selectedPhoto: Photo? = nil
    @State private var selectedIndex: Int = 0
    
    @GestureState var draggingOffset: CGSize = .zero
    
    @State var bgQpacity: Double = 1
    @State var imageScale: CGFloat = 1
    
    init() {
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                    ForEach(samplePhotos.indices,id:\.self) { index in
                        let photo = samplePhotos[index]
                        Button(action: {
                            withAnimation(.easeInOut) {
                                selectedPhoto = photo
                                selectedIndex = index
                            }
                        }, label: {
                            Image(photo.name)
                                .resizable()
                                .scaledToFill()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .frame(height: 150)
                                .cornerRadius(30.0)
                                .matchedGeometryEffect(id: photo.id, in: namespace)
                        })
                    }
                }
            }
            .padding()
            .overlay(
                Group {
                    if selectedPhoto != nil {
                        Color.black.opacity(bgQpacity)
                            .ignoresSafeArea(.all)
                        ZStack(alignment: .center) {
                            ScrollView(.init()){
                                TabView(selection: $selectedIndex) {
                                    ForEach(samplePhotos.indices, id: \.self) { index in
                                        let photo = samplePhotos[index]
                                        Image(photo.name)
                                            .resizable()
                                            .scaledToFit()
                                            .matchedGeometryEffect(id: photo.id, in: namespace)
                                            .tag(index)
                                            .offset(draggingOffset)
                                            .scaleEffect(selectedIndex == index ? (imageScale > 1 ? imageScale : 1) :1)
                                            .gesture(
                                                MagnificationGesture()
                                                    .onChanged({ value in
                                                        imageScale = value
                                                        
                                                    })
                                                    .onEnded({ _ in
                                                        withAnimation(.spring()) {
                                                            imageScale = 1
                                                        }
                                                    })
                                            )
                                            .simultaneousGesture(
                                                TapGesture(count: 2).onEnded({ value in
                                                    withAnimation {
                                                        imageScale = imageScale > 1 ? 1 : 4
                                                    }
                                                })
                                            )
                                            .padding()
                                    }
                                }
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            }.ignoresSafeArea()
                        }
                        .gesture(DragGesture().updating($draggingOffset, body: { (value, outValue, _) in
                            outValue = value.translation
                            let halgHeight = UIScreen.main.bounds.height / 2
                            let progress = draggingOffset.height / halgHeight
                            withAnimation(.default){
                                bgQpacity = Double(1 - (progress < 0 ? -progress : progress))
                            }
                        }).onEnded({ value in
                            var translation = value.translation.height
                            if translation < 0 {
                                translation = -translation
                            }
                            if translation > 250 {
                                selectedPhoto = nil
                            }
                            bgQpacity = 1
                        })).transition(.move(edge: .bottom))
                    }
                }
            )
        }
    }
}

#Preview {
    ZoomTransitionV2()
}
