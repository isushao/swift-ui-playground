//
//  TabviewDemo2.swift
//  Playground
//
//  Created by roc on 2024/8/2.
//

import SwiftUI

struct TabviewDemo2: View {
    @State private var inputShow = false
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            Text("Selected Tab: \(selectedTab)")
            Text("Input Show: \(inputShow.description)")
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(0)
                
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .tag(1)
                
                FavoritesView()
                    .tabItem {
                        Image(systemName: "star")
                        Text("Favorites")
                    }
                    .tag(2)
                
                EditView(inputShow: $inputShow)
                    .tabItem {
                        Image(systemName: "square.and.pencil")
                        Text("Edit")
                    }
                    .tag(3)
            }
            .onChange(of: inputShow) { _,newValue in
                if newValue == false {
                    withAnimation {
                        selectedTab = 0
                    }
                }
            }
        }
    }
}

struct HomeView: View {
    var body: some View {
        Text("Home View")
    }
}

struct SearchView: View {
    var body: some View {
        Text("Search View")
    }
}

struct FavoritesView: View {
    var body: some View {
        Text("Favorites View")
    }
}

struct EditView: View {
    @Binding var inputShow: Bool

    var body: some View {
        VStack {
            Text("Edit View")
            Toggle(isOn: $inputShow) {
                Text("Show Input")
            }
            .padding()
        }
    }
}

#Preview {
    TabviewDemo2()
}
