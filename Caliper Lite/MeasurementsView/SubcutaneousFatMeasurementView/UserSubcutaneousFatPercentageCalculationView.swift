//
//  UserSubcutaneousFatPercentageCalculationViewC.swift
//  Caliper Lite Redesign
//
//  Created by Азар Аскаров on 22.07.2025.
//

import SwiftUI

struct UserSubcutaneousFatPercentageCalculationView: View {
    
    @Environment(\.locale) private var locale
    
    @State private var userGender: String = String(localized: "User gender")
    private var millimetersText = String(localized: "Mm")
    @State private var currentUserSubcutaneousFatLevel: String = String(localized: "Current user's body fat mass percentage level")
    //@State private var currentUserSubcutaneousFatPercent: String = ""
    @State private var currentUserSubcutaneousFatPercent: Double = 0.020
    @State private var currentUserAge: Int = 18
    @StateObject private var userProfile = UserProfile()
    /*init() {
        self.userGender = UserDefaults.standard.string(forKey: "UserGender") ?? "Не выбран"
    }*/
    @State private var userGenderIndex: Int = 1
    @State private var currentUserSkinFoldThickness: Int = 2
    @State var currentUserAgeIndex: Int = 0
    @State var currentUserSkinFoldThicknessIndex: Int = 0
    
    @State private var calculationButtonTapped: Bool = false
    @State private var isSheetPresented = false
    @State private var isProfileDataSheetPresented = false
    @State private var isCurrentUserSubcutaneousFatLevelPresented: Bool = false
    @State private var isInstructionPresented: Bool = false
    
    var lowerAgeLimits: [Int] = [18, 21, 26, 31, 36, 41, 46, 51, 56]
    var upperAgeLimits: [Int] = [20, 25, 30, 35, 40, 45, 50, 55, 120]
    var lowerSkinFoldThicknessLimits: [Int] = [2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26]
    var upperSkinFoldThicknessLimits: [Int] = [3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27]
    
    var caliperometryTable: [[[Any]]] =
        [
            [
                [0.020, 0.039, 0.062, 0.085, 0.105, 0.125, 0.143, 0.160, 0.175, 0.189, 0.202, 0.213, 0.223],
                [0.025, 0.049, 0.073, 0.095, 0.116, 0.136, 0.154, 0.170, 0.186, 0.200, 0.212, 0.223, 0.233],
                [0.035, 0.060, 0.084, 0.106, 0.127, 0.146, 0.164, 0.181, 0.196, 0.210, 0.223, 0.234, 0.244],
                [0.045, 0.071, 0.094, 11.7, 13.7, 15.7, 17.5, 19.2, 20.7, 22.1, 23.4, 24.5, 25.5],
                [0.056, 0.081, 0.105, 0.127, 0.148, 0.168, 0.186, 0.202, 0.218, 0.232, 0.244, 0.256, 0.265],
                [0.067, 0.092, 0.115, 0.138, 0.159, 0.178, 0.196, 0.213, 0.228, 0.247, 0.255, 0.266, 0.276],
                [0.077, 0.102, 0.126, 0.148, 0.169, 0.189, 0.207, 0.224, 0.239, 0.253, 0.266, 0.277, 0.287],
                [0.088, 0.113, 0.137, 0.159, 0.180, 0.200, 0.218, 0.234, 0.250, 0.264, 0.276, 0.287, 0.297],
                [0.099, 0.124, 0.147, 0.170, 0.191, 0.210, 0.228, 0.245, 0.260, 0.274, 0.287, 0.298, 0.308]
            ],
                               
            [
                [0.113, 0.135, 0.157, 0.177, 0.197, 0.215, 0.232, 0.248, 0.263, 0.277, 0.290, 0.302, 0.313],
                [0.119, 0.142, 0.163, 0.184, 0.203, 0.221, 0.238, 0.255, 0.270, 0.284, 0.296, 0.308, 0.319],
                [0.125, 0.148, 0.169, 0.190, 0.209, 0.227, 0.245, 0.261, 0.276, 0.290, 0.303, 0.315, 0.325],
                [0.132, 0.154, 0.176, 0.196, 0.215, 0.234, 0.251, 0.267, 0.282, 0.296, 0.309, 0.321, 0.332],
                [0.138, 0.160, 0.182, 0.202, 0.222, 0.240, 0.247, 0.273, 0.288, 0.302, 0.315, 0.327, 0.338],
                [0.144, 0.167, 0.188, 0.208, 0.228, 0.246, 0.263, 0.279, 0.294, 0.308, 0.321, 0.333, 0.344],
                [0.150, 0.173, 0.194, 0.215, 0.234, 0.252, 0.269, 0.286, 0.301, 0.325, 0.328, 0.340, 0.350],
                [0.156, 0.179, 0.200, 0.221, 0.240, 0.259, 0.276, 0.292, 0.307, 0.321, 0.334, 0.346, 0.356],
                [0.163, 0.185, 0.207, 0.227, 0.246, 0.265, 0.282, 0.298, 0.313, 0.327, 0.340, 0.352, 0.363]
            ],
                               
            [
                [1, 1, 2, 3, 3, 3, 4, 5, 5, 5, 6, 7, 7],
                [1, 1, 2, 3, 3, 3, 4, 5, 5, 5, 6, 7, 7],
                [1, 1, 1, 3, 3, 3, 4, 5, 5, 5, 6, 7, 7],
                [1, 1, 1, 2, 3, 3, 3, 5, 5, 5, 5, 7, 7],
                [1, 1, 1, 2, 3, 3, 3, 4, 5, 5, 5, 6, 7],
                [1, 1, 1, 2, 3, 3, 3, 4, 5, 5, 5, 6, 7],
                [1, 1, 1, 2, 3, 3, 3, 4, 5, 5, 5, 6, 7],
                [1, 1, 1, 1, 3, 3, 3, 4, 5, 5, 5, 5, 7],
                [1, 1, 1, 1, 2, 3, 3, 3, 4, 5, 5, 5, 7]
            ],
                               
            [
                [1, 1, 1, 2, 3, 3, 4, 5, 5, 5, 5, 6, 7],
                [1, 1, 1, 2, 3, 3, 4, 5, 5, 5, 5, 6, 7],
                [1, 1, 1, 2, 3, 3, 4, 5, 5, 5, 5, 6, 7],
                [1, 1, 1, 1, 3, 3, 3, 5, 5, 5, 5, 6, 7],
                [1, 1, 1, 1, 2, 3, 3, 4, 5, 5, 5, 5, 7],
                [1, 1, 1, 1, 2, 3, 3, 4, 5, 5, 5, 5, 6],
                [1, 1, 1, 1, 2, 3, 3, 4, 5, 5, 5, 5, 6],
                [1, 1, 1, 1, 1, 3, 3, 3, 5, 5, 5, 5, 6],
                [1, 1, 1, 1, 1, 2, 3, 3, 4, 5, 5, 5, 5]
            ]
        ]
    
    let subcutaneousFatPercentageMeasurementViewGradient = LinearGradient(gradient: Gradient(colors: [.colorCaliperometryMeasurementViewGreenLight, .colorCaliperometryMeasurementViewGreenBase]), startPoint: .topLeading, endPoint: .bottomTrailing)
    let subcutaneousFatPercentageCalculationButtonViewGradient = LinearGradient(gradient: Gradient(colors: [.white.opacity(0.25),.white.opacity(0.15)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    let subcutaneousFatPercentageCalculatedResultViewGradient = LinearGradient(gradient: Gradient(colors: [.white.opacity(0.5),.white.opacity(0.4)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    @State private var thinBodyImage = ImageResource(name: "body_thin_inactive", bundle: .main)
    @State private var thinIdealBodyImage = ImageResource(name: "body_thin-ideal_inactive", bundle: .main)
    @State private var idealBodyImage = ImageResource(name: "body_ideal_inactive", bundle: .main)
    @State private var idealMiddleBodyImage = ImageResource(name: "body_ideal-middle_inactive", bundle: .main)
    @State private var middleBodyImage = ImageResource(name: "body_middle_inactive", bundle: .main)
    @State private var overfatBodyImage = ImageResource(name: "body_overfat_inactive", bundle: .main)
    @State private var obeseBodyImage = ImageResource(name: "body_obese_inactive", bundle: .main)
    
    func calculateUserSubcutaneousFatPercentage() {
        calculationButtonTapped.toggle()
        
        guard UserDefaults.standard.object(forKey: "UserGender") is String,
              UserDefaults.standard.object(forKey: "UserBirthDate") is Date else {
            isProfileDataSheetPresented = true
            return
        }
        
        userGender = UserDefaults.standard.string(forKey: "UserGender") ?? "Male"
        if let birthDate = UserDefaults.standard.object(forKey: "UserBirthDate") as? Date {
            currentUserAge = birthDate.calculateAge()
        } else {
            currentUserAge = 18
        }
        
        switch userGender {
        case "Female":
            userGenderIndex = 1
        default:
            userGenderIndex = 0
        }
        
        currentUserAgeIndex = 0
        currentUserSkinFoldThicknessIndex = 0
        
        thinBodyImage = ImageResource(name: "body_thin_inactive", bundle: .main)
        thinIdealBodyImage = ImageResource(name: "body_thin-ideal_inactive", bundle: .main)
        idealBodyImage = ImageResource(name: "body_ideal_inactive", bundle: .main)
        idealMiddleBodyImage = ImageResource(name: "body_ideal-middle_inactive", bundle: .main)
        middleBodyImage = ImageResource(name: "body_middle_inactive", bundle: .main)
        overfatBodyImage = ImageResource(name: "body_overfat_inactive", bundle: .main)
        obeseBodyImage = ImageResource(name: "body_obese_inactive", bundle: .main)
        
        while true {
            if Int(currentUserAge) < lowerAgeLimits[currentUserAgeIndex] {
                // Возраст меньше нижней границы - прерываем цикл
                break
            }
            
            if Int(currentUserAge) >= lowerAgeLimits[currentUserAgeIndex] && Int(currentUserAge) <= upperAgeLimits[currentUserAgeIndex] {
                break
            }
            currentUserAgeIndex += 1
            
            // Дополнительная проверка выхода за пределы массива
            if currentUserAgeIndex >= lowerAgeLimits.count {
                break
            }
        }
        
        while !(Int(currentUserSkinFoldThickness) >= lowerSkinFoldThicknessLimits[currentUserSkinFoldThicknessIndex] && Int(currentUserSkinFoldThickness) <= upperSkinFoldThicknessLimits[currentUserSkinFoldThicknessIndex]) {
            currentUserSkinFoldThicknessIndex += 1
        }
        
        // Проверка границ перед доступом к массиву
        guard userGenderIndex + 2 < caliperometryTable.count,
              currentUserAgeIndex < caliperometryTable[userGenderIndex + 2].count,
              currentUserSkinFoldThicknessIndex < caliperometryTable[userGenderIndex + 2][currentUserAgeIndex].count
        else {
            /*currentUserSubcutaneousFatLevel = "Ошибка: выход за пределы массива"*/
            return
        }
        
        if let value = caliperometryTable[userGenderIndex + 2][currentUserAgeIndex][currentUserSkinFoldThicknessIndex] as? Int {
            switch value {
            case 1:
                currentUserSubcutaneousFatLevel = String(localized: "Lean")
                thinBodyImage = ImageResource(name: "body_thin_active", bundle: .main)
            case 2:
                currentUserSubcutaneousFatLevel = String(localized: "Close to ideal")
                thinIdealBodyImage = ImageResource(name: "body_thin-ideal_active", bundle: .main)
            case 3:
                currentUserSubcutaneousFatLevel = String(localized: "Ideal")
                idealBodyImage = ImageResource(name: "body_ideal_active", bundle: .main)
            case 4:
                currentUserSubcutaneousFatLevel = String(localized: "Close to ideal")
                idealMiddleBodyImage = ImageResource(name: "body_ideal-middle_active", bundle: .main)
            case 5:
                currentUserSubcutaneousFatLevel = String(localized: "Close to average")
                middleBodyImage = ImageResource(name: "body_middle_active", bundle: .main)
            case 6:
                currentUserSubcutaneousFatLevel = String(localized: "Average")
                overfatBodyImage = ImageResource(name: "body_overfat_active", bundle: .main)
            case 7:
                currentUserSubcutaneousFatLevel = String(localized: "Above average")
                obeseBodyImage = ImageResource(name: "body_obese_active", bundle: .main)
            default:
                print("Значение не распознано")
            }
        } else {
            print("Элемент не является строкой")
        }
        
        currentUserSubcutaneousFatPercent = (caliperometryTable[userGenderIndex][currentUserAgeIndex][currentUserSkinFoldThicknessIndex]) as! Double
        
        isCurrentUserSubcutaneousFatLevelPresented = true
    }
    
    //#if os(iOS)
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                Text("Body fat mass percentage")
                    .font(.system(.title, design: .rounded))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                    .foregroundColor(.white)
                ZStack {
                    Image("SkinfoldContour")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    HStack(spacing: 20) {
                        Image("CaliperLegWhiteLeft")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .rotationEffect(.degrees(20))
                            .padding(.bottom, 30)
                        ZStack {
                            Image("CaliperLegWhiteRight")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .rotationEffect(.degrees(-20))
                                .padding(.bottom, 30)
                            HStack {
                                Button(action: {
                                            isInstructionPresented.toggle()
                                    }, label: {
                                        ZStack{
                                            Circle()
                                                .frame(width: 25, height: 25)
                                                .foregroundStyle(.colorCaliperometryMeasurementViewGreenBase)
                                                
                                            Text("i").font(.system(.title3, design: .rounded)).bold()
                                                .foregroundStyle(.colorCaliperometryMeasurementViewGreenLight)
                                            }
                                        })
                                        .popover(isPresented: $isInstructionPresented) {
                                            Image("body_fat_measuring_by_caliper_image")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(height: 200)
                                            .presentationCompactAdaptation(.popover)
                                            .shadow(radius: 5)
                                        }
                            }.offset(x: 50, y: -70)
                        }
                    }
                    
                        Button(action: {
                                isSheetPresented.toggle()
                        }, label: {
                            //VStack(spacing: -1) {
                            VStack(spacing: locale.language.languageCode?.identifier == "ar" ? 1 : -3) {
                                HStack(alignment: .bottom) {
                                        Text("\(self.currentUserSkinFoldThickness)")
                                            .padding(.top, 60)
                                            .font(.system(.title2, design: .rounded))
                                            .bold()
                                            .foregroundColor(.white)
                                        Text(millimetersText)
                                            .padding(.top, 60)
                                            .font(.system(.title2, design: .rounded))
                                            .fontWeight(.semibold)
                                            .textScale(.secondary)
                                            .foregroundStyle(.white)
                                        }
                                Capsule().frame(width: currentUserSkinFoldThickness >= 20 ? ((locale.language.languageCode?.identifier == "ru" || locale.language.languageCode?.identifier == "ar") ? 65: 70) : (currentUserSkinFoldThickness >= 10 ? ((locale.language.languageCode?.identifier == "ru" || locale.language.languageCode?.identifier == "ar") ? 60: 65) : ((locale.language.languageCode?.identifier == "ru" || locale.language.languageCode?.identifier == "ar") ? 50: 55)), height: 2).foregroundStyle(.white)
                                }
                            })
                            .popover(isPresented: $isSheetPresented) {
                                VStack {
                                    Text("Select skinfold thickness")
                                        .padding(.top, 20)
                                    Picker("Skinfold thickness", selection: $currentUserSkinFoldThickness) {
                                        ForEach((2..<27), id: \.self) {
                                            Text("\($0)")
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                }
                                .presentationCompactAdaptation(.popover)
                            }
                }
                .frame(maxHeight: 150)
                
                Button(action: calculateUserSubcutaneousFatPercentage) {
                    Text("Equals sign")
                        .font(.system(.largeTitle, design: .rounded))
                        .bold()
                        .foregroundColor(.white)
                        .frame(width: 150, height: 50)
                        .background(subcutaneousFatPercentageCalculationButtonViewGradient)
                        .clipShape(Capsule())
                }
                .padding(.bottom)
                .sensoryFeedback(.increase, trigger: calculationButtonTapped)
                .sheet(isPresented: $isProfileDataSheetPresented) {
                        UserProfileView()
                    }
                
                HStack {
                    Image(thinBodyImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                    Spacer()
                    Image(thinIdealBodyImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                            .frame(height: 30)
                    Spacer()
                    Image(idealBodyImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                    Spacer()
                    Image(idealMiddleBodyImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                    Spacer()
                    Image(middleBodyImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                    Spacer()
                    Image(overfatBodyImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                    Spacer()
                    Image(obeseBodyImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .padding(.bottom, 5)
            }
            
            HStack {
                Text("\(isCurrentUserSubcutaneousFatLevelPresented ? currentUserSubcutaneousFatLevel : "")")
                    .font(.system(.title2, design: .rounded))
                    .bold()
                    .foregroundColor(.colorCalculatedSubcutaneousFatResultText)
                Spacer()
                Text("\(isCurrentUserSubcutaneousFatLevelPresented ? currentUserSubcutaneousFatPercent.formatted(.percent.precision(.fractionLength(1))) : "")")
                    .font(.system(.title2, design: .rounded))
                    .bold()
                    .foregroundColor(.colorCalculatedSubcutaneousFatResultText)
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
                        .foregroundStyle(subcutaneousFatPercentageCalculatedResultViewGradient))
        }
        .padding(10)
        .background(subcutaneousFatPercentageMeasurementViewGradient)
        .cornerRadius(30)
    }//body

}//View

#Preview {
    UserSubcutaneousFatPercentageCalculationView()
}
