//
//  TabViewDemo.swift
//  Playground
//
//  Created by roc on 2024/7/24.
//

import SwiftUI

struct TabViewDemo: View {
    let colors: [Color] = [ .yellow, .blue, .green, .indigo, .brown ]
    let tabbarItems = [ "Random", "Travel", "Wallpaper", "Food", "Interior Design" ]
    
    @State private var selectedIndex = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedIndex) {
                ForEach(colors.indices, id: \.self) { index in
                    colors[index]
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .tag(index)
                        .ignoresSafeArea()
                }
            }
            .ignoresSafeArea()

            TabBarView(tabbarItems: tabbarItems, selectedIndex: $selectedIndex)
                .padding(.horizontal)
        }
    }
}

struct TabBarView: View {
    var tabbarItems: [String]

    @Binding var selectedIndex: Int
    @Namespace private var menuItemTransition

    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(tabbarItems.indices, id: \.self) { index in

                        TabbarItem(name: tabbarItems[index], isActive: selectedIndex == index, namespace: menuItemTransition)
                                .onTapGesture {
                                    withAnimation(.easeInOut) {
                                        selectedIndex = index
                                    }
                                }
                    }
                }
            }.onChange(of: selectedIndex) { oldIndex, index in
                withAnimation {
                    scrollView.scrollTo(index, anchor: .center)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(25)

        }

    }
}

struct TabbarItem: View {
    var name: String
    var isActive: Bool = false
    let namespace: Namespace.ID

    var body: some View {
        if isActive {
            Text(name)
                .font(.subheadline)
                .padding(.horizontal)
                .padding(.vertical, 4)
                .foregroundColor(.white)
                .background(Capsule().foregroundColor(.purple))
                .matchedGeometryEffect(id: "highlightmenuitem", in: namespace)
        } else {
            Text(name)
                .font(.subheadline)
                .padding(.horizontal)
                .padding(.vertical, 4)
                .foregroundColor(.black)
        }

    }
}

#Preview {
    TabViewDemo()
}
