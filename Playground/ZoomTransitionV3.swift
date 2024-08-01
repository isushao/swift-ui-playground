import SwiftUI

struct ZoomTransitionV3: View {
    // Sample photos
    let samplePhotos = (1...6).map { Photo(id: $0, name: "\($0)") }
    
    @State private var isSelected = false
    @State private var selectedId = 1
    @Namespace private var namespace
    @GestureState private var draggingOffset: CGSize = .zero
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollView in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(samplePhotos) { photo in
                            Image(photo.name)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .offset(photo.id == selectedId ? draggingOffset : .zero)
                                .onTapGesture {
                                    isSelected.toggle()
                                    selectedId = photo.id
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
        .overlay(
            Group {
                if isSelected {
                    ZStack {
                        TabView(selection: $selectedId) {
                            ForEach(samplePhotos) { photo in
                                Image(photo.name)
                                    .resizable()
                                    .frame(width: 200, height: 200)
                                    .offset(draggingOffset)
                                    .tag(photo.id)
                                    .matchedGeometryEffect(id: photo.id, in: namespace, isSource: isSelected && selectedId == photo.id)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .gesture(
                            DragGesture()
                                .updating($draggingOffset) { value, outValue, _ in
                                    outValue = value.translation
                                }
                                .onEnded { value in
                                    let translation = abs(value.translation.height)
                                    if translation > 150 {
                                        isSelected.toggle()
                                    }
                                    
                                }
                        )
                    }
                }
            }
        )
    }
}

#Preview {
    ZoomTransitionV3()
}
