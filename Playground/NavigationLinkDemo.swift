//
//  NavigationLinkDemo.swift
//  Playground
//
//  Created by roc on 2024/8/2.
//

import SwiftUI

struct NavigationLinkDemo: View {
    @State private var isActive = false

        var body: some View {
            NavigationStack {
                VStack {
                    Button(action: {
                        isActive = true
                    }) {
                        Text("Go to Detail View")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .navigationDestination(isPresented: $isActive) {
                    DetailView()
                }
                .navigationTitle("Home")
            }
        }
}

struct DetailView: View {
    @Environment(\.dismiss) var dismiss

        var body: some View {
            VStack {
                Text("This is the detail view")
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.blue)
                Text("Back")
                    .foregroundColor(.blue)
            })
            .navigationTitle("Detail")
        }
}

#Preview {
    NavigationLinkDemo()
}
