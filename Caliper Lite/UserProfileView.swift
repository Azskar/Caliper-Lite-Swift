//
//  UserProfileView.swift
//  Caliper Lite Redesign
//
//  Created by Азар Аскаров on 22.07.2025.
//

import SwiftUI

struct UserProfileView: View {
    
    @StateObject private var userProfile = UserProfile()
    
    enum GenderEnum: String, CaseIterable, Identifiable {
        case male = "Male"
        case female = "Female"
        
        var id: String { rawValue }
        
        // Можно добавить дополнительные свойства
        var localizedName: String {
            switch self {
            case .male:
                return String(localized: "Male")
            case .female:
                return String(localized: "Female")
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                /*Picker("Gender", selection: $userProfile.userGender) {
                        ForEach(genders, id: \.self) {
                            Text($0)
                        }
                }
                .onChange(of: userProfile.userGender) { newValue, oldValue in
                        userProfile.saveGender(newValue)
                }*/
                
                Picker("Gender", selection: $userProfile.userGender) {
                    ForEach(GenderEnum.allCases) { gender in
                        Text(gender.localizedName)
                    }
                }
                .onChange(of: userProfile.userGender) { newValue, oldValue in
                        userProfile.saveGender(newValue)
                }
                    
                DatePicker("Date of birth", selection: $userProfile.userBirthDate, displayedComponents: .date)
                    .pickerStyle(.wheel)
                    .onChange(of: userProfile.userBirthDate) { newValue, oldValue in userProfile.saveDate(newValue)
                    }
            }
            .navigationTitle("Profile")
        }//NavigationStack
    }//body
}//View


#Preview {
    UserProfileView()
}
