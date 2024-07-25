//
//  MatchedGeometryEffectMultiElement.swift
//  Playground
//
//  Created by roc on 2024/7/25.
//

import SwiftUI

struct MatchedGeometryEffectMultiElement: View {
    @Namespace private var animationNamespace
    @State private var isExpanded = false

    var body: some View {
        VStack {
            if isExpanded {
                VStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.blue)
                        .matchedGeometryEffect(id: "rectangle", in: animationNamespace)
                        .frame(width: 300, height: 200)
                    Text("Expanded View")
                        .matchedGeometryEffect(id: "text", in: animationNamespace)
                }
            } else {
                VStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.blue)
                        .matchedGeometryEffect(id: "rectangle", in: animationNamespace)
                        .frame(width: 100, height: 100)
                    Text("Collapsed View")
                        .matchedGeometryEffect(id: "text", in: animationNamespace)
                }
            }

            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                Text("Toggle")
            }
            .padding()
        }
    }
}

#Preview {
    MatchedGeometryEffectMultiElement()
}
