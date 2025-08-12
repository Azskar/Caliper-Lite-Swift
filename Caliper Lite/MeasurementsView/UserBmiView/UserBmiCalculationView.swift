//
//  UserBmiCalculationView.swift
//  Caliper Lite Redesign
//
//  Created by Азар Аскаров on 22.07.2025.
//

import SwiftUI

struct UserBmiCalculationView: View {
    
    @State private var userBmiResultLevel: String = "Нормальный"
    @State private var currentUserWeightValue: CGFloat = 40
    @State private var currentUserHeightValue: CGFloat = 50
    @State private var currentUserBmi: Float = 19.02
    
    @State private var calculationButtonTapped: Bool = false
    
    var kilogramsText = Text("кг").font(.title2)
        .fontWeight(.semibold)
        .textScale(.secondary)
        .foregroundStyle(.white)
    var centimetersText = Text("см").font(.title2)
        .fontWeight(.semibold)
        .textScale(.secondary)
        .foregroundStyle(.white)
    
    let bmiCalculationButtonViewGradient = LinearGradient(gradient: Gradient(colors: [.white.opacity(0.25),.white.opacity(0.15)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    let bmiCalculatedResultViewGradient = LinearGradient(gradient: Gradient(colors: [.white.opacity(0.5),.white.opacity(0.4)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    let bmiMeasurementViewGradient = Gradient(colors: [Color(UIColor(.colorBmiMeasurementViewBlueLight)), Color(UIColor(.colorBmiMeasurementViewBlueBase))])
    
    @State private var currentUserWeightHorizontalWheelPickerConfig: CurrentUserWeightHorizontalWheelPicker.Config = .init(count: 19)
    @State private var currentUserHeightHorizontalWheelPickerConfig: CurrentUserHeightHorizontalWheelPicker.Config = .init(count: 28)
    
    func calculateBmi() {
        calculationButtonTapped.toggle()
        currentUserBmi = Float(currentUserWeightValue)/Float(Float(currentUserHeightValue)/100 * Float(currentUserHeightValue)/100)
        
        switch currentUserBmi {
            case ..<18.5:
            userBmiResultLevel = "Низкий"
        case 18.5..<25:
            userBmiResultLevel = "Нормальный"
        case 25..<30:
            userBmiResultLevel = "Избыточный"
        default:
            userBmiResultLevel = "Крайне избыточный"
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                Text("Индекс массы тела")
                    .font(.system(.title, design: .rounded))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                    .foregroundColor(.white)
                
                HStack(alignment: .bottom, content: {
                    Text("Вес:")
                        .font(.system(.title3, design: .rounded))
                        .bold()
                        .foregroundStyle(.white)
                    Text("\(String(format: "%.0f", currentUserWeightValue))\(kilogramsText)")
                        .font(.system(.title2, design: .rounded))
                        .bold()
                        .contentTransition(.numericText(value: currentUserWeightValue))
                        .animation(.snappy, value: currentUserWeightValue)
                        .foregroundStyle(.white)
                    Spacer()
                })
                .padding(.top)
                .padding(.horizontal)
                .padding(.horizontal, 10)
                
                CurrentUserWeightHorizontalWheelPicker(config: currentUserWeightHorizontalWheelPickerConfig, value: $currentUserWeightValue).padding(.horizontal, 25).frame(height: 55).sensoryFeedback(.increase, trigger: currentUserWeightValue)
                
                HStack(alignment: .bottom,  content: {
                    Text("Рост:")
                        .font(.system(.title3, design: .rounded))
                        .bold()
                        .foregroundStyle(.white)
                    Text("\(String(format: "%.0f", currentUserHeightValue))\(centimetersText)")
                        .font(.system(.title2, design: .rounded))
                        .bold()
                        .contentTransition(.numericText(value: currentUserHeightValue))
                        .animation(.snappy, value: currentUserHeightValue)
                        .foregroundStyle(.white)
                    Spacer()
                })
                .padding(.top)
                .padding(.top, 60)
                .padding(.horizontal)
                .padding(.horizontal, 10)
                
                CurrentUserHeightHorizontalWheelPicker(config: currentUserHeightHorizontalWheelPickerConfig, value: $currentUserHeightValue)
                    .padding(.horizontal, 25)
                    .frame(height: 55)
                
                HStack {
                    Button(action:
                            calculateBmi) {
                        Text("=")
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
                Text("\(userBmiResultLevel)")
                    .font(.system(.title2, design: .rounded))
                    .bold()
                    .foregroundColor(.colorCalculatedBmiResultText)
                Spacer()
                Text("\(String(format: "%.2f", currentUserBmi))")
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
