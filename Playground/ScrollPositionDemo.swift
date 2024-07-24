//
//  ScrollPositionDemo.swift
//  Playground
//
//  Created by roc on 2024/7/24.
//

import SwiftUI

struct ScrollPositionDemo: View {
    let bgColors: [Color] = [ .yellow, .blue, .orange, .indigo, .green ]
    @State private var scrollID: Int?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(0...50, id: \.self) { index in

                    bgColors[index % 5]
                        .frame(height: 100)
                        .overlay {
                            Text("\(index)")
                                .foregroundStyle(.white)
                                .font(.system(.title, weight: .bold))
                        }
                }
            }
            .scrollTargetLayout() // 无此修饰符，position无效
        }
        // 跟踪滚动的位置
        .scrollPosition(id: $scrollID)
        .contentMargins(.horizontal, 10.0, for: .scrollContent)
        .onTapGesture {
            withAnimation {
                scrollID = 0
            }
        }
        .onChange(of: scrollID) { oldValue, newValue in
            print(newValue ?? "")
        }

    }
}

#Preview {
    ScrollPositionDemo()
}
