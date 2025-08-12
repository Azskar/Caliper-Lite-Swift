//
//  CurrentUserWeightHorizontalWheelPicker.swift
//  Caliper Lite Redesign
//
//  Created by Азар Аскаров on 03.08.2025.
//

import SwiftUI

struct CurrentUserWeightHorizontalWheelPicker: View {
    
    var config: Config
    @Binding var value: CGFloat
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let horizontalPadding = size.width / 2
            ScrollView(.horizontal) {
                HStack(spacing: config.spacing) {
                    ForEach(40...130, id: \.self) { index in
                        let remainder = index % config.steps
                        Divider()
                            .frame(width: 0,
                                   height: remainder == 0 ? 45 : 25,
                                   alignment: .center)
                            .frame(maxHeight: 50, alignment: .bottom)
                            .overlay() {
                                Capsule()
                                    .frame(width: 4,
                                           height: remainder == 0 ? 45 : 25,
                                           alignment: .center)
                                    .frame(maxHeight: 50, alignment: .bottom)
                                    .foregroundStyle(.colorCalculatedBmiResultText)
                            }
                            .overlay(alignment: .bottom) {
                                if remainder == 0 {
                                    Text("\(index / config.steps * 10)")
                                        .font(.system(.title3, design: .rounded))
                                        .fontWeight(.semibold)
                                        .textScale(.secondary)
                                        .fixedSize()
                                        .offset(y: 25)
                                        .foregroundStyle(.white)
                                }
                            }
                            .foregroundStyle(.white)
                    }
                }
                .frame(height: 90)
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: .init(get: {
                let position: Int? = Int(value)
                return position
            }, set: { newValue in
                if let newValue {
                    value = (CGFloat(newValue) / CGFloat(config.steps)) * CGFloat(config.multiplier)
                }
            }))
            .overlay(alignment: .bottom, content: {
                Capsule()
                    .frame(width: 5, height: 55)
                    .offset(y: -20)
                    .foregroundStyle(.white)
                    .shadow(color: .white, radius: 10)
            })
            .safeAreaPadding(.horizontal, horizontalPadding)
        }
    }
    
    struct Config: Equatable {
        var count: Int
        var steps: Int = 10
        var spacing: CGFloat = 12
        var multiplier: Int = 10
    }
}

/*#Preview {
    CurrentUserWeightHorizontalWheelPicker()
}*/


