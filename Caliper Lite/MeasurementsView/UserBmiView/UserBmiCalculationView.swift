//
//  UserBmiCalculationView.swift
//  Caliper Lite Redesign
//
//  Created by Азар Аскаров on 22.07.2025.
//

import SwiftUI
import Foundation

struct UserBmiCalculationView: View {
    
    @Environment(\.locale) private var locale
    
    @State private var userBmiResultLevel = String(localized: "User's BMI result level")
    var kilogramsText = String(localized: "Kg")
    var centimetersText = String(localized: "Cm")
    
    @State private var currentUserMassValue: CGFloat = 20
    @State private var currentUserHeightValue: CGFloat = 120
    @State private var currentUserBmi: Float = 13.89
    
    @State private var currentUserMassValueArabic: CGFloat = 150
    @State private var currentUserHeightValueArabic: CGFloat = 280
    
    @State private var calculationButtonTapped: Bool = false
    @State private var isCurrentUserBmiResultShown: Bool = false
    
    
    
    let bmiCalculationButtonViewGradient = LinearGradient(gradient: Gradient(colors: [.white.opacity(0.25),.white.opacity(0.15)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    let bmiCalculatedResultViewGradient = LinearGradient(gradient: Gradient(colors: [.white.opacity(0.5),.white.opacity(0.4)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    let bmiMeasurementViewGradient = Gradient(colors: [Color(UIColor(.colorBmiMeasurementViewBlueLight)), Color(UIColor(.colorBmiMeasurementViewBlueBase))])
    
    @State private var currentUserWeightHorizontalWheelPickerConfig: CurrentUserWeightHorizontalWheelPicker.Config = .init(count: 19)
    @State private var currentUserHeightHorizontalWheelPickerConfig: CurrentUserHeightHorizontalWheelPicker.Config = .init(count: 28)
    
    func calculateBmi() {
        calculationButtonTapped.toggle()
        
        currentUserBmi = locale.language.languageCode?.identifier == "ar" ? Float(currentUserMassValueArabic)/Float(Float(currentUserHeightValueArabic)/100 * Float(currentUserHeightValueArabic)/100) : Float(currentUserMassValue)/Float(Float(currentUserHeightValue)/100 * Float(currentUserHeightValue)/100)
        
        switch currentUserBmi {
            case ..<18.5:
            userBmiResultLevel = String(localized: "Low")
        case 18.5..<25:
            userBmiResultLevel = String(localized: "Normal")
        case 25..<30:
            userBmiResultLevel = String(localized: "Average")
        default:
            userBmiResultLevel = String(localized: "Above average")
        }
        
        isCurrentUserBmiResultShown = true
    }
    
    var body: some View {
        VStack {
            VStack {
                Text("Body mass index")
                    .font(.system(.title, design: .rounded))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                    .foregroundColor(.white)
                
                HStack(alignment: .bottom, content: {
                    Text("Mass:")
                        .font(.system(.title3, design: .rounded))
                        .bold()
                        .foregroundStyle(.white)
                    /*Text(String(format: "%.0f", locale.language.languageCode?.identifier == "ar" ? currentUserMassValueArabic : currentUserMassValue))*/
                    Text("\(locale.language.languageCode?.identifier == "ar" ? Int(currentUserMassValueArabic) : Int(currentUserMassValue))")
                        .font(.system(.title2, design: .rounded))
                        .bold()
                        .foregroundStyle(.white)
                        .contentTransition(.numericText(value: locale.language.languageCode?.identifier == "ar" ? currentUserMassValueArabic : currentUserMassValue))
                        .animation(.snappy, value: locale.language.languageCode?.identifier == "ar" ? currentUserMassValueArabic : currentUserMassValue)
                    Text(kilogramsText)
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.semibold)
                        .textScale(.secondary)
                        .foregroundStyle(.white)
                        .contentTransition(.numericText(value: locale.language.languageCode?.identifier == "ar" ? currentUserMassValueArabic : currentUserMassValue))
                        .animation(.snappy, value: locale.language.languageCode?.identifier == "ar" ? currentUserMassValueArabic : currentUserMassValue)
                    Spacer()
                })
                .padding(.top)
                .padding(.horizontal)
                .padding(.horizontal, 10)
                
                CurrentUserWeightHorizontalWheelPicker(config: currentUserWeightHorizontalWheelPickerConfig, value: locale.language.languageCode?.identifier == "ar" ? $currentUserMassValueArabic : $currentUserMassValue)
                    .padding(.horizontal, 25)
                    .frame(height: 55)
                    .sensoryFeedback(.increase, trigger: locale.language.languageCode?.identifier == "ar" ? currentUserMassValueArabic : currentUserMassValue)
                
                HStack(alignment: .bottom,  content: {
                    Text("Height:")
                        .font(.system(.title3, design: .rounded))
                        .bold()
                        .foregroundStyle(.white)
                    Text("\(locale.language.languageCode?.identifier == "ar" ? Int(currentUserHeightValueArabic) : Int(currentUserHeightValue))")
                        .font(.system(.title2, design: .rounded))
                        .bold()
                        .foregroundStyle(.white)
                        .contentTransition(.numericText(value: locale.language.languageCode?.identifier == "ar" ? currentUserHeightValueArabic : currentUserHeightValue))
                        .animation(.snappy, value: locale.language.languageCode?.identifier == "ar" ? currentUserHeightValueArabic : currentUserHeightValue)
                    Text(centimetersText)
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.semibold)
                        .textScale(.secondary)
                        .foregroundStyle(.white)
                        .contentTransition(.numericText(value: locale.language.languageCode?.identifier == "ar" ? currentUserHeightValueArabic : currentUserHeightValue))
                        .animation(.snappy, value: locale.language.languageCode?.identifier == "ar" ? currentUserHeightValueArabic : currentUserHeightValue)
                    Spacer()
                })
                .padding(.top)
                .padding(.top, 60)
                .padding(.horizontal)
                .padding(.horizontal, 10)
                
                CurrentUserHeightHorizontalWheelPicker(config: currentUserHeightHorizontalWheelPickerConfig, value: locale.language.languageCode?.identifier == "ar" ? $currentUserHeightValueArabic : $currentUserHeightValue)
                    .padding(.horizontal, 25)
                    .frame(height: 55)
                    .sensoryFeedback(.increase, trigger: currentUserHeightValue)
                
                HStack {
                    Button(action:
                            calculateBmi) {
                        Text("Equals sign")
                            .font(.system(.largeTitle, design: .rounded))
                            .bold()
                            .foregroundColor(.white)
                            .frame(width: 150, height: 50)
                            .background(bmiCalculationButtonViewGradient)
                            .clipShape(Capsule())
                    }.sensoryFeedback(.increase, trigger: calculationButtonTapped)
                }
                .padding()
                .padding(.top, 50)
                .padding(.bottom, 10)
            }
            
            HStack {
                Text("\(isCurrentUserBmiResultShown ? userBmiResultLevel : "")")
                    .font(.system(.title2, design: .rounded))
                    .bold()
                    .foregroundColor(.colorCalculatedBmiResultText)
                Spacer()
                Text("\(isCurrentUserBmiResultShown ? String(format: "%.2f", currentUserBmi) : "")")
                    .font(.system(.title2, design: .rounded))
                    .bold()
                    .foregroundColor(.colorCalculatedBmiResultText)
            }
            .padding()
            .padding(.horizontal, 20)
            .padding(.top, 5)
            .padding(.bottom, 10)
            .background(
                UnevenRoundedRectangle(
                        cornerRadii: .init(
                            topLeading: 15,
                            bottomLeading: 25,
                            bottomTrailing: 25,
                            topTrailing: 15),
                        style: .continuous)
                    .foregroundStyle(bmiCalculatedResultViewGradient))
            }
            .padding(10)
            .background(LinearGradient(gradient: bmiMeasurementViewGradient,
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing))
            .cornerRadius(30)
    }
}

#Preview {
    UserBmiCalculationView()
}
