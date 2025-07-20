//
//  ContentView.swift
//  Caliper Lite
//
//  Created by Азар Аскаров on 20.07.2025.
//

import SwiftUI

struct ContentView: View {
    func calculateBmi() {
        currentUserBmi = (currentUserMass / ((currentUserHeight/100) * (currentUserHeight/100)))
        if currentUserBmi < 18.5 {
            userBmiResultColor = UIColor(named: "ColorBodyThin") ?? UIColor.black
        } else if currentUserBmi >= 18.5 && currentUserBmi < 25 {
            userBmiResultColor = UIColor(named: "ColorGreenActive") ?? UIColor.black
        } else if currentUserBmi >= 25 && currentUserBmi < 30 {
            userBmiResultColor = UIColor(named: "ColorBodyMiddle") ?? UIColor.black
        } else if currentUserBmi >= 30 {
            userBmiResultColor = UIColor(named: "ColorBodyObese") ?? UIColor.black
        }
    }
    
    func calculateUserSubcutaneousFatPercentage() {
        if isMaleGenderSelected || isFemaleGenderSelected {
            //thicknessLevel = ""
            thinBodyImage = ImageResource(name: "body_thin_inactive", bundle: .main)
            thinIdealBodyImage = ImageResource(name: "body_thin-ideal_inactive", bundle: .main)
            idealBodyImage = ImageResource(name: "body_ideal_inactive", bundle: .main)
            idealMiddleBodyImage = ImageResource(name: "body_ideal-middle_inactive", bundle: .main)
            middleBodyImage = ImageResource(name: "body_middle_inactive", bundle: .main)
            overfatBodyImage = ImageResource(name: "body_overfat_inactive", bundle: .main)
            obeseBodyImage = ImageResource(name: "body_obese_inactive", bundle: .main)
            userAgeIndex = 0
            userSkinFoldThicknessIndex = 0
            
            while !(Int(currentUserAge) >= lowerAgeLimits[userAgeIndex] && Int(currentUserAge) <= upperAgeLimits[userAgeIndex]) {
                userAgeIndex += 1
            }
            while !(Int(currentUserSkinFoldThickness) >= lowerSkinFoldThicknessLimits[userSkinFoldThicknessIndex] && Int(currentUserSkinFoldThickness) <= upperSkinFoldThicknessLimits[userSkinFoldThicknessIndex]) {
                userSkinFoldThicknessIndex += 1
            }
            
            // Проверка границ перед доступом к массиву
            guard
                userGenderIndex + 2 < caliperometryTable.count,
                userAgeIndex < caliperometryTable[userGenderIndex + 2].count,
                userSkinFoldThicknessIndex < caliperometryTable[userGenderIndex + 2][userAgeIndex].count
            else {
                userSubcutaneousFatLevel = "Ошибка: выход за пределы массива"
                return
            }
            
            // Обработка значений
            switch caliperometryTable[userGenderIndex + 2][userAgeIndex][userSkinFoldThicknessIndex] {
            case "1":
                userSubcutaneousFatLevel = "низкий"
                userSubcutaneousFatLevelColor = UIColor(named: "ColorBodyThin")
                thinBodyImage = ImageResource(name: "body_thin_active", bundle: .main)
            case "2":
                userSubcutaneousFatLevel = "низкий-идеальный"
                userSubcutaneousFatLevelColor = UIColor(named: "ColorBodyThinIdeal")
                thinIdealBodyImage = ImageResource(name: "body_thin-ideal_active", bundle: .main)
            case "3":
                userSubcutaneousFatLevel = "идеальный"
                userSubcutaneousFatLevelColor = UIColor(named: "ColorGreenActive")
                idealBodyImage = ImageResource(name: "body_ideal_active", bundle: .main)
            case "4":
                userSubcutaneousFatLevel = "идеальный-средний"
                userSubcutaneousFatLevelColor = UIColor(named: "ColorBodyIdealMiddle")
                idealMiddleBodyImage = ImageResource(name: "body_ideal-middle_active", bundle: .main)
            case "5":
                userSubcutaneousFatLevel = "средний"
                userSubcutaneousFatLevelColor = UIColor(named: "ColorBodyMiddle")
                middleBodyImage = ImageResource(name: "body_middle_active", bundle: .main)
            case "6":
                userSubcutaneousFatLevel = "средний-высокий"
                userSubcutaneousFatLevelColor = UIColor(named: "ColorBodyOverfat")
                overfatBodyImage = ImageResource(name: "body_overfat_active", bundle: .main)
            case "7":
                userSubcutaneousFatLevel = "высокий"
                userSubcutaneousFatLevelColor = UIColor(named: "ColorBodyObese")
                obeseBodyImage = ImageResource(name: "body_obese_active", bundle: .main)
            default:
                print("Значение не распознано")
            }
            
            userSubcutaneousFatPercentText = "\(caliperometryTable[userGenderIndex][userAgeIndex][userSkinFoldThicknessIndex])%"
        }
    }
    
    @State private var userGenderIndex: Int = -1
    @State private var currentUserAge: Float = 18
    @State private var currentUserSkinFoldThickness: Float = 2
    @State private var currentUserHeight: Float = 145
    @State private var currentUserMass: Float = 40
    @State private var currentUserBmi: Float = 0
    @State private var isMaleGenderSelected = false
    @State private var isFemaleGenderSelected = false
    
    let inactiveGreenColor = UIColor(named: "ColorGreenInactive")
    let activeGreenColor = UIColor(named: "ColorGreenActive")
    let backgroundGrayColor = UIColor(named: "ColorBackgroundGray")
    let bmiLabelTextColor = UIColor(named: "ColorTextBmi")
    let calculationButtonTextColor = UIColor(named: "ColorButtonTextCalculate")
    let calculationButtonColor = UIColor(named: "ColorButtonCalculate")
    @State private var userSubcutaneousFatLevelColor = UIColor(named: "ThicknessColor")
    @State private var userBmiResultColor = UIColor.white
    
    var lowerAgeLimits: [Int] = [18, 21, 26, 31, 36, 41, 46, 51, 56]
    var upperAgeLimits: [Int] = [20, 25, 30, 35, 40, 45, 50, 55, 120]
    var lowerSkinFoldThicknessLimits: [Int] = [2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26]
    var upperSkinFoldThicknessLimits: [Int] = [3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27]
    
    @State var userAgeIndex: Int = 0
    @State var userSkinFoldThicknessIndex: Int = 0
    @State private var userSubcutaneousFatLevel: String = ""
    @State private var userSubcutaneousFatPercentText: String = ""
    
    @State private var thinBodyImage = ImageResource(name: "body_thin_inactive", bundle: .main)
    @State private var thinIdealBodyImage = ImageResource(name: "body_thin-ideal_inactive", bundle: .main)
    @State private var idealBodyImage = ImageResource(name: "body_ideal_inactive", bundle: .main)
    @State private var idealMiddleBodyImage = ImageResource(name: "body_ideal-middle_inactive", bundle: .main)
    @State private var middleBodyImage = ImageResource(name: "body_middle_inactive", bundle: .main)
    @State private var overfatBodyImage = ImageResource(name: "body_overfat_inactive", bundle: .main)
    @State private var obeseBodyImage = ImageResource(name: "body_obese_inactive", bundle: .main)
    
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
    
    var body: some View {
        VStack {
            Text("Расчитайте процент жира в организме")
                .font(.headline)
                .bold()
                .padding(.top, 80)
            VStack() {
                HStack {
                    Button(action: {
                        isMaleGenderSelected.toggle()
                        if isFemaleGenderSelected == true {
                            isFemaleGenderSelected = false
                        }
                        userGenderIndex = 0
                    }) {
                        Image(isMaleGenderSelected ? "man_active" : "man_inactive")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: .infinity, height: 40)
                    }.frame(width: 100, height: 50)
                        .background(isMaleGenderSelected ? Color(activeGreenColor ?? UIColor.green) : Color(inactiveGreenColor ?? UIColor.green))
                        .clipShape(Capsule())
                    Spacer()
                    Text("Калипер")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color(inactiveGreenColor ?? UIColor.black))
                    Spacer()
                    Button(action: {
                        isFemaleGenderSelected.toggle()
                        if isMaleGenderSelected == true {
                            isMaleGenderSelected = false
                        }
                        userGenderIndex = 1
                    }) {
                        Image(isFemaleGenderSelected ? "woman_active" :"woman_inactive")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: .infinity, height: 40)
                    }.frame(width: 100, height: 50)
                        .background(isFemaleGenderSelected ? Color(activeGreenColor ?? UIColor.green) : Color(inactiveGreenColor ?? UIColor.green))
                        .clipShape(Capsule())
                        
                    //Button("Custom Button", action: performAction)
                       //.buttonStyle(CustomButtonStyle())
                }
                
                HStack {
                    Image("human_young")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30, alignment: .bottom)
                        .padding(.top, 20)
                    Spacer()
                    Text("\(Int(currentUserAge))")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color(activeGreenColor ?? UIColor.black))
                    Spacer()
                    Image("human_old")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 50, alignment: .bottom)
                        
                }.padding(.top, 10)
                Slider(value: $currentUserAge, in: 18...60, step: 1)
                    
                
                
                HStack {
                    Image("skinFold_thin")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 40, alignment: .bottom)
                    Spacer()
                    Text("\(Int(currentUserSkinFoldThickness))")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color(activeGreenColor ?? UIColor.black))
                    Spacer()
                    Image("skinFold_thick")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 40, alignment: .bottom)
                }
                    
                Slider(value: $currentUserSkinFoldThickness, in: 2...27, step: 1)
                    
                Button(action: calculateUserSubcutaneousFatPercentage) {
                    Text("=")
                        .foregroundColor(Color(calculationButtonTextColor ?? UIColor.black))
                        .frame(width: 300, height: 50)
                        .background(Color(calculationButtonColor ?? UIColor.lightGray))
                        .clipShape(Capsule())
                }
                    
                HStack {
                    Text(userSubcutaneousFatLevel)
                        .font(.title2)
                        .bold().foregroundColor(Color(userSubcutaneousFatLevelColor ?? UIColor.black))
                    Spacer()
                    Text(userSubcutaneousFatPercentText)
                        .font(.title2)
                        .bold().foregroundColor(Color(userSubcutaneousFatLevelColor ?? UIColor.black))
                }.frame(width: 300, height: 30)
                
                HStack {
                    Image(thinBodyImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: .infinity, height: 30)
                    Spacer()
                    Image(thinIdealBodyImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: .infinity, height: 30)
                    Spacer()
                    Image(idealBodyImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: .infinity, height: 30)
                    Spacer()
                    Image(idealMiddleBodyImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: .infinity, height: 30)
                    Spacer()
                    Image(middleBodyImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: .infinity, height: 30)
                    Spacer()
                    Image(overfatBodyImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: .infinity, height: 30)
                    Spacer()
                    Image(obeseBodyImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: .infinity, height: 30)
                    }
                }
                .padding()
                .background(.white)
                .cornerRadius(10)
            
            VStack {
                HStack {
                    Image("human_short")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 40, alignment: .bottom)
                        .padding(.top, 10)
                    Spacer()
                    Text("\(Int(currentUserHeight))")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color(activeGreenColor ?? UIColor.black))
                    Spacer()
                    Image("human_tall")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 50, alignment: .bottom)
                }
                    
                Slider(value: $currentUserHeight, in: 145...200, step: 1)
                    
                HStack {
                    Image("kettlebell")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 30, alignment: .bottom)
                        .padding(.top, 20)
                    Spacer()
                    Text("\(Int(currentUserMass))")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color(activeGreenColor ?? UIColor.black))
                    Spacer()
                    Image("kettlebell")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 50, alignment: .bottom)
                }
                    
                Slider(value: $currentUserMass, in: 40...125, step: 1)
                
                HStack {
                    Spacer()
                    Button(action:
                                calculateBmi) {
                    Text("=").foregroundColor(Color(calculationButtonTextColor ?? UIColor.black))
                        .frame(width: 300, height: 50)
                        .background(Color(calculationButtonColor ?? UIColor.lightGray))
                        .clipShape(Capsule())
                    }
                    Spacer()
                }
                    
                HStack {
                    Text("ИМТ")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color(bmiLabelTextColor ?? UIColor.black))
                    Spacer()
                    Text("\(String(format: "%.2f", currentUserBmi))").font(.title2)
                        .bold().foregroundColor(Color(userBmiResultColor))
                }.frame(width: 300, height: 30)
            }
            .padding()
            .background(.white)
            .cornerRadius(10)
            .padding(.bottom, 60)
            .padding(.top, 10)
            Spacer()
        }
        .padding()
        .background(Color(backgroundGrayColor ?? UIColor.lightGray))
    }
}

#Preview {
    ContentView()
}
