//
//  MeasurementsView.swift
//  Caliper Lite Redesign
//
//  Created by Азар Аскаров on 21.07.2025.
//

import SwiftUI

struct MeasurementsView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    UserSubcutaneousFatPercentageCalculationView()
                        .shadow(color: colorScheme == .light ? .colorCaliperometryMeasurementViewGreenLight : .clear, radius: 10, y: 5)
                    UserBmiCalculationView()
                        .padding(.top, 30)
                        .padding(.bottom, 20)
                        .shadow(color: colorScheme == .light ? .colorBmiMeasurementViewBlueLight : .clear, radius: 10, y: 5)
                }
                .padding()
            }
            .navigationTitle("Measurements")
        }//NavigationStack
    }//Body
}//MeasurementsView

#Preview {
    MeasurementsView()
}
