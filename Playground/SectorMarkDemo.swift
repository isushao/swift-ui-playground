//
//  SectorMarkDemo.swift
//  Playground
//
//  Created by roc on 2024/7/24.
//

import SwiftUI
import Charts

struct SectorMarkDemo: View {
    
    private var coffeeSales = [
        (name: "Americano", count: 120),
        (name: "Cappuccino", count: 234),
        (name: "Espresso", count: 62),
        (name: "Latte", count: 625),
        (name: "Mocha", count: 320),
        (name: "Affogato", count: 50)
    ]
    
    @State private var selectedCount: Int?
    @State private var selectedSector: String?
    
    var body: some View {
        VStack {
            Chart {
                ForEach(coffeeSales, id: \.name) { coffee in
                    SectorMark(
                        angle: .value("Cup", coffee.count),
                        innerRadius: .ratio(0.65),
                        angularInset: 2.0
                    )
                    .foregroundStyle(by: .value("Type", coffee.name))
                    .cornerRadius(10.0)
                    .annotation(position: .overlay, content: {
                        Text("\(coffee.count)")
                            .font(.headline)
                            .foregroundStyle(.white)
                    })
                    .opacity(selectedSector == nil ? 1.0 : (selectedSector == coffee.name ? 1.0 : 0.5))
                }
            }.frame(height: 500)
                .chartBackground { ChartProxy in
                    Text("☕️").font(.system(size: 100))
                }
                .chartAngleSelection(value: $selectedCount)//长按选择
                .onChange(of: selectedCount) { oldValue, newValue in
                    if let newValue {
                        selectedSector = findSelectedSector(value: newValue)
                    } else {
                        selectedSector = nil
                    }
                }
        }
        .padding()
    }
    
    private func findSelectedSector(value: Int) -> String? {
        var accumulatedCount = 0
        let coffee = coffeeSales.first { (_, count) in
            accumulatedCount += count
            return value <= accumulatedCount
        }
        return coffee?.name
    }
}


#Preview {
    SectorMarkDemo()
}
