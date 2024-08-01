import SwiftUI

struct ZoomTransitionV3: View {
    // Sample photos
    let samplePhotos = (1...6).map { Photo(id: $0, name: "\($0)") }
    
    @State private var isSelected = false
    @State private var selectedId = 1
    @Namespace private var namespace
    @GestureState private var draggingOffset: CGSize = .zero
    @State private var bgOpacity: Double = 1
    
    var body: some View {
        NavigationStack {
            List {
                ScrollViewReader { scrollView in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(samplePhotos) { photo in
                                Image(photo.name)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .offset(photo.id == selectedId ? draggingOffset : .zero)
                                    .onTapGesture {
                                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8)) {
                                            isSelected.toggle()
                                            selectedId = photo.id
                                        }
                                    }
                                    .matchedGeometryEffect(id: photo.id, in: namespace, isSource: !isSelected && selectedId == photo.id)
                            }
                        }
                    }
                    .onChange(of: selectedId) { _, index in
                        withAnimation {
                            scrollView.scrollTo(index, anchor: .center)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("图片转场")
            .overlay(
                Group {
                    if isSelected {
                        ZStack {
                            Color.black.opacity(bgOpacity)
                                .ignoresSafeArea(.all)
                            TabView(selection: $selectedId) {
                                ForEach(samplePhotos) { photo in
                                    Image(photo.name)
                                        .resizable()
                                        .scaledToFit()
                                        .offset(draggingOffset)
                                        .tag(photo.id)
                                        .matchedGeometryEffect(id: photo.id, in: namespace, isSource: isSelected && selectedId == photo.id)
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
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
                                    let translation = abs(value.translation.height)
                                    if translation > 150 {
                                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.8)) {
                                            isSelected.toggle()
                                        }
                                    }
                                    bgOpacity = 1
                                }
                        )
                    }
                }
            )
        }
    }
}

#Preview {
    ZoomTransitionV3()
}
