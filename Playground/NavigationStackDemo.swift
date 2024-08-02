//
//  NavigationStackDemo.swift
//  Playground
//
//  Created by roc on 2024/7/25.
//

import SwiftUI

struct NavigationStackDemo: View {
    private var bgColors: [Color] = [ .indigo, .yellow, .green, .orange, .brown ]
    private var systemImages: [String] = [ "trash", "cloud", "bolt" ]
    
    @State private var path: [Color] = []
    
    var body: some View {
        
        NavigationStack(path: $path) {
            List(bgColors, id: \.self) { bgColor in
                
                NavigationLink(value: bgColor) {
                    Text(bgColor.description)
                }
                
            }
            .listStyle(.plain)
            List(systemImages, id: \.self) { systemImage in

                NavigationLink(value: systemImage) {
                    Text(systemImage.description)
                }

            }
            .listStyle(.plain)
            .navigationDestination(for: Color.self) { color in
                VStack {
                    Text("\(path.count), \(path.description)")
                        .font(.headline)
                    
                    HStack {
                        ForEach(path, id: \.self) { color in
                            color
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        
                    }
                    
                    List(bgColors, id: \.self) { bgColor in
                        
                        NavigationLink(value: bgColor) {
                            Text(bgColor.description)
                        }
                        
                    }
                    .listStyle(.plain)
                    
                }
            }
            .navigationDestination(for: String.self) { systemImage in
                Image(systemName: systemImage)
                    .font(.system(size: 100.0))
            }
            .navigationTitle("Color")
            
        }
        
        Button {
            path = .init()
        } label: {
            Text("Back to Main")
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }
}

#Preview {
    NavigationStackDemo()
}
