//
//  ScrollViewDemo.swift
//  Playground
//
//  Created by roc on 2024/7/24.
//

import SwiftUI

struct ScrollViewDemo: View {
    private let sampleTrips = ["1","2","3","4","5","6"]
    
    var body: some View {
        ScrollView(.horizontal){
            LazyHStack(spacing: 0){
                ForEach(sampleTrips, id: \.self){trip in
                    Image(trip)
                        .resizable()
                        .scaledToFill()
                        .frame(width:350,height: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        .padding(.horizontal,20)
                        .containerRelativeFrame(.horizontal)//自动占用所有可用空间，此例占满屏幕的宽度
                    
                        .scrollTransition(.animated, axis: .horizontal) { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1.0 : 0.8)
                                .scaleEffect(phase.isIdentity ? 1.0 : 0.8)
                        }
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned) //设置滚动行为 创建分页动画
    }
}

#Preview {
    ScrollViewDemo()
}
