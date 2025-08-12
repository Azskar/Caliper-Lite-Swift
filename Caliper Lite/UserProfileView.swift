//
//  UserProfileView.swift
//  Caliper Lite Redesign
//
//  Created by Азар Аскаров on 22.07.2025.
//

import SwiftUI

struct UserProfileView: View {
    
    @StateObject private var userProfile = UserProfile()
    let genders = ["Мужской", "Женский"]
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Пол", selection: $userProfile.userGender) {
                    ForEach(genders, id: \.self) {
                        Text($0)
                    }
                }
                .onChange(of: userProfile.userGender) { newValue, oldValue in
                    userProfile.saveGender(newValue)
                }

                
                DatePicker("Дата Рождения", selection: $userProfile.userBirthDate, displayedComponents: .date)
                    .pickerStyle(.wheel)
                    .onChange(of: userProfile.userBirthDate) { newValue, oldValue in userProfile.saveDate(newValue)
                    }

            }
            .navigationTitle("Профиль")
        }//NavigationStack
    }//body
}//View


#Preview {
    UserProfileView()
}
