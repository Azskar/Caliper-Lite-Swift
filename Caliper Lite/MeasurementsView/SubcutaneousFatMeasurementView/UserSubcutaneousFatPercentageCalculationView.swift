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
    @State private var currentUserSubcutaneousFatPercent: String = ""
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
    @State private var isCurrentUserSubcutaneousFatLevelShown: Bool = false
    
    var lowerAgeLimits: [Int] = [18, 21, 26, 31, 36, 41, 46, 51, 56]
    var upperAgeLimits: [Int] = [20, 25, 30, 35, 40, 45, 50, 55, 120]
    var lowerSkinFoldThicknessLimits: [Int] = [2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26]
    var upperSkinFoldThicknessLimits: [Int] = [3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27]
    
    var caliperometryTable: [[[String]]] =
        [
            [
                ["2.0", "3.9", "6.2", "8.5", "10.5", "12.5", "14.3", "16.0", "17.5", "18.9", "20.2", "21.3", "22.3"],
                ["2.5", "4.9", "7.3", "9.5", "11.6", "13.6", "15.4", "17.0", "18.6", "20.0", "21.2", "22.3", "23.3"],
                ["3.5", "6.0", "8.4", "10.6", "12.7", "14.6", "16.4", "18.1", "19.6", "21.0", "22.3", "23.4", "24.4"],
                ["4.5", "7.1", "9.4", "11.7", "13.7", "15.7", "17.5", "19.2", "20.7", "22.1", "23.4", "24.5", "25.5"],
                ["5.6", "8.1", "10.5", "12.7", "14.8", "16.8", "18.6", "20.2", "21.8", "23.2", "24.4", "25.6", "26.5"],
                ["6.7", "9.2", "11.5", "13.8", "15.9", "17.8", "19.6", "21.3", "22.8", "24.7", "25.5", "26.6", "27.6"],
                ["7.7", "10.2", "12.6", "14.8", "16.9", "18.9", "20.7", "22.4", "23.9", "25.3", "26.6", "27.7", "28.7"],
                ["8.8", "11.3", "13.7", "15.9", "18.0", "20.0", "21.8", "23.4", "25.0", "26.4", "27.6", "28.7", "29.7"],
                ["9.9", "12.4", "14.7", "17.0", "19.1", "21.0", "22.8", "24.5", "26.0", "27.4", "28.7", "29.8", "30.8"]
            ],
                               
            [
                ["11.3", "13.5", "15.7", "17.7", "19.7", "21.5", "23.2", "24.8", "26.3", "27.7", "29.0", "30.2", "31.3"],
                ["11.9", "14.2", "16.3", "18.4", "20.3", "22.1", "23.8", "25.5", "27.0", "28.4", "29.6", "30.8", "31.9"],
                ["12.5", "14.8", "16.9", "19.0", "20.9", "22.7", "24.5", "26.1", "27.6", "29.0", "30.3", "31.5", "32.5"],
                ["13.2", "15.4", "17.6", "19.6", "21.5", "23.4", "25.1", "26.7", "28.2", "29.6", "30.9", "32.1", "33.2"],
                ["13.8", "16.0", "18.2", "20.2", "22.2", "24.0", "24.7", "27.3", "28.8", "30.2", "31.5", "32.7", "33.8"],
                ["14.4", "16.7", "18.8", "20.8", "22.8", "24.6", "26.3", "27.9", "29.4", "30.8", "32.1", "33.3", "34.4"],
                ["15.0", "17.3", "19.4", "21.5", "23.4", "25.2", "26.9", "28.6", "30.1", "32.5", "32.8", "34.0", "35.0"],
                ["15.6", "17.9", "20.0", "22.1", "24.0", "25.9", "27.6", "29.2", "30.7", "32.1", "33.4", "34.6", "35.6"],
                ["16.3", "18.5", "20.7", "22.7", "24.6", "26.5", "28.2", "29.8", "31.3", "32.7", "34.0", "35.2", "36.3"]
            ],
                               
            [
                ["1", "1", "2", "3", "3", "3", "4", "5", "5", "5", "6", "7", "7"],
                ["1", "1", "2", "3", "3", "3", "4", "5", "5", "5", "6", "7", "7"],
                ["1", "1", "1", "3", "3", "3", "4", "5", "5", "5", "6", "7", "7"],
                ["1", "1", "1", "2", "3", "3", "3", "5", "5", "5", "5", "7", "7"],
                ["1", "1", "1", "2", "3", "3", "3", "4", "5", "5", "5", "6", "7"],
                ["1", "1", "1", "2", "3", "3", "3", "4", "5", "5", "5", "6", "7"],
                ["1", "1", "1", "2", "3", "3", "3", "4", "5", "5", "5", "6", "7"],
                ["1", "1", "1", "1", "3", "3", "3", "4", "5", "5", "5", "5", "7"],
                ["1", "1", "1", "1", "2", "3", "3", "3", "4", "5", "5", "5", "7"]
            ],
                               
            [
                ["1", "1", "1", "2", "3", "3", "4", "5", "5", "5", "5", "6", "7"],
                ["1", "1", "1", "2", "3", "3", "4", "5", "5", "5", "5", "6", "7"],
                ["1", "1", "1", "2", "3", "3", "4", "5", "5", "5", "5", "6", "7"],
                ["1", "1", "1", "1", "3", "3", "3", "5", "5", "5", "5", "6", "7"],
                ["1", "1", "1", "1", "2", "3", "3", "4", "5", "5", "5", "5", "7"],
                ["1", "1", "1", "1", "2", "3", "3", "4", "5", "5", "5", "5", "6"],
                ["1", "1", "1", "1", "2", "3", "3", "4", "5", "5", "5", "5", "6"],
                ["1", "1", "1", "1", "1", "3", "3", "3", "5", "5", "5", "5", "6"],
                ["1", "1", "1", "1", "1", "2", "3", "3", "4", "5", "5", "5", "5"]
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
        
        switch caliperometryTable[userGenderIndex + 2][currentUserAgeIndex][currentUserSkinFoldThicknessIndex] {
        case "1":
            currentUserSubcutaneousFatLevel = String(localized: "Lean")
            thinBodyImage = ImageResource(name: "body_thin_active", bundle: .main)
        case "2":
            currentUserSubcutaneousFatLevel = String(localized: "Close to ideal")
            thinIdealBodyImage = ImageResource(name: "body_thin-ideal_active", bundle: .main)
        case "3":
            currentUserSubcutaneousFatLevel = String(localized: "Ideal")
            idealBodyImage = ImageResource(name: "body_ideal_active", bundle: .main)
        case "4":
            currentUserSubcutaneousFatLevel = String(localized: "Close to ideal")
            idealMiddleBodyImage = ImageResource(name: "body_ideal-middle_active", bundle: .main)
        case "5":
            currentUserSubcutaneousFatLevel = String(localized: "Close to average")
            middleBodyImage = ImageResource(name: "body_middle_active", bundle: .main)
        case "6":
            currentUserSubcutaneousFatLevel = String(localized: "Average")
            overfatBodyImage = ImageResource(name: "body_overfat_active", bundle: .main)
        case "7":
            currentUserSubcutaneousFatLevel = String(localized: "Above average")
            obeseBodyImage = ImageResource(name: "body_obese_active", bundle: .main)
        default:
            print("Значение не распознано")
        }
            
        currentUserSubcutaneousFatPercent = "\(caliperometryTable[userGenderIndex][currentUserAgeIndex][currentUserSkinFoldThicknessIndex]) %"
        
        isCurrentUserSubcutaneousFatLevelShown = true
    }
    
    //#if os(iOS)
    var body: some View {
        VStack {
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
                        Image("CaliperLegWhiteRight")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .rotationEffect(.degrees(-20))
                            .padding(.bottom, 30)
                    }
                    
                        Button(action: {
                                isSheetPresented.toggle()
                        }, label: {
                            VStack(spacing: -3) {
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
                                Capsule().frame(width: currentUserSkinFoldThickness >= 20 ? (locale.language.languageCode?.identifier == "ru" ? 65: 70) : (currentUserSkinFoldThickness >= 10 ? (locale.language.languageCode?.identifier == "ru" ? 60: 65) : (locale.language.languageCode?.identifier == "ru" ? 50: 55)), height: 2).foregroundStyle(.white)
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
                Text("\(isCurrentUserSubcutaneousFatLevelShown ? currentUserSubcutaneousFatLevel : "")")
                    .font(.system(.title2, design: .rounded))
                    .bold()
                    .foregroundColor(.colorCalculatedSubcutaneousFatResultText)
                Spacer()
                Text("\(isCurrentUserSubcutaneousFatLevelShown ? currentUserSubcutaneousFatPercent : "")")
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
