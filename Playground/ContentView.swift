//
//  ContentView.swift
//  Playground
//
//  Created by roc on 2024/7/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            ZoomTransitionV3()
                .navigationTitle("训练场")
        }
    }
}

#Preview {
    ContentView()
}
